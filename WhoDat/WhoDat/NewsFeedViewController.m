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
@property (nonatomic) NSString *userData;
@property (nonatomic) UIImage *profileImage;
@property (nonatomic) NSMutableArray *pictureArray;

@end

@implementation NewsFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendsMutable = [[NSMutableArray alloc] init];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self loadFeed];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadFriends];
    
    for (int i = 0; i < self.friends.count; i++)
        [self.friendsMutable addObject:[[self.friends objectAtIndex:i] objectForKey:@"username"]];
        
    if (self.friends != nil)
        [self loadFeed];
}

#pragma mark - Queries

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
            for (int i = 0; i < self.friendsCompliments.count; i++)
                [self loadProfileImage:[self.friendsCompliments objectAtIndex:i]];
            
            [self.tableView reloadData];
        }
        else{
            NSLog(@"%@", error);
        }
    }];
}

-(void)loadFriends
{
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendRelation"];
    
    PFQuery *friendQuery = [self.friendsRelation query];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.friends = objects;
    }];
}

-(void)loadProfileImage:(NSArray *)name
{
    PFQuery *userMisc = [PFQuery queryWithClassName:@"UserMisc"];
    [userMisc whereKey:@"User" equalTo:name];
    userMisc.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [userMisc getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error){
            NSLog(@"%@", object);
            PFFile *file = [object objectForKey:@"ProfilePicture"];
            NSData *data = [file getData];
            [self.pictureArray addObject:data];
        }
        else{
            NSLog(@"%@", error);
        }
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
    
    if (self.friendsCompliments.count > 0){
        
        // Image of user compliment is being sent to
        UIImageView *userPicture = [[UIImageView alloc] init];
        userPicture.image = [UIImage imageWithData:[self.pictureArray objectAtIndex:indexPath.row]];
        userPicture.frame = CGRectMake(50, 10, 60, 60);
        userPicture.layer.cornerRadius = 25;
        [cell addSubview:userPicture];
        
        // Username of the receiver
        UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 100, 30)];
        username.font = [UIFont fontWithName:@"Times" size:15];
        username.text = [NSString stringWithFormat:@"%@", [[self.friendsCompliments objectAtIndex:indexPath.row] objectForKey:@"Receiver"]];
        username.textColor = [UIColor blackColor];
        username.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:username];
        
        // Upvote
        UIButton *upvote = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 15, 10)];
        [upvote setTitle:@"U" forState:UIControlStateNormal];
        [upvote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        upvote.titleLabel.textAlignment = NSTextAlignmentCenter;
        [upvote addTarget:self action:@selector(upvoteButtonClicked:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:upvote];
        
        // Number of Votes
        UILabel *numberOfVotes = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 15, 10)];
        numberOfVotes.text = [NSString stringWithFormat:@"%@", [[self.friendsCompliments objectAtIndex:indexPath.row] objectForKey:@"Votes"]];
        numberOfVotes.textColor = [UIColor blackColor];
        numberOfVotes.font = [UIFont fontWithName:@"Times" size:12];
        numberOfVotes.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:numberOfVotes];
        
        // Downvote
        UIButton *downvote = [[UIButton alloc] initWithFrame:CGRectMake(10, 55, 15, 15)];
        [downvote setTitle:@"D" forState:UIControlStateNormal];
        [downvote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        downvote.titleLabel.textAlignment = NSTextAlignmentCenter;
        [downvote addTarget:self action:@selector(downvoteButtonClicked:event:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Buttons

-(IBAction)upvoteButtonClicked:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    NSLog(@"Upvote on row %ld", (long)indexPath.row);
}

-(IBAction)downvoteButtonClicked:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    NSLog(@"Downvote on row %ld", (long)indexPath.row);
}

@end
