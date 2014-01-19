//
//  PaymentUtil.h
//  PayRay
//
//  This is a persistent class that handles incoming payment requests and
//  outgoing charges. It listens to the database for additions to the child's
//  "incoming charges" list, and reacts when one is added. It is also the start
//  point of any outgoing charges to other users.
//
//  Created by Kathryn Siegel on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface PaymentUtil : NSObject

@property(nonatomic, strong) NSString* email;
@property(nonatomic, strong) NSString* name;
@property(nonatomic) int userID;
@property(nonatomic) Firebase* incomingCharges;

- (id)initForUser:(int)userID withEmail:(NSString*)email andName:(NSString *)name;
- (void)chargeUser:(int)userID forAmount:(float)amount;

@end
