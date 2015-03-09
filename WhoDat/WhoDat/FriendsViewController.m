//
//  FriendsViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 2/27/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *allUsers;
@property (nonatomic) NSArray *friendsArray;
@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) PFRelation *friendsRelation;

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadUsers];
    [self loadFriends];
    
    // Search Bar
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    search.placeholder = @"Search";
    [self.view addSubview:search];
    
    // Table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // Dismiss Button
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    dismiss.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-60);
    [dismiss setBackgroundColor:[UIColor blackColor]];
    [dismiss setTitle:@"Return" forState:UIControlStateNormal];
    [dismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dismiss.titleLabel.font = [UIFont fontWithName:@"Times" size:26];
    [dismiss addTarget:self action:@selector(dismissButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismiss];
}

-(void)dismissButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - UITableView Delegate

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
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
