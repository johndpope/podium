//
//  SelectSpeechViewController.h
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/21/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "JADebugViewController.h"
@interface SelectSpeechViewController : UIViewController
{
    sqlite3	*database;
    UITableView *speechTableView;
}
@property (nonatomic, weak) IBOutlet UIButton *backButton;

@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;

@property (nonatomic, weak) IBOutlet UIView * infoView;

@property (nonatomic, weak) IBOutlet UILabel * infoLabel;

@property (nonatomic, retain) IBOutlet UITableView *speechTableView;

@property (nonatomic, weak) IBOutlet UIView * overlayView;

@end
