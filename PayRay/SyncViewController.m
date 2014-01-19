//
//  SyncViewController.m
//  PayRay
//
//  Created by Kshitij Grover on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "SyncViewController.h"
#import "AppDelegate.h"

@interface SyncViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)syncApp:(UIButton *)sender {
    [self.syncButton setBackgroundColor:[UIColor grayColor]];
    
    [self performSegueWithIdentifier: @"syncSegue" sender: sender];
}
@end
