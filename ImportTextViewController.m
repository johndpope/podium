//
//  ImportTextViewController.m
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/26/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "ImportTextViewController.h"
#import "Toast.h"

#import "PracticeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "AppDelegate.h"

@interface ImportTextViewController ()

@end
AppDelegate *app;
@implementation ImportTextViewController

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
    //self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    //self.restClient.delegate = self;
    //UIColor* mainColor = [UIColor whiteColor];
    //UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    
   // NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    self.infoLabel.text = @"Please select from where you want to import text";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.headerImageView.image = [UIImage imageNamed:@"running.png"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    
//    self.messageButton.backgroundColor = darkColor;
//    self.messageButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.messageButton setTitle:@"Import Text From Message" forState:UIControlStateNormal];
//    [self.messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.messageButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
//    
//    self.mailButton.backgroundColor = darkColor;
//    self.mailButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.mailButton setTitle:@"Import Text From Mail" forState:UIControlStateNormal];
//    [self.mailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.mailButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
//    
//    self.gmailButton.backgroundColor = darkColor;
//    self.gmailButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.gmailButton setTitle:@"Import Text From Gmail" forState:UIControlStateNormal];
//    [self.gmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.gmailButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
//    
//    self.bookstoreButton.backgroundColor = darkColor;
//    self.bookstoreButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.bookstoreButton setTitle:@"Import Text From Bookstore" forState:UIControlStateNormal];
//    [self.bookstoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.bookstoreButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
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

-(IBAction)openMailBox:(id)sender{
//    #define URLEMail @"mailto:sb@sw.com?subject=title&body=content"
    #define URLEMail @"mailto:"
    NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    if ([[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]]){
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Application not found" message:@"Mail application is not installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)openMessageBox:(id)sender{
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"]]){
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: @"sms:"]];
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Application not found" message:@"Message application is not installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)openGmail:(id)sender{
    #define URLGMail @"googlegmail://"
    NSString *url = [URLGMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    if ([[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]]){
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Application not found" message:@"Gmail application is not installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

-(IBAction)openBookstore:(id)sender{
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-books:"]]){
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: @"itms-books:"]];
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Application not found" message:@"Bookstore is not installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didPressChoose
{
    if (![[DBSession sharedSession] isLinked]) {
        
        
        [[DBSession sharedSession] linkFromController:self];
        [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypeDirect
                                        fromViewController:self completion:^(NSArray *results)
         {
             if ([results count]) {
                 // Process results from Chooser
                 NSLog(@"%@",results);
                 DBChooserResult *_result = results[0];
                 NSLog(@"%@",_result);
                 
                 app.appResult = _result;
                 
                 UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"PracticeViewController" bundle:nil];
                 UIViewController *WriteTextView = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"PracticeViewController"];
                 self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:WriteTextView];
                 
                 
             } else {
                 // User canceled the action
                 
                 [[[UIAlertView alloc] initWithTitle:@"CANCELLED" message:@"user cancelled!"
                                            delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil]
                  show];
             }
         }];

    }
    else{
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypeDirect
                                    fromViewController:self completion:^(NSArray *results)
     {
         if ([results count]) {
             // Process results from Chooser
             NSLog(@"%@",results);
             DBChooserResult *_result = results[0];
             NSLog(@"%@",_result);
             
             app.appResult = _result;
             
             UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"PracticeViewController" bundle:nil];
             UIViewController *WriteTextView = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"PracticeViewController"];
             self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:WriteTextView];
             
             
         } else {
             // User canceled the action
             
             [[[UIAlertView alloc] initWithTitle:@"CANCELLED" message:@"user cancelled!"
                                        delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil]
              show];
         }
     }];
    }
}


-(IBAction)redirectBackToMenuPage:(id)sender{
    
    
    [self didPressChoose];
    /*
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
[self.restClient loadMetadata:@"/Photo Application"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //Create PDF_Documents directory
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"PDF_Documents"];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"**PUT FILENAME YOU WANT**"];
    //[self.restClient loadFile:@"/Getting Started.pdf" intoPath:filePath];
    //[dataPdf writeToFile:filePath atomically:YES];
    */
}

@end
