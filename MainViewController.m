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
#import <Parse/Parse.h>
//added to set camera settings at start
#import "AppDelegate.h"

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
    
    //UIColor* darkColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f];
    UIColor* lightColor = [UIColor whiteColor];
    self.view.backgroundColor = lightColor;//darkColor;
    self.iconHolderView.backgroundColor = lightColor;//darkColor;
    
//    self.iconImageView.image = [UIImage imageNamed:@"main.png"];
//    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString* fontName = @"Avenir-Book";
    
    self.iconLabel.textColor =  [UIColor whiteColor];
    self.iconLabel.font =  [UIFont fontWithName:fontName size:24.0f];
    self.iconLabel.text = @"Loading...";
}

-(void)viewDidAppear:(BOOL)animated
{
//    UserMgr* manager = [[UserMgr alloc] init];
//
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
    [self firstStart];
}


//try creating function to manage difference start scenarios
- (void)firstStart
{
    //get the toggle to check if this is this the first time starting
    #pragma mark - toggle to check if it is the first time for walkthrough
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id toggleSwitchValue = [defaults objectForKey:@"walkthrough_preference"];
    BOOL firstTime = [toggleSwitchValue boolValue];
    NSLog(@"has launched: %@", (firstTime) ? @"YES" : @"NO");
    
    if (firstTime) {
        //hide navigation bar
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        
        //turn walkthrough off
        [defaults setBool:NO forKey:@"walkthrough_preference"];
        [defaults synchronize];
        
        //setting page control color for walkthrough
        UIPageControl *pageControl = [UIPageControl appearance];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        pageControl.backgroundColor = [UIColor whiteColor];
    
        //added to support walkthrough
        #pragma mark - walkthrough configuration
//        _pageImages = @[@"login.jpg", @"startPracticing.jpg",@"mainscreen_interview.jpg", @"mainscreen_menu.jpg", @"connecttodropbox.jpg", @"accessdropbox.jpg", @"eyeContact.jpg", @"mainscreen_settings.jpg", @"settings_timer.jpg", @"timer.jpg", @"settings_camera.jpg", @"turnOnCamera.jpg", @"watch.jpg"];
        _pageImages = @[@"first.jpg", @"select speech.jpg", @"setbackground.jpg",@"start recording.jpg",@"select interview.jpg", @"menu.jpg", @"create speech.jpg", @"import from dropbox.jpg", @"localpracticefile.jpg", @"main settings.jpg", @"last.jpg"];
        
        // Create page view controller
        self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
        self.pageViewController.dataSource = self;
        
        IntroContentViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        // Change the size of page view controller
        //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];

        
    }else{
        //Checking if user is already logged in with parse
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
            // logged in, go right to practicing
            NSLog(@"user is logged in already with parse");
            //Redirecting the user to the select screen (skipping the "menu" that has only one button)
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];//@"MenuViewController" bundle:nil];
            UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];//@"MenuViewController"];
            //[self presentViewController:vc animated:YES completion:nil];
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
        } else {
            //not already logged in
        NSLog(@"user is not registered");
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RegisterStoryboard" bundle:nil];
        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterController"];
        //[self presentViewController:vc animated:YES completion:nil];
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
        }
    
        
        
        
//        //Checking if user is already logged in
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
//        if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
//        {
//            
//            NSString *querySQL = [NSString stringWithFormat:@"SELECT count(*) FROM user"];
//            
//            const char *sql = [querySQL UTF8String];
//            
//            sqlite3_stmt *searchStatement;
//            int count = 0;
//            
//            if (sqlite3_prepare_v2(database, sql, -1, &searchStatement, NULL) == SQLITE_OK)
//            {
//                while( sqlite3_step(searchStatement) == SQLITE_ROW )
//                {
//                    count = sqlite3_column_int(searchStatement, 0);
//                    if (count >0)
//                    {
//                        NSLog(@"user is registered");
//                        //Redirecting the user to the select screen (skipping the "menu" that has only one button)
//                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];//@"MenuViewController" bundle:nil];
//                        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];//@"MenuViewController"];
//                        //[self presentViewController:vc animated:YES completion:nil];
//                        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
//                    }
//                    else
//                    {
//                        NSLog(@"user is not registered");
//                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RegisterStoryboard" bundle:nil];
//                        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterController"];
//                        //[self presentViewController:vc animated:YES completion:nil];
//                        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
//                    }
//                }
//            }
//        }
        
        
        
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
    //skip screen with just one button
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];//@"MenuViewController" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];//@"MenuViewController"];
//  [self presentViewController:vc animated:YES completion:nil];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//////////////////////////////////////////////////////////////////////////
/*
 methods for walkthrough slideshow
*/
//////////////////////////////////////////////////////////////////////////

#pragma mark - walkthrough Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


- (IntroContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    IntroContentViewController *pageContentViewController;
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    @try {
        // Create a new view controller and pass suitable data.
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroContentViewController"];
        pageContentViewController.imageFile = self.pageImages[index];
        pageContentViewController.pageIndex = index;
    }
    @catch (NSException* exception) {
        NSLog(@"Uncaught exception %@", exception);
        NSLog(@"Stack trace: %@", [exception callStackSymbols]);
    }
    return pageContentViewController;
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
- (IBAction)startWalkthrough:(id)sender {
    IntroContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

@end
