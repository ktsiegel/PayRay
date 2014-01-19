//
//  iBeaconViewController.m
//  PayRay
//
//  Created by aheifetz on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "iBeaconManager.h"
#import "ViewController.h"
#import "LocationModel.h"
#import "UsersDistance.h"
#import <Firebase/Firebase.h>
#import "CalcOrderUtil.h"

@interface iBeaconManager ()

@end

@implementation iBeaconManager {
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    NSMutableDictionary *_beaconDists;
    NSMutableDictionary *_distSamples;
    CLBeaconRegion *_transmitRegion;
    CLBeaconRegion *_monitorRegion;
    CBPeripheralManager* _peripheralManager;
    NSMutableArray *_rangedBeacons;
    BOOL _master;
    BOOL _slave;
    NSString* _uuid;
    NSString* _userId;
    NSString* _tableId;
    Firebase* _baseRef;
    NSDictionary* _beaconPeripheralData;
    int count;

}

+(iBeaconManager*) sharedIBeaconManager {
    static iBeaconManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[iBeaconManager alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _beacons = [[NSMutableDictionary alloc] init];
        _beaconDists = [[NSMutableDictionary alloc] init];
        _distSamples = [[NSMutableDictionary alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _uuid = @"7AAF1FFA-7EA5-44A5-B4E8-0A8BBDF0B775";
        _baseRef = [[Firebase alloc] initWithUrl:@"https://pay-ray.firebaseIO.com"];
        count=0;
    }
    return self;
}

-(void)createTable
{
    _master = true;
}

-(void)enslave {
    _slave = true;
}

-(void) startIBeacon: (NSString*)userId {
    _userId = userId;
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:_uuid];
    NSString* maj = [userId substringWithRange:NSMakeRange(0, 4)];
    NSString* min = [userId substringWithRange:NSMakeRange(4, 4)];
    _transmitRegion =   [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                        major:maj.intValue
                                        minor:min.intValue
                                        identifier:@"PayRay"];
    _monitorRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"PayRay"];

    [_locationManager startRangingBeaconsInRegion:_monitorRegion];
    
    
    
    [self transmitBeacon];

}

- (void)transmitBeacon {
    _beaconPeripheralData = [_transmitRegion peripheralDataWithMeasuredPower:nil];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [_peripheralManager startAdvertising: _beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
        [_peripheralManager stopAdvertising];
    }
}

-(NSMutableArray*)addUsers:(NSArray*)beacons toTable:(int)tableId
{
    NSMutableArray* users = [[NSMutableArray alloc] init];
    NSLog(@"Started");
    for (CLBeacon *beacon in beacons) {
        int majorValue = beacon.major.integerValue;
        int minorValue = beacon.minor.integerValue;
        NSString* beaconUserId = [NSString stringWithFormat:@"%04i%04i",majorValue, minorValue];
        NSLog(@"%@", beaconUserId);
        [users addObject:beaconUserId];
        Firebase* tableUsersRef = [_baseRef childByAppendingPath:[NSString stringWithFormat:@"TABLES/%i/table_users/", tableId, beaconUserId]];
        NSLog(@"Table is the following: %@", [NSString stringWithFormat:@"TABLES/%i/table_users/%@", tableId, beaconUserId]);
        
        [tableUsersRef updateChildValues:@{beaconUserId: beaconUserId}];
    }
    return users;
}

-(void)addTable:(int)tableId toUsers:(NSMutableArray*)users
{
    for (NSString* user in users) {
        Firebase* tableUsersRef = [_baseRef childByAppendingPath:[NSString stringWithFormat:@"USERS/%@", user]];
        [tableUsersRef updateChildValues:@{@"table": [NSNumber numberWithInt: tableId]}];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [_locationManager startRangingBeaconsInRegion:_transmitRegion];
}



- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count == 0) {
        NSLog(@"No beacons found nearby.");
    } else {
        NSLog(@"Found %lu %@.", (unsigned long)[beacons count],
              [beacons count] > 1 ? @"beacons" : @"beacon");
    }
    if(_master) {
        _master = false;
        //We are the master: add everyone else in range to the table only once
        //Add a table to TABLES
        Firebase* tablesRef = [_baseRef childByAppendingPath:@"TABLES"];
        [tablesRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            int newId = snapshot.childrenCount + 1;
            
            //First, add yourself to the table
            NSString* newIdString = [NSString stringWithFormat:@"%i/table_users",newId, _userId];
            NSLog(newIdString);
            [[tablesRef childByAppendingPath:newIdString] updateChildValues:@{_userId: _userId}];
            _tableId = newIdString;
            
            //Next, add all users to this table
            NSMutableArray* users = [self addUsers:beacons toTable:newId];
            
            //Then, add yourself to the new list of user ids
            [users addObject:_userId];
            
            //Finally, add the table to all users (including yourself). This will trigger a change event, which will set _slave = true
            [self addTable:newId toUsers:users];
        }];
    }
    else if(_slave) {
        //We are a slave: get the distance to all other users and upload it to
        //Firebase so the master can use it
        Firebase* userRef = [_baseRef childByAppendingPath:[NSString stringWithFormat:@"USERS/%@/table", _userId]];
        count++;
        [userRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSString* table = snapshot.value;
            _tableId = table;
            NSMutableArray* distances = [self getDistancesToBeacons:beacons forTable:table];
            //Send the distance objects off
            if(count == 6)
                [[[CalcOrderUtil alloc] init] findOrderFromPerson: _userId WithDistances: distances];

        }];
        
        
    }
}
-(void)locationManager: (CLLocationManager*)manager didUpdateHeading:(CLHeading *)newHeading {
    if(_slave) {
        NSLog(@"Called heading update");
        CLLocationDirection currHeading = newHeading.magneticHeading;
        if(_tableId) {
            Firebase* tableUsersRef = [_baseRef childByAppendingPath:[NSString stringWithFormat:@"TABLES/%@/%@", _tableId, _userId]];
                [tableUsersRef updateChildValues:@{@"center_heading": [NSString stringWithFormat:@"%f",currHeading]}] ;
        }
    }
}

-(double)getDistanceToBeacon:(CLBeacon*)beacon {
    double acc = beacon.accuracy;
    
    if (!_beaconDists[beacon]) {
        [_beaconDists setObject:@(0.0) forKey:beacon];
        [_distSamples setObject:@0 forKey:beacon];
    }
        
    if ([_distSamples[beacon] integerValue] <= 5)
        [_distSamples setObject:@([_distSamples[beacon] integerValue] + 1) forKey:beacon];
    
    double recip = 1.0/[_distSamples[beacon] floatValue];
    double accuracy = (acc/recip + (1-recip) * [_beaconDists[beacon] floatValue]);
    
    [_beaconDists setObject:[NSNumber numberWithFloat:accuracy] forKey:beacon];
    return accuracy;
}

-(NSMutableArray*)getDistancesToBeacons: (NSArray*)beacons forTable:(NSString*)table{
    NSMutableArray* distances = [[NSMutableArray alloc] init];
    Firebase* tableUsersRef = [_baseRef childByAppendingPath:[NSString stringWithFormat:@"TABLES/%@/%@", table, _userId]];
    for (CLBeacon* beacon in beacons) {
        int majorValue = beacon.major.integerValue;
        int minorValue = beacon.minor.integerValue;
        NSString* beaconUserId = [NSString stringWithFormat:@"%04i%04i",majorValue, minorValue];
        double distance = [self getDistanceToBeacon:beacon];
        //Get heading of beacon here, set it using beaconUserId
        Firebase* distancesRef = [tableUsersRef childByAppendingPath:@"distances"];
        [distancesRef updateChildValues: @{beaconUserId: [NSString stringWithFormat:@"%f", distance]}] ;
        UsersDistance* ud = [[UsersDistance alloc] init];
        ud.personA = _userId;
        ud.personB = beaconUserId;
        ud.dist = [NSNumber numberWithDouble:distance];
    }
    return distances;
}

@end
