//
//  FulfillPaymentHandler.h
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface FulfillPaymentHandler : NSObject <UIAlertViewDelegate>

@property(nonatomic) float amount;
@property(nonatomic) int senderID;
@property(nonatomic) NSString* senderEmail;
@property(nonatomic) Firebase* senderDBRef;
@property(nonatomic) int recipID;
@property(nonatomic) NSString* recipEmail;
@property(nonatomic) Firebase* recipDBRef;

- (id)initPaymentOf:(float)amount fromUser:(int)senderID fromEmail:(NSString *)senderEmail inReference:(Firebase *)inRef toUser:(int)recipID toEmail:(NSString *)recipEmail withName:(NSString *)name outReference:(Firebase *)outRef;

@end
