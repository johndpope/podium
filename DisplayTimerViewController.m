//
//  DisplayTimerViewController.m
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/24/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "DisplayTimerViewController.h"
#import "Toast.h"
#import "AppDelegate.h"
#import <KiipSDK/KiipSDK.h>
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface DisplayTimerViewController (){
    NSString *totalTimeStr;
}

@end

@implementation DisplayTimerViewController

@synthesize timerSecondsTextField,saveButton;

//for custom time picker
@synthesize pickerView;
//@synthesize minsArray;
@synthesize secsArray;
@synthesize interval;

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
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateTimeFromPicker)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(toggleRightPanel:)];
    self.navigationItem.rightBarButtonItems = @[settingsButton,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item];
   
  //  UIColor* mainColor = [UIColor whiteColor];
  //  UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    
  //  NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    //self.view.backgroundColor = mainColor;
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    self.infoLabel.text = @"Please adjust the settings for iPresenWell";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.headerImageView.image = [UIImage imageNamed:@"running.png"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
//    self.backButton.backgroundColor = darkColor;
//    self.backButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.backButton setTitle:@"BACK" forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
//    
//    self.saveButton.backgroundColor = darkColor;
//    self.saveButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.saveButton setTitle:@"SET VISUAL CUE TIMER" forState:UIControlStateNormal];
//    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.saveButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    
    app= (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    app.timerCounter = 0;
    
    //for custom timer picker
    //initialize arrays
    //minsArray = [[NSMutableArray alloc] init];
    secsArray = [[NSMutableArray alloc] init];
    NSString *strVal = [[NSString alloc] init];
    
    for(int i=0; i<21; i=i+5)
    {
        strVal = [NSString stringWithFormat:@"%d", i];
        
        //create arrays with 0-60 secs/mins
        //[minsArray addObject:strVal];
        [secsArray addObject:strVal];
    }
}

//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
//    if (component==0)
//    {
//        return [minsArray count];
//    }
//    else
//    {
        return [secsArray count];
    //}
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (row)
    {
        case 0:
            return @"No Reminder";
            break;
        default:
            return [secsArray objectAtIndex:row];
            break;
    }
//    return nil;
}

-(IBAction)calculateTimeFromPicker
{
//    NSString *minsStr = [NSString stringWithFormat:@"%@",[minsArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
    
    NSString *secsStr = [NSString stringWithFormat:@"%@",[secsArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
    
//    int minsInt = [minsStr intValue];
    int secsInt = [secsStr intValue];
    
//    interval = secsInt + (minsInt*60);
    interval = secsInt;
    
//    NSLog(@"mins: %d .... sec: %d .... interval: %f", minsInt, secsInt, interval);
    NSLog(@"mins: %d .... sec: %d .... interval: %f", secsInt, interval);
    
    totalTimeStr = [NSString stringWithFormat:@"%f",interval];
    NSLog(@"totalTimeStr: %@", totalTimeStr);
    
    app.secondsToSleepInDouble = [totalTimeStr doubleValue];
    
    Toast *mToast = [Toast toastWithMessage:@"Your settings has been saved successfully"];
    [mToast showOnView:self.view];
    
//    //test of kiip rewards
//    [[Kiip sharedInstance] saveMoment:@"Set a visual timer" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
//        if (error) {
//            
//            NSLog(@"something's wrong");
//            // handle with an Alert dialog.
//        }
//        if (poptart) {
//            
//            [poptart show];
//        }
//        if (!poptart) {
//            Toast *mToast = [Toast toastWithMessage:@"Oh Snap! There is no reward available at this time. Please try again later."];
//            [mToast showOnView:self.view];
//            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(redirectBackToSettingPage:) userInfo:nil repeats:NO];
//        }
//    }];
    
    
    //go right back, without kiip reward
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];
    UIViewController *SelectSpeech = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:SelectSpeech];
}

- (void) kiip:(Kiip *)kiip didReceiveContent:(NSString *)contentId quantity:(int)quantity transactionId:(NSString *)transactionId signature:(NSString *)signature {
    // Give the currency to the user by using your in-app currency management.
    NSLog(@"%@ %d %@ %@",contentId,quantity,transactionId,signature);
}

-(IBAction)saveButtonClicked:(id)sender{
    app.secondsToSleep = self.timerSecondsTextField.text;
    app.secondsToSleepInDouble = [totalTimeStr doubleValue];
    
    NSLog(@"app.secondsToSleep : %@",app.secondsToSleep);
    NSLog(@"app.secondsToSleepInDouble : %f",app.secondsToSleepInDouble);
    
    Toast *mToast = [Toast toastWithMessage:@"Your settings has been saved successfully"];
    [mToast showOnView:self.view];
     [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(redirectBackToSettingPage:) userInfo:nil repeats:NO];
   /* UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];
    UIViewController *SelectSpeech = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:SelectSpeech];
    */
}

-(void)viewWillAppear:(BOOL)animated{
    self.timerSecondsTextField.text = app.secondsToSleep;
}

-(IBAction)redirectBackToSettingPage:(id)sender{ 
    /*UIStoryboard *SettingViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SettingViewController" bundle:nil];
    UIViewController *vc = [SettingViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self presentViewController:vc animated:YES completion:nil];*/
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];
    UIViewController *SelectSpeech = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:SelectSpeech];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
