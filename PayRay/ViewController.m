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
#import "User.h"

@interface ViewController ()
@property NSMutableArray* people;
@property SKView *spriteView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    SpaceshipScene* hello = [[SpaceshipScene alloc] initWithSize:CGSizeMake(768,1024)];
    self.spriteView = (SKView *) self.view;
    [self.spriteView presentScene: hello];
    self.people=[NSMutableArray arrayWithObjects:
                 [[User alloc] initWithEmail:@"dick@mit.edu" :@"Dick" :[NSNumber numberWithInt:1]],
                 [[User alloc] initWithEmail:@"bigJ@mit.edu" :@"Johnson" :[NSNumber numberWithInt:2]],
                 [[User alloc] initWithEmail:@"wang@mit.edu" :@"Wang" :[NSNumber numberWithInt:42]],
                 [[User alloc] initWithEmail:@"peekaboo@mit.edu" :@"Peeper" :[NSNumber numberWithInt:5]],
                 [[User alloc] initWithEmail:@"trouser-snake@mit.edu" :@"Python" :[NSNumber numberWithInt:3]],
                 [[User alloc] initWithEmail:@"wat@mit.edu" :@"Water" :[NSNumber numberWithInt:18]], nil];
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

