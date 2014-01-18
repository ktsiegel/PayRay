//
//  SpaceshipScene.m
//  PayRay
//
//  Created by Nina Lu on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "SpaceshipScene.h"
#import "ViewController.h"

@interface SpaceshipScene ()
@property BOOL contentCreated;
@property int count;
@property NSArray* people;
@property ViewController* viewController;
@property CGFloat radius;
@end

@implementation SpaceshipScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
    UIResponder *responder = view;
    while (![responder isKindOfClass:[ViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    self.viewController=(ViewController *)responder;
        [self.viewController spaceshipReady];
}

- (void)createSceneContents
{
    self.radius=300.0;
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
   SKShapeNode *ball=[self newCenter];
    [self addChild:ball];
    self.count=0;
}

- (SKShapeNode *)newCenter
{
    SKShapeNode* ball = [[SKShapeNode alloc] init];
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0,0, 60, 0, M_PI*2, YES);
    ball.path = myPath;
    ball.fillColor = [SKColor blueColor];
    ball.position = CGPointMake(self.size.width/2, self.size.height/2-self.radius);
    return ball;
}
- (SKLabelNode *)newNameNode:(NSString*)name
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Georgia"];
    helloNode.text = name;
    helloNode.fontSize = 30;
    helloNode.name = name;
    helloNode.position=CGPointMake(0,0);
    return helloNode;
}
- (SKShapeNode*)newPersonWithPosition:(int) x :(int) y :(int)size :(NSString*)name
{
    SKShapeNode* ball = [[SKShapeNode alloc] init];
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0,0, size, 0, M_PI*2, YES);
    ball.path = myPath;
    ball.fillColor = [SKColor redColor];
    ball.position = CGPointMake(x,y);
    SKLabelNode * nameTag=[self newNameNode:name];
    [ball addChild:nameTag];
    return ball;
}
- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction: blinkForever];
    
    return light;
}
-(void)populate:(NSMutableArray*) people{
    int x=1;
    CGFloat incre=2*M_PI/([people count]+1);
    for(NSString *name in people){
        CGMutablePathRef arc= CGPathCreateMutable();
        CGPathAddArc(arc, NULL, self.size.width/2, self.size.height/2, self.radius, -M_PI_2,-M_PI_2+incre*x, TRUE);
        SKShapeNode* next=[self newPersonWithPosition:(int) 50 :(int) self.size.height/2 :(int)60 :name];
        [self addChild:next];
        [next runAction:[SKAction followPath:arc asOffset:NO orientToPath:YES duration:1] completion:^{
            next.zRotation=0;
        }];
        
        x++;
        CGPathRelease(arc);
    }
}
@end