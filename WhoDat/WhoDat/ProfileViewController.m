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
@property (nonatomic) NSArray *complimentsArray;
@property (nonatomic) NSDictionary *complimentsDictionary;
@property (nonatomic) NSString *points;
@property (nonatomic) PFRelation *pointsRelation;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.view endEditing:YES];
    
    [self getMessages];
    [self queryPoints];
    
    [self createProfile];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 210, self.view.frame.size.width, self.view.frame.size.height-210)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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
    username.text = [PFUser currentUser].username;
    username.textColor = [UIColor blackColor];
    username.font = [UIFont fontWithName:@"Times" size:28];
    [self.view addSubview:username];
    
    // User Points
    // Query # of points for user
    UILabel *points = [[UILabel alloc] initWithFrame:CGRectMake(180, 90, 150, 30)];
    points.text =[NSString stringWithFormat:@"Points: %@", self.points];
    points.textColor = [UIColor blackColor];
    points.font = [UIFont fontWithName:@"Times" size:16];
    [self.view addSubview:points];
    
    // Friends Button
    UIButton *friends = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    friends.center = CGPointMake(self.view.frame.size.width/2, 180);
    [friends setTitle:@"Friends" forState:UIControlStateNormal];
    [friends setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [friends setBackgroundColor:[UIColor colorWithRed:.76 green:.29 blue:.51 alpha:1]];
    [friends addTarget:self action:@selector(friendsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friends];
}

-(void)queryPoints
{
    PFQuery *userPoints = [PFQuery queryWithClassName:@"User"];
    [userPoints whereKey:@"username" containsString:[PFUser currentUser].username];
    userPoints.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [userPoints getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.points = [object objectForKey:@"points"];
    }];
    
//    self.pointsRelation = [[PFUser currentUser] objectForKey:@"pointsRelation"];
//    
//    PFQuery *pointsQuery = [self.pointsRelation query];
//    [pointsQuery whereKeyExists:@"points"];
//    [pointsQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        self.points = [object objectForKey:@"points"];
//        NSLog(@"%@", self.points);
//    }];
}

-(void)getMessages
{
    // Show Messages that have been read
    PFQuery *compliments = [PFQuery queryWithClassName:@"Compliment"];
    [compliments whereKeyExists:@"Message"];
    [compliments whereKey:@"Receiver" equalTo:[PFUser currentUser].username];
    [compliments orderByDescending:@"createdAt"];
    compliments.cachePolicy = kPFCachePolicyCacheThenNetwork;

    
    [compliments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.complimentsArray = objects;
            [self.tableView reloadData];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:@"We couldn't load your compliments, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    [self.tableView reloadData];
}

-(IBAction)friendsButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"showFriendsViewController" sender:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.complimentsArray != nil)
        return self.complimentsArray.count;
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
    
    // Message
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 100)];
    
    if (self.complimentsArray != nil)
        message.text = [NSString stringWithFormat:@"%@", [[self.complimentsArray objectAtIndex:indexPath.row] objectForKey:@"Message"]];
    else
        message.text = @"No Messages";
    
    message.numberOfLines = 4;
    message.lineBreakMode = NSLineBreakByWordWrapping;
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont fontWithName:@"Times" size:14];
    message.textColor = [UIColor blackColor];
    [cell addSubview:message];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

@end
