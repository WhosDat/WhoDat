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
@property (nonatomic) UIImagePickerController *picker;
@property (nonatomic) UIImageView *profilePicture;
@property (nonatomic) UILabel *pointsLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view endEditing:YES];
    
    [self getMessages];
    [self loadProfileImageAndPoints];
    
    [self createProfile];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 210, self.view.frame.size.width, self.view.frame.size.height-210)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadProfileImageAndPoints];
}

#pragma mark - Profile Setup

-(void)createProfile
{
    // Users's profile image
    self.profilePicture = [[UIImageView alloc] init];
    self.profilePicture.frame = CGRectMake(20, 20, 100, 100);
    self.profilePicture.layer.cornerRadius = 95;
    [self.view addSubview:self.profilePicture];
    
    // Update Picture button
    UIButton *updatePicture = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    updatePicture.backgroundColor = [UIColor clearColor];
    [updatePicture addTarget:self action:@selector(updatePictureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updatePicture];
    
    // User's username
    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(130, 45, 150, 40)];
    username.text = [PFUser currentUser].username;
    username.textColor = [UIColor blackColor];
    username.font = [UIFont fontWithName:@"Times" size:28];
    [self.view addSubview:username];
    
    // User Points
    self.pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 80, 150, 30)];
    self.pointsLabel.textColor = [UIColor blackColor];
    self.pointsLabel.font = [UIFont fontWithName:@"Times" size:13];
    [self.view addSubview:self.pointsLabel];
    
    // Friends Button
    UIButton *friends = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    friends.center = CGPointMake(self.view.frame.size.width/2, 160);
    [friends setTitle:@"Friends" forState:UIControlStateNormal];
    [friends setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [friends setBackgroundColor:[UIColor colorWithRed:.76 green:.29 blue:.51 alpha:1]];
    [friends addTarget:self action:@selector(friendsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friends];
    
    // Logout Button
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 20, 50, 30)];
    [logout setTitle:@"Log Out" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    logout.titleLabel.font = [UIFont fontWithName:@"Times" size:10];
    [logout addTarget:self action:@selector(logoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];
}

-(IBAction)logoutButtonPressed:(id)sender
{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - Profile Picture

-(IBAction)updatePictureButtonPressed:(id)sender
{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    [self.picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.picker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Dismiss Controller
    [self.picker dismissViewControllerAnimated:YES completion:NULL];

    // Access the image from the info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    //Upload Image to Parse
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    [self imageUpload:imageData];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imageUpload:(id)sender
{
    PFFile *imageFile = [PFFile fileWithName:@"ProfilePicture.jpg" data:sender];
    
    PFQuery *profileImage = [PFQuery queryWithClassName:@"UserMisc"];
    [profileImage whereKey:@"User" equalTo:[PFUser currentUser].username];
    [profileImage getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error){
            [object setObject:imageFile forKey:@"ProfilePicture"];
            [object saveInBackground];
            [self loadProfileImageAndPoints];
        }
        else{
            NSLog(@"%@", error);
        }
    }];
}

-(void)loadProfileImageAndPoints
{
    PFQuery *pictureQuery = [PFQuery queryWithClassName:@"UserMisc"];
    [pictureQuery whereKey:@"User" equalTo:[PFUser currentUser].username];
    pictureQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    // Run the query
    [pictureQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"ProfilePicture"];
            NSData *data = [file getData];
            UIImage *profileImage = [UIImage imageWithData:data];
            [self.profilePicture setImage:profileImage];
            self.points = [object objectForKey:@"Points"];
            self.pointsLabel.text = [NSString stringWithFormat:@"Points: %@", self.points];
        }
    }];
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
