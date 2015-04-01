//
//  CreateGroupViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 3/9/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "CreateGroupViewController.h"
#import <Parse/Parse.h>

@interface CreateGroupViewController ()

@property (nonatomic) UITextField *groupName;

@end

@implementation CreateGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Group Name Text Field
    self.groupName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    self.groupName.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3);
    self.groupName.placeholder = @"Group Name";
    self.groupName.textAlignment = NSTextAlignmentCenter;
    self.groupName.font = [UIFont systemFontOfSize:35];
    [self.view addSubview:self.groupName];
    
    // Create button
    UIButton *create = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, 40)];
    create.center = CGPointMake(self.view.frame.size.width/4, self.view.frame.size.height/2);
    [create setTitle:@"Create" forState:UIControlStateNormal];
    [create setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [create addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:create];
    
    // Dismiss Button
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, 40)];
    dismiss.center = CGPointMake(3*self.view.frame.size.width/4, self.view.frame.size.height/2);
    [dismiss setTitle:@"Cancel" forState:UIControlStateNormal];
    [dismiss setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [dismiss addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismiss];
}

-(IBAction)createButtonPressed:(id)sender
{
    if (![self.groupName.text isEqual:@""]){
        NSArray *initialArray = [[NSArray alloc] initWithObjects:[PFUser currentUser].username, nil];
        
        PFObject *group = [PFObject objectWithClassName:@"Group"];
        [group setObject:self.groupName.text forKey:@"Name"];
        [group setObject:[PFUser currentUser].username forKey:@"Owner"];
        [group setObject:initialArray forKey:@"Members"];
        
        PFACL *groupACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [groupACL setPublicReadAccess:YES];
        [groupACL setPublicWriteAccess:NO];
        [group setACL:groupACL];
        
        [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error){
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            else{
                NSLog(@"%@", error);
            }
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You forgot your group name!" delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)dismissButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
