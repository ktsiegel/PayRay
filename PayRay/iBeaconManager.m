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

@interface iBeaconManager ()

@end

@implementation iBeaconManager {
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    CLBeaconRegion *_transmitRegion;
    CLBeaconRegion *_monitorRegion;
    CBPeripheralManager* _peripheralManager;
    NSMutableArray *_rangedBeacons;
    BOOL _master;
    BOOL _slave;
    NSString* _uuid;
    NSString* _userId;
    Firebase* _baseRef;
    NSDictionary* _beaconPeripheralData;

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
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _uuid = @"7AAF1FFA-7EA5-44A5-B4E8-0A8BBDF0B775";
        _baseRef = [[Firebase alloc] initWithUrl:@"https://pay-ray.firebaseIO.com"];
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
        //We are the master: add everyone else in range to the table only once
        _master = false;
        //Add a table to TABLES
        Firebase* tablesRef = [_baseRef childByAppendingPath:@"TABLES"];
        [tablesRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            int newId = snapshot.childrenCount + 1;
            
            //First, add yourself to the table
            NSString* newIdString = [NSString stringWithFormat:@"%i/table_users",newId, _userId];
            NSLog(newIdString);
            [[tablesRef childByAppendingPath:newIdString] updateChildValues:@{_userId: _userId}];
            
            //Next, add all users to this table
            NSMutableArray* users = [self addUsers:beacons toTable:newId];
            
            //Then, add yourself to the new list of user ids
            [users addObject:_userId];
            
            //Finally, add the table to all users (including yourself). This will trigger a change event, which will set _slave = true
            [self addTable:newId toUsers:users];
        }];
    }
    else if(_slave) {
        //We are a slave: get the distance to all other users and upload it to Firebase so the master can use it
        _slave = false;
        NSLog(@"slave runs");
        NSMutableArray* distances = [self getDistancesToBeacons:beacons];
        //Send the distance objects off
        
        
    }
}
-(double)getDistanceToBeacon:(CLBeacon*)beacon {
    double accuracy = beacon.accuracy;
    return accuracy;
}

-(NSMutableArray*)getDistancesToBeacons: (NSArray*)beacons {
    NSMutableArray* distances = [[NSMutableArray alloc] init];
    for (CLBeacon* beacon in beacons) {
        int majorValue = beacon.major.integerValue;
        int minorValue = beacon.minor.integerValue;
        NSString* beaconUserId = [NSString stringWithFormat:@"%04i%04i",majorValue, minorValue];
        double distance = [self getDistanceToBeacon:beacon];
        NSLog(@"Distance to beacon %@ is %f", beaconUserId, distance);
        UsersDistance* ud = [[UsersDistance alloc] init];
        ud.personA = _userId;
        ud.personB = beaconUserId;
        ud.dist = [NSNumber numberWithDouble:distance];
        [distances addObject:ud];
    }
    return distances;
}

@end
