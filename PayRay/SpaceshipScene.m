//
//  SpaceshipScene.m
//  PayRay
//
//  Created by Nina Lu on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "SpaceshipScene.h"
#import "ViewController.h"
static NSString * const kAnimalNodeName = @"movable";
@interface SpaceshipScene ()
@property BOOL contentCreated;
@property int count;
@property NSArray* people;
@property ViewController* viewController;
@property CGFloat radius;
@property (nonatomic, strong) SKShapeNode *selectedNode;
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
    self.physicsWorld.gravity = CGVectorMake(0,0);
}

- (void)createSceneContents
{
     self.radius=300.0;
    self.backgroundColor = [SKColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:.9];
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
    ball.strokeColor=[SKColor colorWithRed:0.15 green:0.15 blue:0.8 alpha:.8];
    ball.path = myPath;
    ball.fillColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.8 alpha:.8];
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
    ball.strokeColor=[SKColor colorWithRed:0.7 green:0.15 blue:0.15 alpha:.8];
    ball.path = myPath;
    ball.fillColor = [SKColor colorWithRed:0.7 green:0.15 blue:0.15 alpha:.8];
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
    SKSpriteNode* center=[[SKSpriteNode alloc]init];
    center.position = CGPointMake(self.size.width/2,self.size.height/2);
    [self addChild:center];
    center.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:.1];
    int x=1;
    CGFloat incre=2*M_PI/([people count]+1);
    for(NSString *name in people){
        CGMutablePathRef arc= CGPathCreateMutable();
        CGPathAddArc(arc, NULL, self.size.width/2, self.size.height/2, self.radius, -M_PI_2,-M_PI_2+incre*x, TRUE);
        SKShapeNode* next=[self newPersonWithPosition:50 :self.size.height/2 :60 :name];
        [self addChild:next];
        [next runAction:[SKAction followPath:arc asOffset:NO orientToPath:YES duration:1] completion:^{
            next.zRotation=0;
            CGPathRelease(arc);
            next.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:60];
            SKPhysicsJointSpring* joint= [SKPhysicsJointSpring jointWithBodyA:center.physicsBody bodyB:next.physicsBody anchorA:center.position anchorB:next.position];
            joint.damping = 0.05;
            joint.frequency = 0.8;
            [self.physicsWorld addJoint:joint];
            [next.physicsBody applyForce: CGVectorMake(20,20)];

        }];
        x++;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}
- (void)selectNodeForTouch:(CGPoint)touchLocation {
    //1
    SKShapeNode *touchedNode;
    if([[self nodeAtPoint:touchLocation] isKindOfClass: [SKShapeNode class]]){
        touchedNode = (SKShapeNode *)[self nodeAtPoint:touchLocation];
    }
    else if([[self nodeAtPoint:touchLocation] isKindOfClass: [SKLabelNode class]]){
        touchedNode = (SKShapeNode *)[self nodeAtPoint:touchLocation].parent;
    }
    
    //2

		_selectedNode = touchedNode;
		//3
		SKAction *sequence = [SKAction sequence:@[
                                                  [SKAction scaleBy:2.0 duration:0.1],
                                                  [SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
                                                  [SKAction rotateByAngle:0.0 duration:0.1],
                                                  [SKAction rotateByAngle:degToRad(4.0f) duration:0.1],
                                                  [SKAction scaleBy:.5 duration:0.1]]];
        [_selectedNode runAction:[SKAction repeatAction:sequence count:1]];
    
}
float degToRad(float degree) {
	return degree / 180.0f * M_PI;
}
@end