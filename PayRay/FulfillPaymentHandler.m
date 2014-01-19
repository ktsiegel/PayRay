//
//  FulfillPaymentHandler.m
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "FulfillPaymentHandler.h"
#import <Firebase/Firebase.h>
#import <sendgrid.h>

@implementation FulfillPaymentHandler

- (id)initPaymentOf:(float)amount fromUser:(int)senderID fromEmail:(NSString *)senderEmail inReference:(Firebase *)inRef toUser:(int)recipID toEmail:(NSString *)recipEmail withName:(NSString *)name outReference:(Firebase *)outRef {
    self = [super init];
    
    if (self) {
        self.amount = amount;
        self.senderID = senderID;
        self.senderEmail = senderEmail;
        self.senderDBRef = inRef;
        self.recipID = recipID;
        self.recipEmail = recipEmail;
        self.recipDBRef = outRef;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Payment"
                                                        message:[NSString stringWithFormat: @"%@ wants you to shoot over $%.2f. Accept?", name, amount]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"No Way.", nil)
                                              otherButtonTitles:NSLocalizedString(@"Pew Pew!", nil), nil];
        [alert show];
    }
    
    return self;
}

//  When the user cancels the payment, mark the last entry in the would-be recipient's outgoing
//  charges database as 'canceled'.
- (void)alertViewCancel:(UIAlertView *)alertView {
    [self.senderDBRef setValue:@"canceled" forKey:@"status"];
    [self.recipDBRef setValue:@"canceled" forKey:@"status"];
}

//  When the user clicks 'OK', send an email cc'ing square cash to complete the transaction.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    sendgrid *msg = [sendgrid user:@"ksiegel" andPass:@"asdf1234"];
    
    msg.tolist = [NSArray arrayWithObjects:self.recipEmail, @"cash@square.com", nil];
    msg.subject = [NSString stringWithFormat:@"$%f", self.amount];
    msg.from = self.senderEmail;
    msg.text = @"hello world";
    msg.html = @"<h1>hello world!</h1>";
    
    [msg sendWithWeb];
    [self.senderDBRef setValue:@"successful" forKey:@"status"];
    [self.recipDBRef setValue:@"successful" forKey:@"status"];
}

@end
