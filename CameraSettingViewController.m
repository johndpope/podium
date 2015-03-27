//
//  CameraSettingViewController.m
//  IPresentWell
//
//  Created by Ambika on 20/05/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "CameraSettingViewController.h"
#import "AppDelegate.h"

@interface CameraSettingViewController ()

@end

@implementation CameraSettingViewController

@synthesize headerImageView,cameraOnSwitch,recordSwitch;

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
     NSString* boldFontName = @"Avenir-Black";
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    self.infoLabel.text = @"Please adjust the settings for iPresentWell";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    headerImageView.image = [UIImage imageNamed:@"running.png"];
    headerImageView.contentMode = UIViewContentModeScaleToFill;
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    if(app.camera_in_practice == 1){
        [cameraOnSwitch setOn:YES];
    }else{
        [cameraOnSwitch setOn:NO];
    }
    if(app.camera_Blinking == 1){
        [recordSwitch setOn:YES];
    }else{
        [recordSwitch setOn:NO];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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

- (IBAction)blinkingCameraValueChanged:(id)sender {
    NSLog(@"changed");
    if(app.camera_Blinking == 0){
//        app.camera_Blinking = 1;
//        [recordSwitch setOn:YES];
//        NSLog(@"app.camera_in_practice : %ld",(long)app.camera_in_practice);
    }
    else
    {
//        app.camera_Blinking = 0;
//        [recordSwitch setOn:NO];
//        NSLog(@"app.camera_in_practice : %ld",(long)app.camera_in_practice);
    }

}

@end
