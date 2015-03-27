//
//  WriteTextViewController.m
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/20/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "WriteTextViewController.h"
#import "UserMgr.h"
#import "Toast.h"
#import "MBHUDView.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "JARightViewController.h"

@interface WriteTextViewController ()

@end

@implementation WriteTextViewController

@synthesize titleTextField,writeTextView,saveButton,backButton;

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
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveTextButtonClicked:)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(toggleRightPanel:)];
    self.navigationItem.rightBarButtonItems = @[settingsButton,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item];
    

	// Do any additional setup after loading the view.
   // UIColor* mainColor = [UIColor whiteColor];
   // UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    
  //  NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    //UIBarButtonItem *addAttachButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTextButtonClicked:)];
    
   /// UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(toggleRightPanel:)];
    
    //self.navigationItem.rightBarButtonItems = @[settingsButton,addAttachButton];
    //self.view.backgroundColor = mainColor;
    
    //    self.saveButton.backgroundColor = darkColor;
    //    self.saveButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    //    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    //    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.saveButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    //
    //    self.backButton.backgroundColor = darkColor;
    //    self.backButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    //    [self.backButton setTitle:@"BACK" forState:UIControlStateNormal];
    //    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.backButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    //To display border around text view
    CALayer *layer = writeTextView.layer;
    layer.borderWidth = 5.0f;
    layer.borderColor = [[UIColor grayColor] CGColor];
    writeTextView.layer.masksToBounds = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)redirectBackToMenuPage:(id)sender{
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"MenuViewController" bundle:nil];
    UIViewController *vc = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)didPressLink {
   }
-(IBAction)saveTextButtonClicked:(id)sender{
    
    if(titleTextField.text.length < 1 || writeTextView.text.length<1){
        //Empty fields validation
        MBAlertView *alert = [MBAlertView alertWithBody:@"Title or Speechtext fields can not be empty." cancelTitle:@"Ok" cancelBlock:nil];
        [alert addToDisplayQueue];
    }
    else
    {
        NSString *title = titleTextField.text;
        NSString *writtenText = writeTextView.text;
        NSString *stringWithoutSpaces = [writtenText
                                         stringByReplacingOccurrencesOfString:@"'" withString:@""];
        // writtenText = [[writtenText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
        
        
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/YY"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        
        //Insert record in to database
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
        if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat:@"insert into Speech (speech_text,speech_date,speech_title) Values ('%@','%@','%@')",stringWithoutSpaces,dateString,title];
            const char *sql = [querySQL UTF8String];
            sqlite3_stmt *searchStatement;
            
            if (sqlite3_prepare_v2(database, sql, -1, &searchStatement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(searchStatement) == SQLITE_ROW)
                {
                    
                }
            }
            sqlite3_finalize(searchStatement);
        }
        
        sqlite3_close(database);
        
        Toast *mToast = [Toast toastWithMessage:@"Your speech has been saved successfully"];
        [mToast showOnView:self.view];
        
        UIStoryboard *SelectSpeechViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];
        UIViewController *vc = [SelectSpeechViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];
      //  [self presentViewController:vc animated:YES completion:nil];
        
        self.sidePanelController.centerPanel =[[UINavigationController alloc] initWithRootViewController:vc];
    }
}

- (void)toggleRightPanel:(__unused id)sender {
    
    JASidePanelController *ja = [[JASidePanelController alloc]init];
   // JARightViewController *right = [[JARightViewController alloc]init];
     self.sidePanelController.rightPanel = [[JARightViewController alloc]init];
    self.sidePanelController.rightPanelContainer.hidden = YES;
    //ja.rightPanel = JASidePanelRightVisible;
    
    [ja showRightPanelAnimated:YES];
    //[ja toggleRightPanel:nil];
    
}

@end
