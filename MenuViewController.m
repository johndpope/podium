//
//  MenuViewController.m
//  iPresentWell
//
//  Created by netGALAXY Studios on 2/20/14.
//  Copyright (c) 2014 ttgspeed. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"
#import "MBHUDView.h"
#import "UserMgr.h"
#import "KeychainItemWrapper.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

@implementation MenuViewController

@synthesize settingButton;

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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.sidePanelController.leftPanel = NO;
    self.sidePanelController.rightPanel = NO;
    
   // UIColor* mainColor = [UIColor whiteColor];
    //UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    
   // NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    //self.view.backgroundColor = mainColor;
    
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:18.0f];
    //self.titleLabel.text = @"CHOOSE YOUR OPERATION";
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    self.infoLabel.text = @"Please select what you want to do";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.headerImageView.image = [UIImage imageNamed:@"Background.png"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    
//    self.practiceButton.backgroundColor = darkColor;
//    self.practiceButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.practiceButton setTitle:@"Practice" forState:UIControlStateNormal];
//    [self.practiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.practiceButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
//    self.importTextButton.backgroundColor = darkColor;
//    self.importTextButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.importTextButton setTitle:@"Import Text" forState:UIControlStateNormal];
//    [self.importTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.importTextButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
//    self.writeTextButton.backgroundColor = darkColor;
//    self.writeTextButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.writeTextButton setTitle:@"Write Your Own Text" forState:UIControlStateNormal];
//    [self.writeTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.writeTextButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)redirectToPracticePage:(id)sender{
    
    UIStoryboard *SelectSpeechViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];
    UIViewController *vc = [SelectSpeechViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
    

    //[self presentViewController:vc animated:YES completion:nil];
    
//    UIStoryboard *PracticeViewControllerStoryboard = [UIStoryboard storyboardWithName:@"PracticeViewController" bundle:nil];
//    UIViewController *vc = [PracticeViewControllerStoryboard instantiateViewControllerWithIdentifier:@"PracticeViewController"];
//    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)redirectToImportTextPage:(id)sender{
    UIStoryboard *ImportTextViewControllerStoryboard = [UIStoryboard storyboardWithName:@"ImportTextViewController" bundle:nil];
    UIViewController *vc = [ImportTextViewControllerStoryboard instantiateViewControllerWithIdentifier:@"ImportTextViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)redirectToWriteTextPage:(id)sender{
    UIStoryboard *WriteTextViewControllerStoryboard = [UIStoryboard storyboardWithName:@"WriteTextViewController" bundle:nil];
    UIViewController *vc = [WriteTextViewControllerStoryboard instantiateViewControllerWithIdentifier:@"WriteTextViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)redirectToSettingPage:(id)sender{
    UIStoryboard *SettingViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SettingViewController" bundle:nil];
    UIViewController *vc = [SettingViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self presentViewController:vc animated:YES completion:nil];
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

@end
