//
//  RecieptItem.m
//  PayRay
//
//  Created by Nina Lu on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "RecieptItem.h"

@implementation RecieptItem

-(id)initWithItem :(NSString*)item cost:(NSString*) cost{
    self = [super init];
    if(self) {
        self.item=item;
        self.cost=cost;
    }
    return self;
}
@end
