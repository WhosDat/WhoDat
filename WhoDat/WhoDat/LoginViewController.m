//
//  LoginViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 2/21/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    titleLabel.center = CGPointMake(self.view.frame.size.width/2, 130);
    titleLabel.text = @"Complimentzzz";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Arial" size:40];
    [self.view addSubview:titleLabel];
    
    // Create Username Field
    UITextField *usernameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 40)];
    usernameField.center = CGPointMake(self.view.frame.size.width/2, 200);
    usernameField.placeholder = @"Username";
    [self.view addSubview:usernameField];
    
    // Create Password Field
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 40)];
    passwordField.center = CGPointMake(self.view.frame.size.width/2, 240);
    passwordField.placeholder = @"Password";
    [self.view addSubview:passwordField];
    
    // Create Login Button
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-1, 30)];
    loginButton.center = CGPointMake(self.view.frame.size.width/3, 290);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor blackColor]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // Create Signup Button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-1, 30)];
    cancelButton.center = CGPointMake(2*self.view.frame.size.width/3, 290);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

-(void)loginButtonPressed
{
    // Login the user
    [self performSegueWithIdentifier:@"showProfileViewController" sender:self];
}

-(void)cancelButtonPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
