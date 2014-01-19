//
//  LoginViewController.m
//  PayRay
//
//  Created by Kshitij Grover on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import <Firebase/Firebase.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)join:(UIButton *)sender {
    
    NSString* name = [self.nameField text];
    NSString* email = [self.emailField text];
    
    NSNumber* uid;
    Firebase* baseRef = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://pay-ray.firebaseIO.com/USERS"]];
    uid = [NSNumber numberWithInt:arc4random_uniform(100000000)];
    int i_uid = [uid integerValue];
    Firebase* childRef = [baseRef childByAppendingPath: [NSString stringWithFormat:@"%08i", i_uid]];
    [childRef setValue:@{@"name": name, @"email": email}];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"name"];
    [defaults setObject:email forKey:@"email"];
    [defaults setObject:[uid stringValue] forKey:@"uid"];
    [defaults synchronize];
    
    [self performSegueWithIdentifier: @"loginSegue" sender: sender];
}
@end
