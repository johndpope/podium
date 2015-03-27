//
//  MainViewController.h
//  UserMgr
//
//  Created by netGALAXY Studios on 30/05/2013.
//  Copyright (c) 2013 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroContentViewController.h"//for walkthrough
#import <sqlite3.h>
sqlite3	*database;

//changed to support walkthrough
@interface MainViewController : UIViewController <UIPageViewControllerDataSource>//UIViewController

/////////////////////
//functionality to start walkthrough
- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
/////////////////////

@property (nonatomic, strong) IBOutlet UIViewController* currentViewController;

@property (nonatomic, weak) IBOutlet UIView * iconHolderView;
@property (nonatomic, weak) IBOutlet UIImageView * iconImageView;
@property (nonatomic, weak) IBOutlet UILabel * iconLabel;

@property(nonatomic, retain) NSString *deviceUUID;

- (IBAction)showLogin:(id)sender;

@end
