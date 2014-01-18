//
//  CalcOrderUtil.h
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcOrderUtil : NSObject
@property (nonatomic, strong) NSMutableArray* clockwiseOrder;

-(NSMutableArray*) findOrderFromPerson: (NSString*) person WithDistances: (NSMutableArray*)distances andOrientations: (NSMutableDictionary*) orientations;
@end

