//
//  iBeaconViewController.m
//  PayRay
//
//  Created by aheifetz on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "iBeaconViewController.h"
#import "ViewController.h"
#import "LocationModel.h"

@interface iBeaconViewController ()

@end

@implementation iBeaconViewController {
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    CLBeaconRegion *_region;
    BOOL _inProgress;
    NSMutableArray *_rangedBeacons;
    BOOL _master;
    NSString* _uuid;
    NSString* userId;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _beacons = [[NSMutableDictionary alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _inProgress = NO;
        _uuid = @"7AAF1FFA-7EA5-44A5-B4E8-0A8BBDF0B775";
        _userId = //get from coreData
        
    }
    return self;
}

-(void)createTable
{
    _master = true;
    [self startRangingForBeacons];
}

- (void)createBeaconRegion
{
    if (_region)
        return;
    NSString* uuid = @"7AAF1FFA-7EA5-44A5-B4E8-0A8BBDF0B775";
    NSString* identifier = @"PayRay";
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
    _region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:identifier];
}

- (void)turnOnRanging
{
    NSLog(@"Turning on ranging...");
    
    if (_locationManager.rangedRegions.count > 0) {
        NSLog(@"Didn't turn on ranging: Ranging already on.");
        return;
    }
    
    [self createBeaconRegion];
    [_locationManager startRangingBeaconsInRegion:_region];
    
    NSLog(@"Ranging turned on for region: %@.", _region);
}

- (void)startRangingForBeacons
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    _beacons = [[NSMutableDictionary alloc] init];
    
    [self turnOnRanging];
}

- (void)stopRangingForBeacons
{
    if (_locationManager.rangedRegions.count == 0) {
        NSLog(@"Didn't turn off ranging: Ranging already off.");
        return;
    }
    
    [_locationManager stopRangingBeaconsInRegion:_region];
    
    NSLog(@"Turned off ranging.");
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count == 0) {
        NSLog(@"No beacons found nearby.");
    } else {
        NSLog(@"Found %lu %@.", (unsigned long)[beacons count],
              [beacons count] > 1 ? @"beacons" : @"beacon");
    }
    if(_master) {
        _master = false;
        //create new table on firebase
    }
    for (CLBeacon *beacon in beacons) {
        int majorValue = beacon.major.integerValue;
        int minorValue = beacon.minor.integerValue;
        NSString* beaconUserId = [NSString stringWithFormat:@"%i%i",majorValue, minorValue];
        
        }
        if (isNewBeacon) {
            if (!indexPaths)
                indexPaths = [NSMutableArray new];
            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:NTDetectedBeaconsSection]];
        }
        row++;
    }
    
    return indexPaths;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
