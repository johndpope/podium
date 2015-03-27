//
//  MainViewController.m
//  UserMgr
//
//  Created by netGALAXY Studios on 30/05/2013.
//  Copyright (c) 2013 netGALAXY Studios. All rights reserved.
//

#import "MainViewController.h"
#import "ControllerInfo.h"
#import "StoryboardInfo.h"
#import "MBProgressHUD.h"
#import "MBHUDView.h"
#import <QuartzCore/QuartzCore.h>
#import "UserMgr.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "MenuViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) NSArray* storyboards;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor* darkColor = [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f];
    self.view.backgroundColor = darkColor;
    self.iconHolderView.backgroundColor = darkColor;
    
    self.iconImageView.image = [UIImage imageNamed:@"main.png"];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString* fontName = @"Avenir-Book";
    
    self.iconLabel.textColor =  [UIColor whiteColor];
    self.iconLabel.font =  [UIFont fontWithName:fontName size:24.0f];
    self.iconLabel.text = @"Loading...";
}

-(void)viewDidAppear:(BOOL)animated
{
    UserMgr* manager = [[UserMgr alloc] init];
    
//    if([manager userDetailsAreSaved:self]){
//        [manager restoreSession:self.view
//                     completion:^(bool didSignIn){
//                         if(didSignIn){
//                             [self showWelcome:self];
//                         }
//                         else{
//                             MBAlertView *alert = [MBAlertView alertWithBody:@"The stored login data is no longer valid. Please login again." cancelTitle:nil cancelBlock:nil];
//                             [alert addButtonWithText:@"Ok" type:MBAlertViewItemTypePositive block:^{
//                                 [self showLogin:self];
//                             }];
//                             [alert addToDisplayQueue];
//                             
//                             [manager clearUserDetails:self];
//                         }
//                     }];
//    }
//    else{
//        [self showLogin:self];
//    }
    
    
    //Checking if user is already registered
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT count(*) FROM user"];
        
        const char *sql = [querySQL UTF8String];
        
        sqlite3_stmt *searchStatement;
        int count = 0;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStatement, NULL) == SQLITE_OK)
        {
            while( sqlite3_step(searchStatement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(searchStatement, 0);
                if (count >0)
                {
                    //Redirecting the user to menu
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MenuViewController" bundle:nil];
                    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
                    //[self presentViewController:vc animated:YES completion:nil];
                     self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
                }
                else
                {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RegisterStoryboard" bundle:nil];
                    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterController"];
                    //[self presentViewController:vc animated:YES completion:nil];
                     self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
                }
            }
        }
    }    
}

- (IBAction)showLogin:(id)sender
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RegisterStoryboard" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterController"];
    //[self presentViewController:vc animated:YES completion:nil];
     self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];

    //    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
//    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginController"];
//    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)showWelcome:(id)sender
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MenuViewController" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
   // [self presentViewController:vc animated:YES completion:nil];
     self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"WelcomeStoryboard" bundle:nil];
//    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"WelcomeController"];
//    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
