//
//  AppDelegate.h
//  PayRay
//
//  Created by Kathryn Siegel on 1/17/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBeaconManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

@end
