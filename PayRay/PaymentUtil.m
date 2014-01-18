//
//  PaymentUtil.m
//  PayRay
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "PaymentUtil.h"
#import "sendgrid.h"

@implementation PaymentUtil

- (id)initWithEmail: (NSString*)email andPassword: (NSString*)pass {
    self = [super init];
    if (self) {
        self.email = email;
        self.password = pass;
    }
    return self;
}

-(void) PayTo:(NSString *)email forAmount:(float)amount {
    sendgrid *msg = [sendgrid user:@"ksiegel" andPass:@"asdf1234"];
    
    msg.tolist = [NSArray arrayWithObjects:email, @"cash@square.com"];
    msg.subject = [NSString stringWithFormat:@"$%f", amount];
    msg.from = self.email;
    msg.text = @"hello world";
    msg.html = @"<h1>hello world!</h1>";
    
    [msg sendWithWeb];
}


@end
