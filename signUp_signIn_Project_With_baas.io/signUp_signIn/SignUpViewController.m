//
//  SignUpViewController.m
//  signUp_signIn_Project_With_baas.io
//
//  Created by gyuchan jeon on 1/24/13.
//  Copyright (c) 2013 gyuchan jeon. All rights reserved.
//

#import "SignUpViewController.h"

//baas.io SDK를 추가합니다.
#import "BaasClient.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize userName, name, email, password, passwordRepeat, scrollView, cancelButton, signUpButton;;

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
    password.secureTextEntry = YES;
    passwordRepeat.secureTextEntry = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)validateEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(IBAction)cancelTouched:(id)sender{
    [self dismissModalViewControllerAnimated:NO];
}

-(IBAction)signUpTouched:(id)sender{
    if(![self validateEmail:[email text]]) {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"이메일 확인"]
                              message:[NSString stringWithFormat:@"이메일 입력이 잘못되었습니다"]
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else if([self.userName.text isEqualToString:@""]){
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"Username 확인"]
                              message:[NSString stringWithFormat:@"Username 입력이 잘못되었습니다"]
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else if(![password.text isEqualToString:passwordRepeat.text]||[password.text isEqualToString:@""]){
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"비밀번호 확인"]
                              message:[NSString stringWithFormat:@"비밀번호를 올바르게 입력하세요"]
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        BaasClient *client = [BaasClient createInstance];
        //delegate를 self로 함으로써 상태를 확인할 수 있습니다.
        [client setDelegate:self];
        //
        [client addUser:userName.text email:email.text name:name.text password:password.text];
    }
}

- (void)ugClientResponse:(UGClientResponse *)response
{
    NSDictionary *resp = (NSDictionary *)response.rawResponse;
    if (response.transactionState == kUGClientResponseFailure) {
        NSLog(@"실패response : %@", resp);
    } else if (response.transactionState == kUGClientResponseSuccess) {
        [self dismissModalViewControllerAnimated:NO];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textFieldView {
    currentTextField = textFieldView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFieldView {
    [textFieldView resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textFieldView {
    [textFieldView resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *) notification {
    if (keyboardIsShown) return;
    NSDictionary* info = [notification userInfo];
    
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    CGRect viewFrame = [scrollView frame];
    viewFrame.size.height -= keyboardRect.size.height;
    scrollView.frame = viewFrame;
    
    CGRect textFieldRect = [currentTextField frame];
    [scrollView scrollRectToVisible:textFieldRect animated:YES];
    keyboardIsShown = YES;
}

- (void)keyboardDidHide:(NSNotification *) notification {
    NSDictionary* info = [notification userInfo];
    
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    CGRect viewFrame = [scrollView frame];
    viewFrame.size.height += keyboardRect.size.height;
    scrollView.frame = viewFrame;
    
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
    keyboardIsShown = NO;
}


@end
