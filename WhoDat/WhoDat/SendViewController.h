//
//  SendViewController.h
//  WhoDat
//
//  Created by Anthony Williams on 2/22/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SendViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UISearchControllerDelegate>

@property (nonatomic) NSString *sendingToUser;

@end
