//
//  CalcOrderUtil.m
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "CalcOrderUtil.h"
#import "UsersDistance.h"

struct Triangle
{
    NSString* a;
    NSString* b;
};

@implementation CalcOrderUtil

@synthesize clockwiseOrder;

- (id)initWithMainPerson: (NSString*) identifier andDistances: (NSMutableArray*)distances andOrientations: (NSMutableDictionary*)orientations {
    self = [super init];
    if (self) {
        self.clockwiseOrder = [self findOrderFromPerson:identifier WithDistances:distances andOrientations:orientations];
    }
    return self;
}

-(NSMutableArray*) findOrderFromPerson: (NSString*) person WithDistances: (NSMutableArray*) distances andOrientations: (NSMutableDictionary*) orientations {
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSArray* allKeys = [orientations allKeys];
    NSMutableDictionary* distanceArray = [self calcDistancesArray: distances fromPerson: person withPeople: allKeys];
    
    NSMutableArray* neighbors = [self findNeighborsOf:person usingDistances:[distanceArray objectForKey:person]];
    NSString* right = [neighbors objectAtIndex:1];
    
    
    
    return result;
}

-(NSMutableArray*) findNeighborsOf: (NSString*)person usingDistances: (NSDictionary*)distances {
    NSArray* allKeys = [distances allKeys];
    NSMutableArray* maxNeighbors = [[NSMutableArray alloc] initWithCapacity:2];
    double maxTheta = 0.0;
    
    for(int i = 0; i < [allKeys count]; i++) {
        NSString* a = [allKeys objectAtIndex:i];
        if ([a isEqualToString:person] == NO) {
            for (int j = 0; j < [allKeys count]; j++) {
                NSString* b = [allKeys objectAtIndex:j];
                if ([b isEqualToString:person] == NO && [b isEqualToString: a] == NO) {
                    //this is a triangle
                    struct Triangle triangle;
                    triangle.a = a;
                    triangle.b = b;
                    double distC = [[[distances objectForKey:a] objectForKey:b] doubleValue];
                    double distB = [[[distances objectForKey:a] objectForKey:person] doubleValue];
                    double distA = [[[distances objectForKey:b] objectForKey:person] doubleValue];
                    double theta = atan(((pow(distA,2) + pow(distB,2) - pow(distC,2)) / (2 * distB * distA)));
                    if (theta > maxTheta) {
                        maxTheta = theta;
                        [maxNeighbors replaceObjectAtIndex:0 withObject:a];
                        [maxNeighbors replaceObjectAtIndex:1 withObject:b];
                    }
                }
            }
        }
    }
    return maxNeighbors;
}

-(NSMutableDictionary*) calcDistancesArray: (NSMutableArray*) distances fromPerson: (NSString*) person withPeople: (NSArray*) allPeople {
    NSMutableDictionary* distanceArray = [[NSMutableDictionary alloc] init];
    for (int i=0; i<[allPeople count]; i++) {
        [distanceArray setObject:[[NSMutableDictionary alloc] init] forKey:[allPeople objectAtIndex:i]];
    }
    for (int j=0; j<[distances count]; j++) {
        UsersDistance* distObj = (UsersDistance*)[distances objectAtIndex:j];
        [[distanceArray objectForKey:distObj.personA] setObject: [NSString stringWithFormat:@"%f", [distObj.dist doubleValue]] forKey:distObj.personB];
        [[distanceArray objectForKey:distObj.personB] setObject: [NSString stringWithFormat:@"%f", [distObj.dist doubleValue]] forKey:distObj.personA];
    }
    return distanceArray;
}

@end

















