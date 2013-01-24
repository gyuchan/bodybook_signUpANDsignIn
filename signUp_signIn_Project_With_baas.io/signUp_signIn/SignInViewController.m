//
//  SignInViewController.m
//  signUp_signIn_Project_With_baas.io
//
//  Created by gyuchan jeon on 1/24/13.
//  Copyright (c) 2013 gyuchan jeon. All rights reserved.
//

#import "SignInViewController.h"
#import "SignUpViewController.h"

//baas.io SDK를 추가합니다.
#import "BaasClient.h"

@interface SignInViewController ()

@end

@implementation SignInViewController
@synthesize usernameTextField, passwordTextField, bodybook;

- (void)viewDidLoad
{
    [super viewDidLoad];
    passwordTextField.secureTextEntry = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)SignInTouched:(id)sender{
    BaasClient *client = [BaasClient createInstance];
    //delegate를 self로 함으로써 상태를 확인할 수 있습니다.
    [client setDelegate:self];
    //
    [client logInUser:usernameTextField.text password:passwordTextField.text];
}

-(IBAction)SignUpTouched:(id)sender{
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    [self presentModalViewController:signUpViewController animated:NO];
}

-(void)successSignIn{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:[NSString stringWithFormat:@"bodybook"]
                          message:[NSString stringWithFormat:@"로그인 성공!"]
                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)ugClientResponse:(UGClientResponse *)response
{
    NSDictionary *resp = (NSDictionary *)response.rawResponse;
    if (response.transactionState == kUGClientResponseFailure) {
        NSLog(@"실패\n response : %@", resp);
    } else if (response.transactionState == kUGClientResponseSuccess) {
        NSString *access_token = [resp objectForKey:@"access_token"];
        NSDictionary *user = [resp objectForKey:@"user"];
        NSLog(@"로그인 정보 response : %@", resp);
        [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self successSignIn];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFieldView {
    [textFieldView resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textFieldView {
    currentTextField = nil;
    [textFieldView resignFirstResponder];
}


@end
