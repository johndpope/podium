//
//  AppDelegate.m
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/20/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "AppDelegate.h"
#import <sqlite3.h>
#import "MenuViewController.h"
#import "JALeftViewController.h"
#import "SelectSpeechViewController.h"
#import "LoginController.h"
#import "JARightViewController.h"
#import "UIViewController+JASidePanel.h"
#import "SettingViewController.h"
#import "MainViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import <Parse/Parse.h>
#import <DBChooser/DBChooser.h>

sqlite3	*database;

@implementation AppDelegate
@synthesize camera_in_practice,i,camera_Blinking;
@synthesize speecharray;
@synthesize speechText;
@synthesize secondsToSleep;
@synthesize secondsToSleepInDouble,appResult;
@synthesize timerCounter,viewController = _viewController;

- (void) makeDBCopyAsNeeded
{
    
	BOOL success; 
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success)
	{
		return;
	}
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IPresentWell.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success)
	{
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"starting");
    [self registerDefaultsFromSettingsBundle];
    
    /*********************************************************
    //activating services: parse, dropbox, klipp
    
    *********************************************************/
    //initialize parse account
    //[Parse setApplicationId:@"0QJUPWwhQeppQPDQa9P5r7FCFptlCCpbR62qq1jg" clientKey:@"n6zk0DvliQpBwt2syMr2GIGULR9Ie2BuF4nO076m"];
    [Parse setApplicationId:@"ddqBdg8Sxs6TX0XWAAn5TM1F18XPfeAhAzEMcumb" clientKey:@"Y5n5l7LVSBy3xnSQGvnixBixIhPdVyNojf81U58F"];
    
    //    //testing connection to parse
    //    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //    testObject[@"iosTest"] = @"autismSees2";
    //    [testObject saveInBackground];
    //    NSLog(@"saving test parse object");
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    //enable push notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    //initialize dropbox
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"y9haoh7k2faqrmb"
                            appSecret:@"8avg0tkqaykvazz"
                            root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    camera_in_practice = 0;
    speecharray=[[NSMutableArray alloc]init];
    [self makeDBCopyAsNeeded];
    
    
    //initialize Kiip
    Kiip *kiip = [[Kiip alloc] initWithAppKey:@"1ff6f57eff9661778b6b2e5930e26b41" andSecret:@"3b75da97eb53b5374879c0ff62bd4c62"];
    kiip.delegate = self;
    [Kiip setSharedInstance:kiip];
    
    
    
    
    /*********************************************************
     //setting initial view
     
     *********************************************************/
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.viewController.leftPanel = [[JALeftViewController alloc] init];
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
   
    
    //self.viewController.rightPanel = vc1;
    //self.viewController.recognizesPanGesture = NO;
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}



//add functions to enable app to recieve push notifications from parse
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}






- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            if ([[DBChooser defaultChooser] handleOpenURL:url]) {
                }
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }else{
            NSLog(@"app not linked up");
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}
/*
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation
{
    
    if ([[DBChooser defaultChooser] handleOpenURL:url]) {
        // This was a Chooser response and handleOpenURL automatically ran the
        // completion block
        return YES;
    }
    
    return NO;
}
*/

//get settings from defaults or user settings
- (void)registerDefaultsFromSettingsBundle
{
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle)
    {
        //NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences)
    {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key)
        {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
