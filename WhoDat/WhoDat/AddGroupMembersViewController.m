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
@property (nonatomic) PFRelation *friendsRelation;
@property (nonatomic) UITextField *searchField;
@property (nonatomic) NSString *resultingQuery;
@property (nonatomic) PFUser *resultingUser;
@property (nonatomic) NSArray *members;

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
    
    // Search Field
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 100, self.view.frame.size.width-65, 50)];
    self.searchField.placeholder = @"Search User";
    self.searchField.backgroundColor = [UIColor whiteColor];
    self.searchField.font = [UIFont systemFontOfSize:24];
    self.searchField.autocorrectionType = NO;
    self.searchField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.searchField];
    
    // Search Button
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 100, 50, 50)];
    searchButton.backgroundColor = [UIColor blackColor];
    [searchButton setTitle:@"S" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchQuery) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    // Table for all users
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height-160)];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    if ([self.groupName isEqualToString:@"Friends"])
        [self loadFriends];
    else
        [self loadGroup];
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
        self.members = objects;
        [self.tableView reloadData];
    }];
}

-(void)loadGroup
{
    NSArray *tempArray = [[NSArray alloc] initWithObjects:[PFUser currentUser].username, nil];
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    [groupQuery orderByAscending:@"Members"];
    [groupQuery whereKey:@"Name" equalTo:self.groupName];
    [groupQuery whereKey:@"Members" containsAllObjectsInArray:tempArray];
    [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.members = [object objectForKey:@"Members"];
    }];
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
            }
            else{
                self.resultingQuery = [NSString stringWithFormat:@"User %@ not found", self.searchField.text];
            }
            [self.tableView reloadData];
        }];
    }
}

-(void)addToGroup:(NSString *)username
{
    NSArray *tempArray = [[NSArray alloc] initWithObjects:[PFUser currentUser].username, nil];
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    [groupQuery whereKey:@"Name" equalTo:self.groupName];
    [groupQuery whereKey:@"Members" containsAllObjectsInArray:tempArray];
    [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.members = [object objectForKey:@"Members"];
        NSMutableArray *addMemberArray = [[NSMutableArray alloc] initWithArray:self.members];
        [addMemberArray addObject:username];
        object[@"Members"] = addMemberArray;
        [object saveInBackground];
    }];
}

-(void)removeFromGroup:(NSString *)username
{
    NSArray *tempArray = [[NSArray alloc] initWithObjects:[PFUser currentUser].username, nil];

    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    [groupQuery whereKey:@"Name" equalTo:self.groupName];
    [groupQuery whereKey:@"Members" containsAllObjectsInArray:tempArray];
    [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.members = [object objectForKey:@"Members"];
        NSMutableArray *memberArray = [[NSMutableArray alloc] initWithArray:self.members];
        [memberArray removeObject:username];
        object[@"Members"] = memberArray;
        [object saveInBackground];
    }];
}

#pragma mark - table view data source

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
    
    cell.backgroundColor = [UIColor whiteColor];
    
    // Profile Picture
    UIImageView *userProfileImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]];
    userProfileImage.frame = CGRectMake(5, 2.5, 30, 30);
    [cell addSubview:userProfileImage];
    
    // Username
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2.5, 200, 30)];
    if (self.resultingQuery != nil)
        usernameLabel.text = [NSString stringWithFormat:@"%@", self.resultingQuery];
    usernameLabel.textColor = [UIColor blackColor];
    usernameLabel.font = [UIFont systemFontOfSize:24];
    [cell addSubview:usernameLabel];
    
    
    if ([self.groupName isEqualToString:@"Friends"]){
        if ([self isFriend:self.resultingUser])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        if ([self isGroupMember:self.resultingQuery])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.groupName isEqualToString:@"Friends"]){
        PFRelation *friendsRelation = [[PFUser currentUser] relationForKey:@"friendRelation"];
        
        if ([self isFriend:self.resultingUser]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            // Remove from the backend
            [friendsRelation removeObject:self.resultingUser];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [friendsRelation addObject:self.resultingUser];
        }
        
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    else {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self removeFromGroup:self.resultingQuery];
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self addToGroup:self.resultingQuery];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Helper Method

-(BOOL)isFriend:(PFUser *)user
{
    for (PFUser *friend in self.members) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isGroupMember:(NSString *)username
{
    for (NSString *groupMember in self.members){
        if ([groupMember isEqualToString:username])
            return YES;
    }
    return NO;
}


@end
