//
//  User.m
//  PayRay
//
//  Created by Kshitij Grover on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize email;
@synthesize name;
@synthesize uid;

-(id)initWithEmail :(NSString*)emaila :(NSString*)namea :(NSNumber*)uida {
    if(!(self=[super init]))
        return nil;
    self.email=emaila;
    self.name=namea;
    self.uid=uida;
    return self;
}
@end
