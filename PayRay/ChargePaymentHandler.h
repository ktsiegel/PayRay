//
//  ChargePaymentHandler.h
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargePaymentHandler : NSObject

- (void)initChargeOf:(float)amount fromUser:(int)myID fromEmail:(NSString *)myEmail fromName:(NSString *)myName toUser:(int)theirID toEmail:(NSString *)theirEmail toName:(NSString *)theirName;

@end
