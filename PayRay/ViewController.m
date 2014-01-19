//
//  ViewController.m
//  PayRay
//
//  Created by Kathryn Siegel on 1/17/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
#import "SpaceshipScene.h"

@interface ViewController ()
@property NSMutableArray* people;
@property SKView *spriteView;
@end

@implementation ViewController

@synthesize beaconManager = _beaconManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}

- (iBeaconManager *)beaconManager
{
    if (_beaconManager != nil) {
        return _beaconManager;
    }
    else {
        return [iBeaconManager init];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    SpaceshipScene* hello = [[SpaceshipScene alloc] initWithSize:CGSizeMake(768,1024)];
    self.spriteView = (SKView *) self.view;
    [self.spriteView presentScene: hello];
    self.people=[NSMutableArray arrayWithObjects:@"alice",@"tim",@"bob",@"helen",@"joe",@"water", nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)spaceshipReady{
    [(SpaceshipScene*)self.spriteView.scene populate:self.people];
}

// @param dists  a mutablelist of 
- (void) calculate{

}

@end

