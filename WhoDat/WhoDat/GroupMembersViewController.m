//
//  GroupMembersViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 3/9/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "GroupMembersViewController.h"
#import "GroupsViewController.h"
#import <Parse/Parse.h>
#import "SendViewController.h"
#import "AddGroupMembersViewController.h"

@interface GroupMembersViewController ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *friendsArray;
@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) PFRelation *friendsRelation;
@property (nonatomic) NSArray *groupMembers;
@property (nonatomic) NSString *memberSelected;

@end

@implementation GroupMembersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Group Name Label
    UILabel *groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 60)];
    groupNameLabel.text = [NSString stringWithFormat:@"%@", self.groupName];
    groupNameLabel.textAlignment = NSTextAlignmentCenter;
    groupNameLabel.font = [UIFont systemFontOfSize:32];
    groupNameLabel.textColor = [UIColor blackColor];
    groupNameLabel.backgroundColor = [UIColor colorWithRed:0 green:0.43 blue:0.87 alpha:1];
    [self.view addSubview:groupNameLabel];
    
    // Add user button
    UIButton *addUser = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3, 40)];
    addUser.center = CGPointMake(self.view.frame.size.width/4, 110);
    [addUser setTitle:@"Add Member" forState:UIControlStateNormal];
    [addUser setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addUser addTarget:self action:@selector(addUserButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addUser];
    
    // Cancel Button
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, 40)];
    cancel.center = CGPointMake(3*self.view.frame.size.width/4, 110);
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    
    // Table of users contained in group
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, self.view.frame.size.height-100)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadMembersOfGroup];
}

-(IBAction)addUserButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"showAddGroupMembersViewController" sender:self];
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadMembersOfGroup
{
    if ([self.groupName isEqualToString:@"Friends"]){
        self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendRelation"];
        PFQuery *friendQuery = [self.friendsRelation query];
        [friendQuery orderByAscending:@"username"];
        [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.groupMembers = objects;
//            self.friends = [[NSMutableArray alloc] initWithArray:self.groupMembers];
            [self.tableView reloadData];
        }];
    }
    else{
        NSArray *initialArray = [[NSArray alloc] initWithObjects:[PFUser currentUser].username, nil];
        PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
        [groupQuery whereKey:@"Name" equalTo:self.groupName];
        [groupQuery whereKey:@"Members" containsAllObjectsInArray:initialArray];
        [groupQuery orderByAscending:@"Members"];
        [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSArray *tempArray = objects;
            NSMutableArray *groupMembersMutable = [[NSMutableArray alloc] initWithArray:[[tempArray objectAtIndex:0] objectForKey:@"Members"]];
            
            // Iterate through the array and remove the username that is equal to the current user's username
            for (int i = 0; i < groupMembersMutable.count; i++)
                if ([[groupMembersMutable objectAtIndex:i] isEqualToString:[PFUser currentUser].username])
                    [groupMembersMutable removeObjectAtIndex:i];
            
            self.groupMembers = [[NSArray alloc] initWithArray:groupMembersMutable];
            [self.tableView reloadData];
        }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showSendViewController"]){
        SendViewController *sendViewController = (SendViewController *)segue.destinationViewController;
        sendViewController.sendingToUser = self.memberSelected;
    }
    else if ([segue.identifier isEqualToString:@"showAddGroupMembersViewController"]){
        AddGroupMembersViewController *addGroupMembersViewController = (AddGroupMembersViewController *)segue.destinationViewController;
        addGroupMembersViewController.groupName = self.groupName;
    }
}

#pragma mark - table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupMembers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.groupName isEqualToString:@"Friends"])
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.groupMembers objectAtIndex:indexPath.row] objectForKey:@"username"]];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.groupMembers objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:24];
    
//    NSLog(@"%@", [[self.groupMembers objectAtIndex:indexPath.row] objectForKey:@"Members"]);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.groupName isEqualToString:@"Friends"])
        self.memberSelected = [NSString stringWithFormat:@"%@", [[self.groupMembers objectAtIndex:indexPath.row] objectForKey:@"username"]];
    else
        self.memberSelected = [NSString stringWithFormat:@"%@", [self.groupMembers objectAtIndex:indexPath.row]];
    
    [self performSegueWithIdentifier:@"showSendViewController" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
