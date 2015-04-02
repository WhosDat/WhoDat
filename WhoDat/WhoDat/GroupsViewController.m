//
//  GroupsViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 3/9/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved/
#import "GroupsViewController.h"
#import "GroupMembersViewController.h"
#import <Parse/Parse.h>

@interface GroupsViewController ()

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *groupList;
@property (nonatomic) NSString *groupSelected;

@end

@implementation GroupsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadGroups];
    
    self.navigationController.navigationBarHidden = YES;
    
    // Create Group button
    UIButton *create = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 30)];
    create.center = CGPointMake(self.view.frame.size.width/2, 60);
    [create setTitle:@"Create Group" forState:UIControlStateNormal];
    [create setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    create.titleLabel.font = [UIFont fontWithName:@"Times" size:24];
    [create addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:create];
    
    // Table of Groups
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-90)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadGroups];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showGroupMembersViewController"]){
        GroupMembersViewController *groupMembersViewController = (GroupMembersViewController *)segue.destinationViewController;
        groupMembersViewController.groupName = self.groupSelected;
    }
}

-(void)loadGroups
{
    NSMutableArray *initialArray = [[NSMutableArray alloc] initWithObjects:[PFUser currentUser].username, nil];
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    [groupQuery whereKey:@"Members" containsAllObjectsInArray:initialArray];
    [groupQuery orderByAscending:@"Name"];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            NSArray *tempArray = objects;
            self.groupList = [[NSMutableArray alloc] initWithArray:tempArray];
            [self.tableView reloadData];
        }
        else{
            NSLog(@"%@", error);
        }
    }];
}

-(IBAction)createButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"showCreateGroupViewController" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupList.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 60)];
    if (indexPath.row == 0)
        textLabel.text = @"Friends";
    else
        textLabel.text = [NSString stringWithFormat:@"%@", [[self.groupList objectAtIndex:indexPath.row-1] objectForKey:@"Name"]];
    
    if (indexPath.row % 2 == 0)
        textLabel.backgroundColor = [UIColor lightGrayColor];
    
    textLabel.font = [UIFont fontWithName:@"Times" size:36];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:textLabel];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        self.groupSelected = @"Friends";
    else
        self.groupSelected = [NSString stringWithFormat:@"%@", [[self.groupList objectAtIndex:indexPath.row-1] objectForKey:@"Name"]];
    
    [self performSegueWithIdentifier:@"showGroupMembersViewController" sender:self];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0){
        NSLog(@"%@", [[self.groupList objectAtIndex:indexPath.row-1] objectForKey:@"Name"]);
        [self.groupList removeObjectAtIndex:indexPath.row-1];
        [self.tableView reloadData];
        
        // Remove from backend
    }
}


@end
