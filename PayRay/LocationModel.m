//
//  LocationModel.m
//  PayRay
//
//  Created by aheifetz on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "LocationModel.h"

@interface LocationModel ()

@end

@implementation LocationModel {
    NSMutableArray* beacons;
    NSMutableDictionary* headings;
    NSString* uuid;
    NSString* majorMinorId;
}

-(void)loadInitialData {
    uuid = @"7AAF1FFA-7EA5-44A5-B4E8-0A8BBDF0B775";
    
    //Initialize later once logged in.
    majorMinorId = @"";
    
    beacons = [[NSMutableArray alloc] init];
    headings = [[NSMutableDictionary alloc] init];
}

-(void)login: (NSString*) user_id  {
    majorMinorId = user_id;
}



@end
