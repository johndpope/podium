//
//  CameraSettingViewController.h
//  IPresentWell
//
//  Created by Ambika on 20/05/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraSettingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIView * overlayView;
@property (nonatomic, retain) IBOutlet UILabel * infoLabel;
@property (nonatomic, retain) IBOutlet UIView * infoView;
@property (nonatomic, retain) IBOutlet UISwitch *cameraOnSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *recordSwitch;

@end
