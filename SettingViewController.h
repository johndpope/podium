//
//  SettingViewController.h
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/21/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JALeftViewController.h"
@interface SettingViewController : JADebugViewController{
    UISwitch *cameraOnSwitch;
}

@property (nonatomic, retain) IBOutlet UIButton *backButton;

@property (nonatomic, retain) IBOutlet UIImageView * headerImageView;

@property (nonatomic, retain) IBOutlet UIView * infoView;

@property (nonatomic, retain) IBOutlet UILabel * infoLabel;

@property (nonatomic, retain) IBOutlet UISwitch *cameraOnSwitch;

@property (nonatomic, weak) IBOutlet UIView * overlayView;

@end
