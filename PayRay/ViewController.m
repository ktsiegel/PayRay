//
//  ViewController.m
//  PayRay
//
//  Created by Kathryn Siegel on 1/17/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
#import "HelloScene.h"
#import "SpaceshipScene.h"

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
    HelloScene* hello = [[HelloScene alloc] initWithSize:CGSizeMake(768,1024)];
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

@end
