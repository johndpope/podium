//
//  WriteTextViewController.h
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/20/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
sqlite3	*database;

@interface WriteTextViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextView *writeTextView;
@property (nonatomic, retain) IBOutlet UIButton *saveButton,*backButton;

@end
