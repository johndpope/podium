//
//  AboutThisAppViewController.m
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/24/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "AboutThisAppViewController.h"

@interface AboutThisAppViewController ()

@end

@implementation AboutThisAppViewController

@synthesize backButton;

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
	// Do any additional setup after loading the view.
   // UIColor* mainColor = [UIColor whiteColor];
    //UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    
   // NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    //self.view.backgroundColor = mainColor;
//    self.backButton.backgroundColor = darkColor;
//    self.backButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.backButton setTitle:@"BACK" forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)redirectBackToSettingPage:(id)sender{
    UIStoryboard *SettingViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SettingViewController" bundle:nil];
    UIViewController *vc = [SettingViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
