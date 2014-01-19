//
//  SyncViewController.m
//  PayRay
//
//  Created by Kshitij Grover on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "SyncViewController.h"
#import "AppDelegate.h"
#import "iBeaconManager.h"
#import <Firebase/Firebase.h>

@interface SyncViewController ()
@property (nonatomic) iBeaconManager* beaconManager;
@end

@implementation SyncViewController
@synthesize syncButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.beaconManager = [iBeaconManager sharedIBeaconManager];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    [self.beaconManager startIBeacon:uid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)syncApp:(UIButton *)sender {
    [self.syncButton setBackgroundColor:[UIColor grayColor]];
    
    [self.beaconManager createTable];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    NSString* url = [NSString stringWithFormat: @"https://pay-ray.firebaseio.com/USERS/%@/table", uid];
    Firebase* dataRef = [[Firebase alloc] initWithUrl:url];
    [dataRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"Received table value: %@", snapshot.value);
        if(snapshot.value) {
            [self.beaconManager enslave];
        }
        
    }];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:@"syncSegue" sender:sender];
    });
}
@end
