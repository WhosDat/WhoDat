//
//  ViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 2/21/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Login View Controller Button
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-1, 30)];
    loginButton.center = CGPointMake(self.view.frame.size.width/3, 290);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor blackColor]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // Signup View Controller Button
    UIButton *signupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-1, 30)];
    signupButton.center = CGPointMake(2*self.view.frame.size.width/3, 290);
    [signupButton setTitle:@"Signup" forState:UIControlStateNormal];
    [signupButton setBackgroundColor:[UIColor blackColor]];
    [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(signupButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupButton];
    
    UILabel *jason = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, 100, 40)];
    jason.text = @"Jason";
    [self.view addSubview:jason];
}

-(void)loginButtonPressed
{
    [self performSegueWithIdentifier:@"showLoginViewController" sender:self];
}

-(void)signupButtonPressed
{
    [self performSegueWithIdentifier:@"showSignupViewController" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
