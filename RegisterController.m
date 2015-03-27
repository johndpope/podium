//
//  RegisterController.m
//  UserMgr
//
//  Created by netGALAXY Studios on 30/05/2013.
//  Copyright (c) 2013 netGALAXY Studios. All rights reserved.
//

#import "RegisterController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"
#import "MBHUDView.h"
#import "UserMgr.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import <Parse/Parse.h>


static NSString *const twitterConsumerKey = @"TCa8yu4qSvuWxzhNC4L7g8jkk";
static NSString *const twitterPrivateKey = @"Oov5reNIvMzFa9E1ToPcrLpXVC2FrxbXrS2JRkg5D4cR75VOrZ";
static bool isFirstLoginDone = NO;
@implementation RegisterController

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
	
    UIColor* mainColor = [UIColor whiteColor];
    //UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    self.navigationController.navigationBarHidden = YES;
    self.sidePanelController.leftPanel = NO;
    self.sidePanelController.rightPanel = NO;
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    
    self.usernameField.delegate = self;
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.placeholder = @"Username";
    self.usernameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.usernameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.usernameField.layer.borderWidth = 1.0f;
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView = leftView;
    
    self.passwordField.delegate = self;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.passwordField.layer.borderWidth = 1.0f;
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = leftView2;
    
    //self.passwordConfirmField.delegate = self;
    self.passwordConfirmField.backgroundColor = [UIColor whiteColor];
    self.passwordConfirmField.placeholder = @"Confirm Password";
    self.passwordConfirmField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordConfirmField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.passwordConfirmField.layer.borderWidth = 1.0f;
    UIView* leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.passwordConfirmField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordConfirmField.leftView = leftView3;
    
    self.emailField.delegate = self;
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.placeholder = @"Email Address";
    self.emailField.font = [UIFont fontWithName:fontName size:16.0f];
    self.emailField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.emailField.layer.borderWidth = 1.0f;
    UIView* leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.leftView = leftView4;
    
//    self.backButton.backgroundColor = darkColor;
//    self.backButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.backButton setTitle:@"BACK" forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
//    
//    self.registerButton.backgroundColor = darkColor;
//    self.registerButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.registerButton setTitle:@"CREATE ACCOUNT" forState:UIControlStateNormal];
//    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.registerButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:18.0f];
    self.titleLabel.text = @"REGISTER AN ACCOUNT";
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    self.infoLabel.text = @"Please fill in the fields below";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.headerImageView.image = [UIImage imageNamed:@"running.png"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    
//    //create a Facebook button
//    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email"]];
//    
//    // Align the button in the center horizontally
//    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x +(loginView.frame.size.width /4)),935);
//    [self.view addSubview:loginView];
//    loginView.delegate = self;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)registerButtonClicked:(id)sender
{

    
    
    
    
    //get the username, passwords, and email from the textfields
    NSString *username = [_usernameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *password = [_passwordField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *passwordConfirm = [_passwordConfirmField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *email = [_emailField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    //why is this outside of verification?
    //Adding User details in sqlite datbase
    NSString *username_for_sqlite = _usernameField.text;
    NSString *password_for_sqlite = _passwordField.text;
    NSString *email_for_sqlite = _emailField.text;
    
    NSLog(@"verification with usermgr");
    UserMgr* manager = [[UserMgr alloc] init];
    if([manager verifyRegistratonForm:username :password :passwordConfirm :email]){
        
        
        //add parse user login action
        NSLog(@"login with parse");
        PFUser *user = [PFUser user];
        user.username = username;
        user.password = password;
        user.email = email;
        // other fields can be set just like with PFObject
        user[@"phone"] = @"none";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"username"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                // Hooray! Let them use the app now.
                NSLog(@"aregistered user with parse");
                MBAlertView *alert = [MBAlertView alertWithBody:@"Your account has been created!" cancelTitle:nil cancelBlock:nil];
                [alert addButtonWithText:@"OK" type:MBAlertViewItemTypePositive block:^{
                    //[self showLogin:self];
                    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];//@"MenuViewController" bundle:nil];
                    UIViewController *vc = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];//@"MenuViewController"];
                    //[self presentViewController:vc animated:YES completion:nil];
                    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
                }];
                [alert addToDisplayQueue];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *errorString = [error userInfo][@"error"];
                // Show the errorString somewhere and let the user try again.
                NSLog(errorString);
                MBAlertView *alert = [MBAlertView alertWithBody:errorString cancelTitle:nil cancelBlock:nil];
                [alert addButtonWithText:@"OK" type:MBAlertViewItemTypePositive block:^{
                }];
                [alert addToDisplayQueue];
            }
        }];
        
        
        
        
//        [manager userDidRegister:username :password :email :self.view
//                      completion:^(bool didRegister){
//                          if(didRegister){
//                              MBAlertView *alert = [MBAlertView alertWithBody:@"Your account has been created!" cancelTitle:nil cancelBlock:nil];
//                              [alert addButtonWithText:@"OK" type:MBAlertViewItemTypePositive block:^{
//                                  //[self showLogin:self];
//                                  UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];//@"MenuViewController" bundle:nil];
//                                  UIViewController *vc = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];//@"MenuViewController"];
//                                  //[self presentViewController:vc animated:YES completion:nil];
//                                  self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
//                              }];
//                              [alert addToDisplayQueue];
//                          }
//                      }];
//        
//        
//        
//        //Save new user in local database
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
//        if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
//        {
//            NSString *querySQL = [NSString stringWithFormat:@"insert into user (username,password,email_address) Values ('%@','%@','%@')",username_for_sqlite,password_for_sqlite,email_for_sqlite];
//            const char *sql = [querySQL UTF8String];
//            sqlite3_stmt *searchStatement;
//            
//            if (sqlite3_prepare_v2(database, sql, -1, &searchStatement, NULL) == SQLITE_OK)
//            {
//                while (sqlite3_step(searchStatement) == SQLITE_ROW)
//                {
//                    
//                }
//            }
//            sqlite3_finalize(searchStatement);
//        }
//        sqlite3_close(database);
//        
//        
//        //send new user to parse manually (as an IPWUser).  This will be removed if standard parse use class works.
//        NSLog(@"credentials verified, saving new user to parse");
//        PFObject *IPWUser = [PFObject objectWithClassName:@"IPWUser"];
//        IPWUser[@"username"] = username_for_sqlite;
//        IPWUser[@"password"] = password_for_sqlite;
//        IPWUser[@"emailAddress"] = email_for_sqlite;
//        [IPWUser saveEventually];
        
    }else{
        NSLog(@"bad credentials, nothing saved to server.");
    }
}

- (IBAction)showLogin:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginController"];
    //[self presentViewController:vc animated:YES completion:nil];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
}

//take them back to the login storyboard
- (IBAction)backButtonClicked:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginController"];
    //[self presentViewController:vc animated:YES completion:nil];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)twitterLogin:(id)sender {
    
    NSLog(@"Logging in");
    
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 460) ];
        HUD.labelText = @"Logging in...";
        [self.view addSubview:HUD];
        [HUD show:YES];
        
        STTwitterAPI *twitter =  [STTwitterAPI twitterAPIWithOAuthConsumerName:nil consumerKey:twitterConsumerKey consumerSecret:twitterPrivateKey];
        
        [twitter postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
            
            STTwitterAPI *twitterAPIOS = [STTwitterAPI twitterAPIOSWithFirstAccount];
            
            [twitterAPIOS verifyCredentialsWithSuccessBlock:^(NSString *username) {
                
                [twitterAPIOS postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                                    successBlock:^(NSString *oAuthToken,
                                                                                   NSString *oAuthTokenSecret,
                                                                                   NSString *userID,
                                                                                   NSString *screenName) {
                                                                        
                                                                        [HUD hide:YES];
                                                                        [HUD removeFromSuperViewOnHide];
                                                                        
                                                                        UserMgr* manager = [[UserMgr alloc] init];
                                                                        [manager twitterUserDidRegister:userID :username currentView:self.view
                                                                                             completion:^(bool didRegister){
                                                                                                 if(didRegister){
                                                                                                     [manager saveUserDetailsTwitter:username];
                                                                                                     [self showWelcome:self];
                                                                                                 }
                                                                                                 else{
                                                                                                     MBAlertView *alert = [MBAlertView alertWithBody:@"There was an error signing in. Please try again soon." cancelTitle:@"Ok" cancelBlock:nil];
                                                                                                     [alert addToDisplayQueue];
                                                                                                 }
                                                                                             }];
                                                                        
                                                                    } errorBlock:^(NSError *error) {
                                                                        [HUD hide:YES];
                                                                        [HUD removeFromSuperViewOnHide];
                                                                        
                                                                        MBAlertView *alert = [MBAlertView alertWithBody:@"There was an error signing in. Please try again soon." cancelTitle:@"Ok" cancelBlock:nil];
                                                                        [alert addToDisplayQueue];
                                                                    }];
                
            } errorBlock:^(NSError *error) {
                [HUD hide:YES];
                [HUD removeFromSuperViewOnHide];
                
                MBAlertView *alert = [MBAlertView alertWithBody:@"There was an error signing in. Please try again soon." cancelTitle:@"Ok" cancelBlock:nil];
                [alert addToDisplayQueue];
            }];
            
        } errorBlock:^(NSError *error) {
            [HUD hide:YES];
            [HUD removeFromSuperViewOnHide];
            
            MBAlertView *alert = [MBAlertView alertWithBody:@"There was an error signing in. Please try again soon." cancelTitle:@"Ok" cancelBlock:nil];
            [alert addToDisplayQueue];
        }];
        
    }




- (IBAction)showWelcome:(id)sender
{
    //check if view is still being presented (facebook login)
    if(self.isBeingPresented){
        [self performSelector:@selector(showWelcome:) withObject:nil afterDelay:.1];
    }
    else{
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MenuViewController" bundle:nil];
        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        // [self presentViewController:vc animated:YES completion:nil];
        //self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
        //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"WelcomeStoryboard" bundle:nil];
        //UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"WelcomeController"];
        //[self presentViewController:vc animated:YES completion:nil];
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
    }
}
///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Facebook Handling
#pragma mark -
///////////////////////////////////////////////////////////////////////////

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"User is not logged in to Facebook");
}

//logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    // Set first login flag to prevent duplicate calls (this is an error with the Facebook SDK)
    isFirstLoginDone = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginType"];
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    // Check first login
    if(isFirstLoginDone) {
        /*NSLog(@"ID: %@",user.id);
         NSLog(@"First Name: %@",user.first_name);
         NSLog(@"Last Name: %@",user.last_name);
         NSLog(@"Email: %@",[user objectForKey:@"email"]);*/
        
        UserMgr* manager = [[UserMgr alloc] init];
        [manager facebookUserDidRegister:user.id firstname:user.first_name lastname:user.last_name email:[user objectForKey:@"email"] currentView:self.view
                              completion:^(bool didRegister){
                                  if(didRegister){
                                      [manager saveUserDetailsFacebook:user.id :user.first_name :user.last_name :[user objectForKey:@"email"]];
                                      
                                      [self showWelcome:self];
                                  }
                                  else{
                                      MBAlertView *alert = [MBAlertView alertWithBody:@"There was an error signing in. Please try again soon." cancelTitle:@"OK" cancelBlock:nil];
                                      [alert addToDisplayQueue];
                                  }
                              }];
    }
    
    // clear the flag
    isFirstLoginDone = NO;
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


@end
