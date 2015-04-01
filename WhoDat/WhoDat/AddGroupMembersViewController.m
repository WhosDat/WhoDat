//
//  AddGroupMembersViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 3/28/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "AddGroupMembersViewController.h"

@interface AddGroupMembersViewController ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *allUsers;
@property (nonatomic) NSArray *friendsArray;
@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) PFRelation *friendsRelation;
@property (nonatomic) NSArray *membersArray;
@property (nonatomic) NSMutableArray *members;
@property (nonatomic) NSMutableArray *membersToAdd;
@property (nonatomic) UITextField *searchField;
@property (nonatomic) NSString *resultingQuery;

@end

@implementation AddGroupMembersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Group Name Label
    UILabel *groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 60)];
    groupNameLabel.text = [NSString stringWithFormat:@"Add %@'s Members", self.groupName];
    groupNameLabel.textAlignment = NSTextAlignmentCenter;
    groupNameLabel.font = [UIFont systemFontOfSize:22];
    groupNameLabel.textColor = [UIColor blackColor];
    groupNameLabel.backgroundColor = [UIColor colorWithRed:0 green:0.43 blue:0.87 alpha:1];
    [self.view addSubview:groupNameLabel];
    
    // Done Button
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width/4, 40)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    // Table for all users
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, self.view.frame.size.height-160)];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self loadUsers];
    
    if ([self.groupName isEqualToString:@"Friends"])
        [self loadFriends];
    
    
    self.membersToAdd = [[NSMutableArray alloc] init];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (![self.groupName isEqualToString:@"Friends"]){
        NSArray *tempArray = [[NSArray alloc] initWithObjects:[PFUser currentUser].username, nil];
        
        PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
        [groupQuery whereKey:@"Name" equalTo:self.groupName];
        [groupQuery whereKey:@"Members" containsAllObjectsInArray:tempArray];
        [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSArray *tempArray = [object objectForKey:@"Members"];
            for (int i = 0; i < tempArray.count; i++)
                [self.membersToAdd addObject:tempArray[i]];
            NSLog(@"%@", self.membersToAdd);
            object[@"Members"] = self.membersToAdd;
            [object saveInBackground];
        }];
    }
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadFriends
{
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendRelation"];
    
    PFQuery *friendQuery = [self.friendsRelation query];
    [friendQuery orderByAscending:@"username"];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.friendsArray = objects;
        self.friends = [[NSMutableArray alloc] initWithArray:self.friendsArray];
        [self.tableView reloadData];
    }];
}

-(void)searchQuery
{
    PFQuery *searchUserQuery = [PFUser query];
    [searchUserQuery whereKey:@"username" equalTo:[self.searchField.text lowercaseString]];
    [searchUserQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error){
            NSString *username = [object objectForKey:@"username"];
            self.resultingQuery = username;
        }
        else{
            self.resultingQuery = [NSString stringWithFormat:@"User %@ not found", self.searchField.text];
        }
        [self.tableView reloadData];
    }];
}

-(void)loadUsers
{
    PFQuery *showUsers = [PFUser query];
    [showUsers whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    [showUsers orderByAscending:@"username"];
    showUsers.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [showUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else{
            self.allUsers = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allUsers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Profile Picture
    UIImageView *userProfileImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]];
    userProfileImage.frame = CGRectMake(5, 2.5, 30, 30);
    [cell addSubview:userProfileImage];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
    // Username
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2.5, 200, 30)];
    usernameLabel.text = user.username;
    usernameLabel.textColor = [UIColor blackColor];
    usernameLabel.font = [UIFont fontWithName:@"Times" size:18];
    [cell addSubview:usernameLabel];
    
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.groupName isEqualToString:@"Friends"]){
        PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
        PFRelation *friendsRelation = [[PFUser currentUser] relationForKey:@"friendRelation"];
        
        if ([self isFriend:user]) {
            // Remove the checkmark
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            // Remove from the array of friends
            for (PFUser *friend in self.friends) {
                if ([friend.objectId isEqualToString:user.objectId]) {
                    [self.friends removeObject:friend];
                    break;
                }
            }
            
            // Remove from the backend
            [friendsRelation removeObject:user];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.friends addObject:user];
            [friendsRelation addObject:user];
        }
        
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    else {
        NSString *tempName = [[self.allUsers objectAtIndex:indexPath.row] objectForKey:@"username"];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.membersToAdd removeObject:tempName];
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.membersToAdd addObject:tempName];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Helper Method

-(BOOL)isFriend:(PFUser *)user
{
    for (PFUser *friend in self.friends) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    
    return NO;
}


@end
