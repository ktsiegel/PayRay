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
#import "RecieptItem.h"

@interface ViewController ()
@property NSMutableArray* people;
@property SKView *spriteView;
@property (nonatomic) iBeaconManager* beaconManager;
@property NSMutableArray* purchases;
@end

@implementation ViewController
@synthesize renderedText;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    NSLog(@"%@",renderedText);
    _purchases = [self parsePurchases: renderedText];
    
    self.beaconManager = [iBeaconManager sharedIBeaconManager];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    [self.beaconManager startIBeacon:uid];
    

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
    [(SpaceshipScene*)self.spriteView.scene popPurchases:_purchases];
    
}

// @param dists  a mutablelist of 
- (void) calculate{

}

-(NSMutableArray*) parsePurchases: (NSString*) text {
    NSMutableArray* purchases = [[NSMutableArray alloc] init];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+.[0-9][0-9]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
    NSString* purchase;
    int count = 1;
    while (range.location != NSNotFound) {
        purchase = [text substringWithRange: range];
        [purchases addObject: [[RecieptItem alloc] initWithItem :[NSString stringWithFormat: @"item %i",count] cost: purchase]];
        
        
        count++;
    }
    return purchases;
}

@end

