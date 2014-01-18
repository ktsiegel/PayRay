//
//  UsersDistance.m
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "UsersDistance.h"

@implementation UsersDistance

@synthesize personA;
@synthesize personB;
@synthesize dist;

- (id)initWithPerson: (NSString*)person1 andPerson: (NSString*)person2 withDistance: (NSNumber*) distance {
    self = [super init];
    if (self) {
        self.personA = person1;
        self.personB = person2;
        self.dist = distance;
    }
    return self;
}

@end
