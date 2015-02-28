//
//  LoginViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 2/21/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic) UITextField *usernameField;
@property (nonatomic) UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self alreadyLoggedIn];
    
    // Create title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    titleLabel.center = CGPointMake(self.view.frame.size.width/2, 130);
    titleLabel.text = @"WhoDat";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Arial" size:40];
    [self.view addSubview:titleLabel];
    
    // Create Username Field
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 40)];
    self.usernameField.center = CGPointMake(self.view.frame.size.width/2, 200);
    self.usernameField.placeholder = @"Username";
    [self.view addSubview:self.usernameField];
    
    // Create Password Field
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 40)];
    self.passwordField.center = CGPointMake(self.view.frame.size.width/2, 240);
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    
    // Create Login Button
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-1, 30)];
    loginButton.center = CGPointMake(self.view.frame.size.width/3, 290);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor blackColor]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // Create Signup Button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-1, 30)];
    cancelButton.center = CGPointMake(2*self.view.frame.size.width/3, 290);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

-(IBAction)loginButtonPressed:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            [self performSegueWithIdentifier:@"userLoggedIn" sender:self];
                                        } else {
                                            // The login failed. Check error to see why.
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:@"Username or password is incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [alert show];
                                        }
                                    }];
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)alreadyLoggedIn
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self performSegueWithIdentifier:@"userLoggedIn" sender:self];
    } else {
        // show the signup or login screen
    }
}

@end
