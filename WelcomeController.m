//
//  WelcomeController.m
//  UserMgr
//
//  Created by netGALAXY Studios on 30/05/2013.
//  Copyright (c) 2013 netGALAXY Studios. All rights reserved.
//

#import "WelcomeController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBHUDView.h"
#import "KeychainItemWrapper.h"

@interface WelcomeController ()

@end

@implementation WelcomeController

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
    
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserMgr" accessGroup:nil];
    NSString *username = [[keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
   // UIColor* mainColor = [UIColor whiteColor];
    UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    
    NSString* boldFontName = @"Avenir-Black";
    
    //self.view.backgroundColor = mainColor;
    
    self.logoutButton.backgroundColor = darkColor;
    self.logoutButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.logoutButton setTitle:@"LOGOUT" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:18.0f];
    self.titleLabel.text = @"WELCOME BACK";
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@%@", @"Nice to see you again, ", username];
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.headerImageView.image = [UIImage imageNamed:@"running.png"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    
}

- (IBAction)logoutButtonClicked:(id)sender
{
    //delete the username/password from the keychain
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserMgr" accessGroup:nil];
    [keychainWrapper resetKeychainItem];
    
    //go back to the login screen
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
