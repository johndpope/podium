//
//  SettingViewController.m
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/21/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
// #import "KiipSDK.framework"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize cameraOnSwitch;

AppDelegate *app;

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
    self.navigationController.navigationBarHidden = NO;

    //UIColor* mainColor = [UIColor whiteColor];
    //UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    
   // NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    //self.view.backgroundColor = mainColor;
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    self.infoLabel.text = @"Please adjust the settings for iPresentWell";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.headerImageView.image = [UIImage imageNamed:@"running.png"];
    self.headerImageView.contentMode = UIViewContentModeScaleToFill;
    
//    self.backButton.backgroundColor = darkColor;
//    self.backButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.backButton setTitle:@"BACK" forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
     self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    
    app= (AppDelegate *)[[UIApplication sharedApplication]delegate];

}

-(void)viewWillAppear:(BOOL)animated{
    if(app.camera_in_practice == 1){
        [cameraOnSwitch setOn:YES];
    }else{
        [cameraOnSwitch setOn:NO];
    }
}

-(IBAction)redirectBackToMenuPage:(id)sender{
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"MenuViewController" bundle:nil];
    UIViewController *vc = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
   // [self presentViewController:vc animated:YES completion:nil];
   self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
}

-(IBAction)redirectToDisplayTimerPage:(id)sender{
    UIStoryboard *DisplayTimerViewControllerStoryboard = [UIStoryboard storyboardWithName:@"DisplayTimerViewController" bundle:nil];
    UIViewController *vc = [DisplayTimerViewControllerStoryboard instantiateViewControllerWithIdentifier:@"DisplayTimerViewController"];
  // [self presentViewController:vc animated:YES completion:nil];
    
 self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:vc];
    
//    [[Kiip sharedInstance] saveMoment:@"Setting Timer!" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
//        if (error) {
//            NSLog(@"something's wrong");
            // handle with an Alert dialog.
//        }
//        if (poptart) {
//            [poptart show];
//        }
//        if (!poptart) {
            // handle logic when there is no reward to give.
//        }
//    }];
    
}

-(IBAction)redirectToAboutThisAppPage:(id)sender{
    UIStoryboard *AboutThisAppViewControllerStoryboard = [UIStoryboard storyboardWithName:@"AboutThisAppViewController" bundle:nil];
    UIViewController *vc1 = [AboutThisAppViewControllerStoryboard instantiateViewControllerWithIdentifier:@"AboutThisAppViewController"];
    [self.navigationController pushViewController:vc1 animated:NO];

// [self presentViewController:vc1 animated:YES completion:nil];
   
      self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:vc1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cameraOnSwitchValueChanged:(id)sender{
    

    if(app.camera_in_practice == 0){
        app.camera_in_practice = 1;
        [cameraOnSwitch setOn:YES];
        NSLog(@"app.camera_in_practice : %ld",(long)app.camera_in_practice);
    }
    else
    {
        app.camera_in_practice = 0;
        [cameraOnSwitch setOn:NO];
        NSLog(@"app.camera_in_practice : %ld",(long)app.camera_in_practice);
    }
}
- (IBAction)redirectToCameraSettingPage:(id)sender {
    
    UIStoryboard *DisplayTimerViewControllerStoryboard = [UIStoryboard storyboardWithName:@"CameraSettingViewController" bundle:nil];
    UIViewController *vc = [DisplayTimerViewControllerStoryboard instantiateViewControllerWithIdentifier:@"CameraSettingViewController"];
    // [self presentViewController:vc animated:YES completion:nil];
    
    self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:vc];
    
    
}

@end
