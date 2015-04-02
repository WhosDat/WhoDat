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
    
    self.navigationController.navigationBarHidden = YES;

    [self alreadyLoggedIn];
    
    // Create title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 100)];
    titleLabel.text = @"Expreso";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont fontWithName:@"Verdana" size:50];
    [self.view addSubview:titleLabel];
    
    // Create Username Field
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.width-20, 50)];
    self.usernameField.placeholder = @"Username";
    self.usernameField.autocapitalizationType = NO;
    self.usernameField.autocorrectionType = NO;
    self.usernameField.textAlignment = NSTextAlignmentCenter;
    self.usernameField.font = [UIFont fontWithName:@"Verdana" size:22];
    self.usernameField.returnKeyType = UIReturnKeyNext;
    [self textFieldShouldReturn:self.passwordField];
    [self.view addSubview:self.usernameField];
    
    // Create Password Field
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 210, self.view.frame.size.width-20, 50)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.autocapitalizationType = NO;
    self.passwordField.autocorrectionType = NO;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.font = [UIFont fontWithName:@"Verdana" size:22];
    self.usernameField.returnKeyType = UIReturnKeyDone;
    [self textFieldShouldReturn:self.passwordField];
    [self.view addSubview:self.passwordField];
    
    // Create Login Button
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 290, self.view.frame.size.width, 60)];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:0 green:.58 blue:.28 alpha:1]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:24];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // Create Cancel Button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 60)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:.22 green:0 blue:.67 alpha:.7]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:24];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

-(IBAction)loginButtonPressed:(id)sender
{
    // Lowercase username (lowercase in backend)
    [PFUser logInWithUsernameInBackground:[self.usernameField.text lowercaseString] password:self.passwordField.text
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];

    return YES;
}

@end
