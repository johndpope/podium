//
//  MenuViewController.h
//  iPresentWell
//
//  Created by netGALAXY Studios on 2/20/14.
//  Copyright (c) 2014 ttgspeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLoginController.h"
#import "MBProgressHUD.h"
@class JASidePanelController;
@interface MenuViewController : BaseLoginController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *practiceButton,*importTextButton,*writeTextButton,*settingButton;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;

@property (nonatomic, weak) IBOutlet UIView * infoView;

@property (nonatomic, weak) IBOutlet UILabel * infoLabel;

@property (nonatomic, weak) IBOutlet UIView * overlayView;

@end
