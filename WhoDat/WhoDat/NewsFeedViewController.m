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
@property (nonatomic) PFRelation *friendsRelation;
@property (nonatomic) NSArray *friends;
@property (nonatomic) NSMutableArray *friendsMutable;
@property (nonatomic) NSArray *friendsCompliments;

@end

@implementation NewsFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendsMutable = [[NSMutableArray alloc] init];
    
    [self.navigationController setNavigationBarHidden:YES];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadFriends];
    
    for (int i = 0; i < self.friends.count; i++)
        [self.friendsMutable addObject:[[self.friends objectAtIndex:i] objectForKey:@"username"]];
    
    NSLog(@"%@", self.friendsMutable);
    
    if (self.friends != nil)
        [self loadFeed];
}

-(void)loadFeed
{
    // If friends have a compliment load their compliments
    // Show Messages that have been read
    PFQuery *compliments = [PFQuery queryWithClassName:@"Compliment"];
    [compliments whereKeyExists:@"Message"];
    [compliments whereKey:@"Receiver" containedIn:self.friendsMutable];
    [compliments orderByDescending:@"createdAt"];
    compliments.cachePolicy = kPFCachePolicyCacheThenNetwork;

    [compliments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.friendsCompliments = objects;
            [self.tableView reloadData];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:@"We couldn't load the compliments, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(void)loadFriends
{
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendRelation"];
    
    PFQuery *friendQuery = [self.friendsRelation query];
//    [friendQuery whereKeyExists:@"username"];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.friends = objects;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.friendsCompliments != nil)
        return self.friendsCompliments.count;
    else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.friendsCompliments != nil){
        // Image of user compliment is being sent to
        UIImageView *userPicture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]];
        userPicture.frame = CGRectMake(50, 10, 60, 60);
        userPicture.layer.cornerRadius = 25;
        [cell addSubview:userPicture];
        
        // Username of the user compliment is being sent to, beneath image
        UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 100, 30)];
        username.font = [UIFont fontWithName:@"Times" size:16];
        username.text = [NSString stringWithFormat:@"%@", [[self.friendsCompliments objectAtIndex:indexPath.row] objectForKey:@"Receiver"]];
        username.textColor = [UIColor blackColor];
        username.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:username];
        
        // Upvote
        UIButton *upvote = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 15, 10)];
        [upvote setTitle:@"U" forState:UIControlStateNormal];
        [upvote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        upvote.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    [upvote addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:upvote];
        
        // Number of Votes
        UILabel *numberOfVotes = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 15, 10)];
        numberOfVotes.text = [NSString stringWithFormat:@"#"];
        numberOfVotes.textColor = [UIColor blackColor];
        numberOfVotes.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:numberOfVotes];
        
        // Downvote
        UIButton *downvote = [[UIButton alloc] initWithFrame:CGRectMake(10, 55, 15, 10)];
        [downvote setTitle:@"D" forState:UIControlStateNormal];
        [downvote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        downvote.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    [downvote addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:downvote];
        
        // Message
        UILabel *compliment = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 250, 95)];
        compliment.font = [UIFont fontWithName:@"Times" size:14];
        compliment.text = [NSString stringWithFormat:@"%@", [[self.friendsCompliments objectAtIndex:indexPath.row] objectForKey:@"Message"]];
        compliment.numberOfLines = 4;
        compliment.textAlignment = NSTextAlignmentCenter;
        compliment.lineBreakMode = NSLineBreakByWordWrapping;
        [cell addSubview:compliment];
    }
    else{
        cell.textLabel.text = @"No new compliments";
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

@end
