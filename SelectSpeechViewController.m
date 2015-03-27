//
//  SelectSpeechViewController.m
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/21/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "SelectSpeechViewController.h"
#import "AppDelegate.h"
#import "CustomCellView.h"
#import "SpeechClass.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "JARightViewController.h"
#import "JALeftViewController.h"
#import "SettingViewController.h"
#import <Parse/Parse.h>

@interface SelectSpeechViewController ()

@end

@implementation SelectSpeechViewController

@synthesize speechTableView;

AppDelegate *app;
SpeechClass *speechObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) getspeech
{
    app.speecharray = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM Speech"];
        const char *sql = [querySQL UTF8String];
        sqlite3_stmt *searchStatement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStatement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStatement) == SQLITE_ROW)
            {
                
                speechObj=[[SpeechClass alloc]init];
                
                NSString *speechID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 0)];
                 speechObj.speechID=speechID;
                if((char *)sqlite3_column_text(searchStatement, 1) !=  NULL ){
                NSString *speechText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 1)];
                speechObj.speechText=speechText;
                }
          
                NSString *speechDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 2)];
                speechObj.speechDate=speechDate;


                NSString *speechTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 3)];
                speechObj.speechTitle=speechTitle;

                [app.speecharray addObject:speechObj];
            }
            
        }
        sqlite3_finalize(searchStatement);
        
    }
    sqlite3_close(database);
    [speechTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *menuViewControllerStoryboard1 = [UIStoryboard storyboardWithName:@"SettingViewController" bundle:nil];
    UIViewController *vc1 = [menuViewControllerStoryboard1 instantiateViewControllerWithIdentifier:@"SettingViewController"];
    self.sidePanelController.rightPanel = vc1;
    self.sidePanelController.leftPanel = [[JALeftViewController alloc]init];

   self.sidePanelController.recognizesPanGesture = NO;
  self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutUser:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    

    app= (AppDelegate *)[[UIApplication sharedApplication]delegate];
      [self getspeech];
	// Do any additional setup after loading the view.
      //  UIColor* mainColor = [UIColor whiteColor];
   // UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    
   // NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    //self.view.backgroundColor = mainColor;
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    self.infoLabel.text = @"or select a note to practice:";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.headerImageView.image = [UIImage imageNamed:@"running.png"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
//    self.backButton.backgroundColor = darkColor;
//    self.backButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.backButton setTitle:@"BACK" forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
}
- (IBAction)redirectToPracticePageFromServer:(id)sender {
    app.i = -1;
    
    UIStoryboard *PracticeViewControllerStoryboard = [UIStoryboard storyboardWithName:@"PracticeViewController" bundle:nil];
    UIViewController *vc = [PracticeViewControllerStoryboard instantiateViewControllerWithIdentifier:@"PracticeViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)redirectToPracticePage:(id)sender{
    UIStoryboard *PracticeViewControllerStoryboard = [UIStoryboard storyboardWithName:@"PracticeViewController" bundle:nil];
    UIViewController *vc = [PracticeViewControllerStoryboard instantiateViewControllerWithIdentifier:@"PracticeViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)redirectBackToMenuPage:(id)sender{
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"MenuViewController" bundle:nil];
    UIViewController *vc = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)redirectBackToSettingPage:(id)sender{
    UIStoryboard *SettingViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SettingViewController" bundle:nil];
    UIViewController *vc = [SettingViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)logoutUser:(id)sender{
    //log out user
    [PFUser logOut];
    NSLog(@"logging out");
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginController"];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:vc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [app.speecharray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCellView *cell = (CustomCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellView" owner:self options:Nil];
        cell = [nib objectAtIndex:0];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...

    speechObj=[app.speecharray objectAtIndex:indexPath.row];
    
    cell.speechTitle.text = speechObj.speechTitle;
    cell.speechDate.text = speechObj.speechDate;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    app.i = indexPath.row;
    
    UIStoryboard *PracticeViewControllerStoryboard = [UIStoryboard storyboardWithName:@"PracticeViewController" bundle:nil];
    UIViewController *vc = [PracticeViewControllerStoryboard instantiateViewControllerWithIdentifier:@"PracticeViewController"];
    //[self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
   // self.sidePanelController.centerPanel  = [[UINavigationController alloc]initWithRootViewController:vc];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSUInteger row = [indexPath row];
    speechObj = [app.speecharray objectAtIndex:row] ;
    //Insert record in to database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"delete from Speech where speech_title='%@'",speechObj.speechTitle];
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

    [app.speecharray removeObjectAtIndex:indexPath.row];
   [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     [tableView reloadData];
   
}

@end
