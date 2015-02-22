//
//  SignupViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 2/21/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create username field
    UITextField *usernameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 40)];
    usernameField.center = CGPointMake(self.view.frame.size.width/2, 200);
    usernameField.placeholder = @"Username";
    [self.view addSubview:usernameField];
    
    // Create password field
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 40)];
    passwordField.center = CGPointMake(self.view.frame.size.width/2, 240);
    passwordField.placeholder = @"Password";
    [self.view addSubview:passwordField];
    
    // Create email field
    UITextField *emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 40)];
    emailField.center = CGPointMake(self.view.frame.size.width/2, 280);
    emailField.placeholder = @"Email";
    [self.view addSubview:emailField];
    
    // Create cancel button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-1, 30)];
    cancelButton.center = CGPointMake(2*self.view.frame.size.width/3, 360);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    // Create signup button
    UIButton *signupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-1, 30)];
    signupButton.center = CGPointMake(self.view.frame.size.width/3, 360);
    [signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signupButton setBackgroundColor:[UIColor blackColor]];
    [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(signupButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupButton];
}

-(void)signupButtonPressed
{
    // Signup user
    // Log in the user
}

-(void)cancelButtonPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
