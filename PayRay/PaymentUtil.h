//
//  PaymentUtil.h
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentUtil : NSObject

@property(nonatomic, strong) NSString* email;
@property(nonatomic, strong) NSString* password;

-(BOOL) ChargeUser: (NSString *)userID forAmount: (float)amount;
-(void) PayTo: (NSString *)email forAmount: (float)amount;

@end
