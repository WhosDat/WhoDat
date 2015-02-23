//
//  ProfileViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 2/22/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (nonatomic) UITableView *tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self createProfile];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 210, self.view.frame.size.width, self.view.frame.size.height-210)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
     
#pragma mark - Profile Setup

-(void)createProfile
{
    // Users's profile image
    UIImageView *profileImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]];
    profileImage.frame = CGRectMake(30, 30, 130, 130);
    profileImage.layer.cornerRadius = 95;
    [self.view addSubview:profileImage];
    
    // User's username
    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(180, 45, 150, 40)];
    username.text = [NSString stringWithFormat:@"Alan Au"];
    username.textColor = [UIColor blackColor];
//    username.backgroundColor = [UIColor greenColor];
    username.font = [UIFont fontWithName:@"Times" size:28];
    [self.view addSubview:username];
    
    // User Points
    UILabel *points = [[UILabel alloc] initWithFrame:CGRectMake(180, 90, 150, 30)];
    points.text =[NSString stringWithFormat:@"Points: 10000"];
    points.textColor = [UIColor blackColor];
//    points.backgroundColor = [UIColor greenColor];
    points.font = [UIFont fontWithName:@"Times" size:16];
    [self.view addSubview:points];
    
    // Read Message Button
    UIButton *read = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-80, 170, 70, 40)];
    [read setTitle:@"Read" forState:UIControlStateNormal];
    read.titleLabel.font = [UIFont fontWithName:@"Times" size:22];
//    read.backgroundColor = [UIColor greenColor];
    [read setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [read addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:read];
    
    // Unread Message Button
    UIButton *unread = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)+20, 170, 70, 40)];
    [unread setTitle:@"Unread" forState:UIControlStateNormal];
    unread.titleLabel.font = [UIFont fontWithName:@"Times" size:22];
    [unread setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [unread addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:unread];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Message
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 100)];
    message.numberOfLines = 4;
    message.lineBreakMode = NSLineBreakByWordWrapping;
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont fontWithName:@"Freight Sans" size:14];
    message.textColor = [UIColor blackColor];
    message.text = [NSString stringWithFormat:@"You is sooooooo awesome, i love you and your swagginess. it's amazing. i want to marry you and have your kids. seriously, don't be scared. message me your number!"];
    [cell addSubview:message];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

@end
