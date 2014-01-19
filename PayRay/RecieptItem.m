//
//  RecieptItem.m
//  PayRay
//
//  Created by Nina Lu on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "RecieptItem.h"

@implementation RecieptItem
@dynamic item;
@dynamic cost;
-(id)initWithItem :(NSString*)item :(NSNumber*) cost{
    if(!(self=[super init]))
        return nil;
    self.item=item;
    self.cost=cost;
    return self;
}
@end
