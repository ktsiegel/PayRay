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
    self.people=[NSMutableArray arrayWithObjects:@"alice",@"tim",@"bob", nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)spaceshipReady{
    int x=0;
    for(NSString *name in self.people){
        [(SpaceshipScene*)self.spriteView.scene newPersonWithPosition:(int) 100+x*60 :(int) 400 :(int)60 :name];
        x++;
    }
}

@end
