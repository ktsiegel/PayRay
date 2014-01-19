//
//  ReceiptPicViewController.m
//  PayRay
//
//  Created by Kshitij Grover on 1/18/14.
//  Copyright (c) 2014 Kathryn Siegel. All rights reserved.
//

#import "ReceiptPicViewController.h"
#import <TesseractOCR/TesseractOCR.h>
#import "ViewController.h"

@interface ReceiptPicViewController ()
@property NSMutableArray* items;
@end

@implementation ReceiptPicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void) setupAppearance
{
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)];
    [[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
}

-(void) takePicture:(id) sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    // language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory.
    // eng.traineddata is in your "tessdata" folder.
    // Assumed, that you added a group "tessdata" into your xCode project tree and .traineddata files to it.
    // This actually will not create a "tessdata" folder into your application bundle. Instead, all the files would be located into the root of the bundle.
    // This initializer will copy such 'traineddata' files located in the root folder of the application bundle to 'Documents/traneddata' folder of the application bundle to allow Tesseract to searcj for files into "tessdata".
    // This leads to two copies of the same huge files on user's disk.
    
    
    // set up the delegate to recieve tesseract's callback
    // self should respond to TesseractDelegate and implement shouldCancelImageRecognitionForTesseract: method
    // to have an ability to recieve callback and interrupt Tesseract before it finishes
    
    tesseract.delegate = self;
    
    [tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
    [tesseract setImage:image]; //image to check
    [tesseract recognize];
    
    NSLog(@"%@", [tesseract recognizedText]);
    self.imageText.text = [tesseract recognizedText];
    
    [tesseract clear];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    
}
- (BOOL)textFieldShouldReturn:(UITextView *)textField {
    if (textField == self.imageText) {
        [textField resignFirstResponder];
    }
    return NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object: nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object: nil];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract
{
    NSLog(@"progress: %d", tesseract.progress);
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"approveSegue"]){
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.renderedText = self.imageText.text;
    }
}
-(IBAction)approveButton:(id)sender{
    [self performSegueWithIdentifier: @"approveSegue" sender:self];
}

@end





