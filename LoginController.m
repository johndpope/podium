//
//  LoginController.m
//  UserMgr
//
//  Created by netGALAXY Studios on 30/05/2013.
//  Copyright (c) 2013 netGALAXY Studios. All rights reserved.
//

#import "LoginController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"
#import "MBHUDView.h"
#import "UserMgr.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "MenuViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface LoginController ()

@end

@implementation LoginController

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
    
//    self.registerButton.backgroundColor = darkColor;
//    self.registerButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.registerButton setTitle:@"CREATE AN ACCOUNT" forState:UIControlStateNormal];
//    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.registerButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
//    self.loginButton.backgroundColor = darkColor;
//    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
//    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.forgotButton.backgroundColor = [UIColor clearColor];
    //self.forgotButton.titleLabel.font = [UIFont fontWithName:fontName size:12.0f];
   // [self.forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
   // [self.forgotButton setTitleColor:darkColor forState:UIControlStateNormal];
    //[self.forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    self.titleLabel.text = @"";
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:12.0f];
    self.infoLabel.text = @"Welcome to iPresentWell, please login";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.headerImageView.image = [UIImage imageNamed:@"running.png"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (IBAction)login:(id)sender {
    NSLog(@"signing in...");
    NSString *username = [_usernameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *password = [_passwordField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //login with parse
    NSLog(@"login with parse");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFUser logInWithUsernameInBackground:username password:password
                    block:^(PFUser *user, NSError *error) {
                        if (user) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"username"];

                            //AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                            //appDelegate.userName =
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //after local login check parse.  Do we want this duplication?
                            NSLog(@"logged in with parse");
                            UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];//@"MenuViewController" bundle:nil];
                            UIViewController *vc = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];//@"MenuViewController"];
                            //[self presentViewController:vc animated:YES completion:nil];
                            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
                        } else {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            // The login failed. Check error to see why.
                            NSString *errorString = [error userInfo][@"error"];
                            NSLog(errorString);
                            MBAlertView *alert = [MBAlertView alertWithBody:errorString cancelTitle:@"Ok" cancelBlock:nil];
                            [alert addToDisplayQueue];
                        }
                    }];
    
//    NSLog(@"validate with usermgr");
//    UserMgr* manager = [[UserMgr alloc] init];
//    [manager userDidSignIn:username :password :self.view
//                completion:^(bool didSignIn){
//                    if(didSignIn){
//                        UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];//@"MenuViewController" bundle:nil];
//                        UIViewController *vc = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];//@"MenuViewController"];
//                        //[self presentViewController:vc animated:YES completion:nil];
//                        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
//                    }
//                    else{
//                        MBAlertView *alert = [MBAlertView alertWithBody:@"Please enter a valid username and password" cancelTitle:@"Ok" cancelBlock:nil];
//                        [alert addToDisplayQueue];
//                    }
//                }];

}

//not sure where this is being referenced or called, but can't remove it.
- (IBAction)signIn:(id)sender
{
}

- (IBAction)registerButtonClicked:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RegisterStoryboard" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterController"];
    //[self presentViewController:vc animated:YES completion:nil];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
}

- (IBAction)forgotPassPressed:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
