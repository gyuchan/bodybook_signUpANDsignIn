//
//  SignUpViewController.h
//  signUp_signIn_Project_With_baas.io
//
//  Created by gyuchan jeon on 1/24/13.
//  Copyright (c) 2013 gyuchan jeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController {
    BOOL keyboardIsShown;
    UITextField *currentTextField;
    
    UIScrollView *scrollView;
    
}

@property (retain, nonatomic) IBOutlet UIButton *cancelButton, *signUpButton;
@property (retain, nonatomic) IBOutlet UITextField *userName, *name, *email, *password, *passwordRepeat;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;


-(IBAction)cancelTouched:(id)sender;

-(IBAction)signUpTouched:(id)sender;

@end
