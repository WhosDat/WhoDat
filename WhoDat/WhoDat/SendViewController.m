//
//  SendViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 2/22/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "SendViewController.h"

@interface SendViewController ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UITextView *message;
@property (nonatomic) NSArray *searchResults;
@property (nonatomic) PFRelation *friendsRelation;
@property (nonatomic) NSArray *friends;

@end

@implementation SendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    // Label for User the message is sending to
    UILabel *sendUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 60)];
    sendUserLabel.text = [NSString stringWithFormat:@"%@", self.sendingToUser];
    sendUserLabel.textAlignment = NSTextAlignmentCenter;
    sendUserLabel.textColor = [UIColor blackColor];
    sendUserLabel.font = [UIFont systemFontOfSize:32];
    sendUserLabel.backgroundColor = [UIColor colorWithRed:0 green:0.43 blue:0.87 alpha:1];
    [self.view addSubview:sendUserLabel];
    
    self.message = [[UITextView alloc] initWithFrame:CGRectMake(10, 120, self.view.frame.size.width-20, 160)];
//    self.message.placeholder = @"What do you want to say?";
    self.message.font = [UIFont fontWithName:@"Times" size:20];
    self.message.textAlignment = NSTextAlignmentCenter;
    self.message.layer.borderColor = [[UIColor blackColor] CGColor];
    self.message.layer.borderWidth = 2.5f;
    if (self.message.text.length < 140)
        self.message.editable = YES;
    else
        self.message.editable = NO;
    [self.message resignFirstResponder];
    [self.view addSubview:self.message];
    
    UIButton *sendMessage = [[UIButton alloc] initWithFrame:CGRectMake(0, 290, self.view.frame.size.width, 50)];
    [sendMessage setTitle:@"Send Message" forState:UIControlStateNormal];
    [sendMessage setBackgroundColor:[UIColor colorWithRed:.76 green:.85 blue:.34 alpha:1]];
    [sendMessage addTarget:self action:@selector(sendMessagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendMessage];
    
    // Cancel Button
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, 40)];
    cancel.center = CGPointMake(3*self.view.frame.size.width/4, 110);
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];

    self.searchResults = [[NSArray alloc] init];
}

-(IBAction)sendMessagePressed:(id)sender
{
    if (![self.message.text isEqual:@""]){
        PFObject *compliment = [PFObject objectWithClassName:@"Compliment"];
        compliment[@"Message"] = self.message.text;
        compliment[@"Sender"] = [PFUser currentUser].username;
        compliment[@"Receiver"] = self.sendingToUser;
        compliment[@"Votes"] = @"0";
        
        PFACL *complimentACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [complimentACL setPublicReadAccess:YES];
        [compliment setACL:complimentACL];
        
        [compliment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error){
                self.message.text = @"";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woo!" message:@"Your message has been sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:@"Please try to send your message again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:@"Please select a friend" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Search Methods

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    self.searchResults = [self.friends filteredArrayUsingPredicate:predicate];
}

//-(BOOL)search


@end
