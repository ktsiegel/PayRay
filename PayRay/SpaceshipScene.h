//
//  SpaceshipScene.h
//  PayRay
//
//  Created by Nina Lu on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SpaceshipScene : SKScene <SKPhysicsContactDelegate>
@property NSMutableArray* purchases;
- (SKShapeNode*)newPersonWithPosition:(int) x :(int) y :(int)size :(NSString*)name;
-(void) populate:(NSMutableArray*)people;
-(void) popPurchases:(NSMutableArray*)purchases;
@end
