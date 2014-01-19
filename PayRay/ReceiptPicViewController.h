//
//  ReceiptPicViewController.h
//  PayRay
//
//  Created by Kshitij Grover on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>

@interface ReceiptPicViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TesseractDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *imageText;
- (IBAction)approveButton:(id)sender;


@end
