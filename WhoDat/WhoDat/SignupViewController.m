//
//  SignupViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 2/21/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@property (nonatomic) UITextField *usernameField;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic) UITextField *emailField;

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;

    // Create username field
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width-20, 50)];
    self.usernameField.placeholder = @"Username";
    self.usernameField.font = [UIFont fontWithName:@"Verdana" size:22];
    self.usernameField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.usernameField];
    
    // Create password field
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, self.view.frame.size.width-20, 50)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.font = [UIFont fontWithName:@"Verdana" size:22];
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.passwordField];
    
    // Create email field
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 180, self.view.frame.size.width-20, 50)];
    self.emailField.placeholder = @"Email";
    self.emailField.font = [UIFont fontWithName:@"Verdana" size:22];
    self.emailField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.emailField];
    
    // Create signup button
    UIButton *signupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 240, self.view.frame.size.width, 60)];
    [signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signupButton setBackgroundColor:[UIColor colorWithRed:0 green:.58 blue:.28 alpha:1]];
    [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signupButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:24];
    [signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupButton];
    
    // Create cancel button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 60)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:.22 green:0 blue:.67 alpha:.7]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:24];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

-(IBAction)signupButtonPressed:(id)sender
{
    PFUser *user = [PFUser user];
    // Convert username to lowercase to be stored in backend
    user.username = [self.usernameField.text lowercaseString];
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Initialize with a default picture
            UIImage *initialImage = [UIImage imageNamed:@"default"];
            NSData *imageData = UIImageJPEGRepresentation(initialImage, 0.3);
            PFFile *imageFile = [PFFile fileWithName:@"ProfilePicture.jpg" data:imageData];
            
            // Initialize with 0 points
            PFObject *initial = [PFObject objectWithClassName:@"UserMisc"];
            [initial setObject:@"0" forKey:@"Points"];
            [initial setObject:[self.usernameField.text lowercaseString] forKey:@"User"];
            [initial setObject:imageFile forKey:@"ProfilePicture"];
            [initial saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error)
                    NSLog(@"%@", error);
            }];
            
            [self performSegueWithIdentifier:@"userLoggedIn" sender:self];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
