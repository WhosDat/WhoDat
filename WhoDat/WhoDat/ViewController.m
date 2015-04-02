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
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    iconImageView.frame = CGRectMake(0, 0, self.view.frame.size.width-90, self.view.frame.size.width-90);
    iconImageView.center = CGPointMake(self.view.frame.size.width/2, 200);
    [self.view addSubview:iconImageView];
    
    // Login View Controller Button
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 70)];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:.34 green:.76 blue:.49 alpha:1]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:24];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // Signup View Controller Button
    UIButton *signupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, loginButton.frame.origin.y+70, self.view.frame.size.width, 70)];
    [signupButton setTitle:@"Signup" forState:UIControlStateNormal];
    [signupButton setBackgroundColor:[UIColor colorWithRed:.76 green:.29 blue:.51 alpha:1]];
    [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signupButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:24];
    [signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupButton];
}

-(IBAction)loginButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"showLoginViewController" sender:self];
}

-(IBAction)signupButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"showSignupViewController" sender:self];
}

@end
