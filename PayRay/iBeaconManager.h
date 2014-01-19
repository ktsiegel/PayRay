//
//  iBeaconViewController.h
//  PayRay
//
//  Created by aheifetz on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <UIKit/UIKit.h>

@interface iBeaconManager :
NSObject <CLLocationManagerDelegate, CBPeripheralManagerDelegate>
-(void) startIBeacon: (NSString*)userId;
-(void)createTable;
-(void)enslave;
+(iBeaconManager*) sharedIBeaconManager;

@end
