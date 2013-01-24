//
//  SignInViewController.h
//  signUp_signIn_Project_With_baas.io
//
//  Created by gyuchan jeon on 1/24/13.
//  Copyright (c) 2013 gyuchan jeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController {
    UITextField *currentTextField;
    UIButton *loginButton;
    
    UIImageView *bodybook;
}

@property (nonatomic, retain) IBOutlet UIImageView *bodybook;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

-(IBAction)SignInTouched:(id)sender;
-(IBAction)SignUpTouched:(id)sender;

@end
