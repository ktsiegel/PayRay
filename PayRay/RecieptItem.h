//
//  RecieptItem.h
//  PayRay
//
//  Created by Nina Lu on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecieptItem : NSObject
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSString * cost;
-(id)initWithItem:(NSString*)item cost:(NSString*) cost;
@end
