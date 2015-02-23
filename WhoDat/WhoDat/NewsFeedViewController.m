//
//  NewsFeedViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 2/22/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "NewsFeedViewController.h"

@interface NewsFeedViewController ()

@property (nonatomic) UITableView *tableView;

@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Image of user compliment is being sent to
    UIImageView *userPicture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]];
    userPicture.frame = CGRectMake(20, 10, 60, 60);
    userPicture.layer.cornerRadius = 25;
    [cell addSubview:userPicture];
    
    // Username of the user compliment is being sent to, beneath image
    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 100, 30)];
    username.font = [UIFont fontWithName:@"Freight Sans" size:16];
    username.text = [NSString stringWithFormat:@"Yoooooooo"];
    username.textColor = [UIColor blackColor];
    [cell addSubview:username];
    
    // Upvote
    UIButton *upvote = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 5, 10)];
    [upvote setTitle:@"U" forState:UIControlStateNormal];
    [upvote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [upvote addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:upvote];
    
    // Downvote
    UIButton *downvote = [[UIButton alloc] initWithFrame:CGRectMake(10, 18, 5, 10)];
    [downvote setTitle:@"D" forState:UIControlStateNormal];
    [downvote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [downvote addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:downvote];
    
    // Message
    UILabel *compliment = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 250, 100)];
    compliment.font = [UIFont fontWithName:@"Freight Sans" size:14];
    compliment.text = [NSString stringWithFormat:@"Complimentttttt"];
    compliment.numberOfLines = 4;
    compliment.lineBreakMode = NSLineBreakByWordWrapping;
    [cell addSubview:compliment];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

@end
