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
@property int mode;
@property CGPoint oldLoc;
@property SKShapeNode *center;
@property (nonatomic, strong) SKShapeNode *other;

@end
static const uint32_t centerCategory = 0x1 << 0;
static const uint32_t peopleCategory = 0x1 << 1;

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
    self.physicsWorld.contactDelegate = self;
    self.radius=300.0;
    self.backgroundColor = [SKColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKColor* youColor=[SKColor colorWithRed:0.15 green:0.15 blue:0.8 alpha:1.0];
    
    SKShapeNode *ball=[self newCenterWith:youColor :60 :@"You"];
    [self addChild:ball];
    ball.name=@"You";
    SKColor* payColor=[SKColor colorWithRed:0.15 green:0.8 blue:0.15 alpha:1.0];
    
    self.center=[self newCenterWith:payColor :120 :@"Pay"];
    self.center.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.center.name=@"Pay";
    [self addChild:self.center];
    self.count=0;
    self.mode=0;
}

- (SKShapeNode *)newCenterWith: (SKColor*) color :(int)size :(NSString*)name
{
    SKShapeNode* ball = [[SKShapeNode alloc] init];
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0,0, (CGFloat)size, 0, M_PI*2, YES);
    ball.strokeColor=color;
    ball.path = myPath;
    ball.fillColor = color;
    ball.position = CGPointMake(self.size.width/2, self.size.height/2-self.radius);
    SKLabelNode * nameTag=[self newNameNode:name];
    [ball addChild:nameTag];
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
    ball.strokeColor=[SKColor colorWithRed:0.7 green:0.15 blue:0.15 alpha:1.0];
    ball.path = myPath;
    ball.fillColor = [SKColor colorWithRed:0.7 green:0.15 blue:0.15 alpha:1.0];
    ball.position = CGPointMake(x,y);
    SKLabelNode * nameTag=[self newNameNode:name];
    ball.name=name;
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
    self.center.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:120];
    self.center.physicsBody.categoryBitMask = centerCategory;
    self.center.physicsBody.collisionBitMask = 0x0;
    self.center.physicsBody.contactTestBitMask = peopleCategory;
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
            next.physicsBody.categoryBitMask = peopleCategory;
            next.physicsBody.collisionBitMask = 0x0;
            next.physicsBody.contactTestBitMask = 0x0;
            //SKPhysicsJointSpring* joint= [SKPhysicsJointSpring jointWithBodyA:self.center.physicsBody bodyB:next.physicsBody anchorA:self.center.position anchorB:next.position];
            //joint.damping = 0.05;
            //joint.frequency = 0.8;
            //[self.physicsWorld addJoint:joint];
            //[next.physicsBody applyForce: CGVectorMake(20,20)];
            
        }];
        x++;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    if(self.mode!=3)
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
    else{
        [self moveBack];
        return;
    }
    if([touchedNode isEqual: self.center] && self.mode==0){
        self.mode=3;
        _selectedNode=touchedNode;
        return;
    }
    if(self.mode==1){
        if(![_selectedNode isEqual:touchedNode]){
            [self moveBack];
            self.mode=0;
            return;
            
        }
    }
    _selectedNode = touchedNode;
    if([_selectedNode isEqual:self.center]){
        self.mode=3;
        return;
    }
    if(self.mode==0){
        //2
        
        self.oldLoc=_selectedNode.position;
        self.mode=1;
        
        //3
        SKAction *sequence = [SKAction sequence:@[
                                                  [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2) duration:.1],
                                                  [SKAction scaleBy:3.0 duration:0.2],
                                                  
                                                  [SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
                                                  [SKAction rotateByAngle:0.0 duration:0.1],
                                                  [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]
                                                  ]];
        [_selectedNode runAction:[SKAction repeatAction:sequence count:1] completion:^{
            
            
        }];
    }
    
    
}
-(void)moveBack{
    if(self.mode!=3 && _selectedNode!=self.center){
        self.mode=0;
        SKAction *sequence = [SKAction sequence:@[
                                                  
                                                  [SKAction moveTo:self.oldLoc duration:0.1],
                                                  [SKAction scaleBy:(float)1/3 duration:0.2]
                                                  ]];
        [_selectedNode runAction:[SKAction repeatAction:sequence count:1] completion:^{
            _selectedNode=nil;
            _other=nil;
        }];
    }
}
float degToRad(float degree) {
	return degree / 180.0f * M_PI;
}
- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_selectedNode position];
    if([_selectedNode isEqual: self.center]) {
        self.mode=3;
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint positionInScene = [touch locationInNode:self];
	CGPoint previousPosition = [touch previousLocationInNode:self];
    
	CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    
	[self panForTranslation:translation];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint positionInScene = [touch locationInNode:self];
	CGPoint previousPosition = [touch previousLocationInNode:self];
    
	CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    
	[self panForTranslation:translation];
    if(self.mode==3 && [_selectedNode isEqual:self.center]){
        if(self.other){
            if([self.center.name isEqualToString:@"Charge"]){
                ((SKLabelNode*)[self.center childNodeWithName:@"Pay"]).text=[NSString stringWithFormat:@"Charge %@",self.other.name];
                
            }
            else{
                ((SKLabelNode*)[self.center childNodeWithName:@"Pay"]).text=[NSString stringWithFormat:@"Pay %@",self.other.name];
            }
        }
        else if([_selectedNode isEqual:self.center]){
            [self toggleCenter];
        }
        self.mode=0;
        _other=nil;
        _selectedNode=nil;
        SKAction *sequence = [SKAction sequence:@[
                                                  [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2) duration:.2]
                                                  ]];
        [self.center runAction:[SKAction repeatAction:sequence count:1]];
    }
    
}
-(void)toggleCenter{
    if([self.center.name isEqualToString:@"Charge"]){
        ((SKLabelNode*)[self.center childNodeWithName:@"Pay"]).text=[NSString stringWithFormat:@"Pay"];
        self.center.name=@"Pay";
        self.center.strokeColor=[SKColor colorWithRed:0.15 green:0.8 blue:0.15 alpha:1.0];
        self.center.fillColor=[SKColor colorWithRed:0.15 green:0.8 blue:0.15 alpha:1.0];
    }
    else{
        
        ((SKLabelNode*)[self.center childNodeWithName:@"Pay"]).text=[NSString stringWithFormat:@"Charge"];
        self.center.name=@"Charge";
        self.center.strokeColor=[SKColor brownColor];
        self.center.fillColor=[SKColor brownColor];
    }
}
- (void)didEndContact:(SKPhysicsContact *)contact {
    // do whatever you need to do when a contact ends
}
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *body;
    if(contact.bodyA.categoryBitMask == peopleCategory){
        body=contact.bodyA;
    }
    else if(contact.bodyB.categoryBitMask == peopleCategory){
        body=contact.bodyB;
    }
    _other=(SKShapeNode*)body.node;
    float opp=(float)(1/1.3);
    
    SKAction *sequence = [SKAction sequence:@[
                                              [SKAction scaleBy:1.3 duration:.01],
                                              [SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
                                              [SKAction rotateByAngle:0.0 duration:0.1],
                                              [SKAction rotateByAngle:degToRad(4.0f) duration:0.1],
                                              [SKAction scaleBy:opp duration:.01]
                                              ]];
    [_other runAction:[SKAction repeatAction:sequence count:1]];
    if(self.mode==3){
        if(_other.physicsBody.categoryBitMask==peopleCategory){
            if([self.center.name isEqualToString:@"Pay"]){
                ((SKLabelNode*)[self.center childNodeWithName:@"Pay"]).text=[NSString stringWithFormat:@"Pay %@",self.other.name];
            }
            else{
                ((SKLabelNode*)[self.center childNodeWithName:@"Pay"]).text=[NSString stringWithFormat:@"Charge %@",self.other.name];
            }
        }
    }
    NSLog(@"hi%@", body.node.name);
}
@end