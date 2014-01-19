//
//  ChargePaymentHandler.m
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "ChargePaymentHandler.h"
#import "sendgrid.h"
#import "FulfillPaymentHandler.h"
#import "PaymentUtil.h"
#import "Firebase/Firebase.h"

@implementation ChargePaymentHandler

- (void)initChargeOf:(float)amount fromUser:(int)myID fromEmail:(NSString *)myEmail fromName:(NSString *)myName toUser:(int)theirID toEmail:(NSString *)theirEmail toName:(NSString *)theirName {
    Firebase *outgoing = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://pay-ray.firebaseio.com/users/%i/outgoing", myID]];
    Firebase *incoming = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://pay-ray.firebaseio.com/users/%i/incoming", theirID]];
    
    Firebase *outChild = [outgoing childByAutoId];
    [outChild setValue:@{@"amount": [NSNumber numberWithFloat:amount], @"user": [NSNumber numberWithInt:theirID], @"email": theirEmail, @"name":theirName, @"status": @"pending"}];
    
    Firebase *inChild = [incoming childByAutoId];
    [inChild setValue:@{@"amount": [NSNumber numberWithFloat:amount], @"user": [NSNumber numberWithInt:myID], @"email": myEmail, @"name":myName, @"status": @"pending", @"DBRef": outChild.name}];
}

@end
