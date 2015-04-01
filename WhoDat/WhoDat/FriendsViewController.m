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
@property (nonatomic) UITextField *searchField;
@property (nonatomic) NSString *resultingQuery;
@property (nonatomic) PFUser *resultingUser;

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Search Field
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, self.view.frame.size.width-80, 50)];
    self.searchField.placeholder = @"Search User";
    self.searchField.backgroundColor = [UIColor orangeColor];
    self.searchField.font = [UIFont systemFontOfSize:24];
    self.searchField.autocorrectionType = NO;
    self.searchField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.searchField];
    
    // Search Button
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 60, 50, 50)];
    searchButton.backgroundColor = [UIColor blackColor];
    [searchButton setTitle:@"S" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchQuery) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    // Table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-140)];
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

-(void)searchQuery
{
    if (![[self.searchField.text lowercaseString] isEqualToString:[PFUser currentUser].username]){
        PFQuery *searchUserQuery = [PFUser query];
        [searchUserQuery whereKey:@"username" equalTo:[self.searchField.text lowercaseString]];
        [searchUserQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error){
                NSString *username = [object objectForKey:@"username"];
                self.resultingQuery = username;
                self.resultingUser = (PFUser *) object;
                NSLog(@"%@", self.resultingUser);
            }
            else{
                self.resultingQuery = [NSString stringWithFormat:@"User %@ not found", self.searchField.text];
            }
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - TableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    
    // Username
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2.5, 200, 30)];
    if (self.resultingQuery != nil)
        usernameLabel.text = [NSString stringWithFormat:@"%@", self.resultingQuery];
    usernameLabel.textColor = [UIColor blackColor];
    usernameLabel.font = [UIFont fontWithName:@"Times" size:18];
    [cell addSubview:usernameLabel];
    
    if (self.resultingUser != nil){
        if ([self isFriend:self.resultingUser]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
