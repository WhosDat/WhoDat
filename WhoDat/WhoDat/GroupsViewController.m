//
//  GroupsViewController.m
//  WhoDat
//
//  Created by Anthony Williams on 3/9/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import "GroupsViewController.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    searchBar.placeholder = @"Search Groups";
    [self.view addSubview:searchBar];
    
    // Create Group button
    UIButton *createGroup = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    createGroup.center = CGPointMake(self.view.frame.size.width/2, 90);
    [createGroup setTitle:@"Create" forState:UIControlStateNormal];
    [createGroup setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    [createGroup addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createGroup];
    
    // Collection view
    
}

@end
