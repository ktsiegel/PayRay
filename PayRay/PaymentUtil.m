//
//  PaymentUtil.m
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "PaymentUtil.h"
#import "sendgrid.h"
#import "FulfillPaymentHandler.h"
#import "ChargePaymentHandler.h"
#import "Firebase/Firebase.h"

@implementation PaymentUtil

//  Initialize the object and begin listening for charges directed at the user over the database.
- (id)initForUser:(int)userID withEmail:(NSString*)email andName:(NSString *)name {
    self = [super init];
    
    if (self) {
        self.email = email;
        self.userID = userID;
        self.name = name;
        self.incomingCharges = [[Firebase alloc] initWithUrl:
                         [NSString stringWithFormat:@"https://pay-ray.firebaseio.com/users/%i/incoming", userID]];
        
        [self.incomingCharges observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            // Generate a firebase reference to the 'outgoing charge' instance in the sender's DB table.
            Firebase *outRef = [[[Firebase alloc] initWithUrl:
                                  [NSString stringWithFormat:@"https://pay-ray.firebaseio.com/users/%i/outgoing",
                                   [snapshot.value[@"user"] intValue]]] childByAppendingPath:snapshot.value[@"DBref"]];
            
            // Grab the corresponding incoming charge instance in our table.
            Firebase *inRef = [self.incomingCharges childByAppendingPath:snapshot.name];
            
            // Call up a FulfillPaymentHandler, which will take care of the actual transaction and user confirmation,
            // plus updating the database afterwards.
            FulfillPaymentHandler *payer = [[FulfillPaymentHandler alloc] initPaymentOf:[snapshot.value[@"amount"] floatValue] fromUser:self.userID fromEmail:self.email inReference:inRef toUser:[snapshot.value[@"user"] intValue] toEmail:snapshot.value[@"email"] withName:snapshot.value[@"name"] outReference:outRef];
        }];
    }
    
    return self;
}

- (void)chargeUser:(int)newID forAmount:(float)amount {
    [[[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://pay-ray.firebaseio.com/users/%i", newID]] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Get the other user's email
        NSString *newEmail = snapshot.value[@"email"];
        NSString *newName = snapshot.value[@"name"];
        
        // Charge them
        [[ChargePaymentHandler alloc] initChargeOf:amount fromUser:self.userID fromEmail:self.email fromName:self.name toUser:newID toEmail:newEmail toName:newName];
    }];
    
}

@end
