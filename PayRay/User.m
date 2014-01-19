//
//  User.m
//  PayRay
//
//  Created by Kshitij Grover on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic email;
@dynamic name;
@dynamic uid;
-(id)initWithEmail :(NSString*)email :(NSString*)name :(NSNumber*)uid {
    if(!(self=[super init]))
        return nil;
    self.email=email;
    self.name=name;
    self.uid=uid;
    return self;
}
@end
