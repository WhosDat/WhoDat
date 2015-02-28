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
@property (nonatomic) NSString *sendToUser;
@property (nonatomic) PFRelation *friendsRelation;
@property (nonatomic) NSArray *friends;

@end

@implementation SendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UISearchBar *searchFriends = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    searchFriends.placeholder = @"Search";
    searchFriends.delegate = self;
    [self.view addSubview:searchFriends];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.width/2)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.message = [[UITextView alloc] initWithFrame:CGRectMake(10, 280, self.view.frame.size.width-20, 160)];
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
    
    UIButton *sendMessage = [[UIButton alloc] initWithFrame:CGRectMake(0, 450, self.view.frame.size.width, 50)];
    [sendMessage setTitle:@"Send Message" forState:UIControlStateNormal];
    [sendMessage setBackgroundColor:[UIColor colorWithRed:.76 green:.85 blue:.34 alpha:1]];
    [sendMessage addTarget:self action:@selector(sendMessagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendMessage];

    self.searchResults = [[NSArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadFriends];
}

-(void)loadFriends
{
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendRelation"];
    
    PFQuery *friendQuery = [self.friendsRelation query];
    [friendQuery orderByAscending:@"username"];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.friends = objects;
        [self.tableView reloadData];
    }];
}

-(IBAction)sendMessagePressed:(id)sender
{
    if (self.sendToUser != nil || ![self.message.text isEqual:@""]){
        PFObject *compliment = [PFObject objectWithClassName:@"Compliment"];
        compliment[@"Message"] = self.message.text;
        compliment[@"Sender"] = [PFUser currentUser].username;
        compliment[@"Receiver"] = self.sendToUser;
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
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//        return self.searchResults.count;
    return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Need user profile image
    UIImageView *userProfileImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]];
    userProfileImage.frame = CGRectMake(5, 2.5, 30, 30);
    [cell addSubview:userProfileImage];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2.5, 200, 30)];
    usernameLabel.text = user.username;
    usernameLabel.textColor = [UIColor blackColor];
    [cell addSubview:usernameLabel];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    self.sendToUser = user.username;
}

#pragma mark - Search Methods

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    self.searchResults = [self.friends filteredArrayUsingPredicate:predicate];
}

//-(BOOL)search


@end
