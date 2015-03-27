//
//  WelcomeController.h
//  UserMgr
//
//  Created by netGALAXY Studios on 30/05/2013.
//  Copyright (c) 2013 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLoginController.h"
#import "MBProgressHUD.h"

@interface WelcomeController : BaseLoginController

@property (nonatomic, weak) IBOutlet UIButton *logoutButton;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;

@property (nonatomic, weak) IBOutlet UIView * infoView;

@property (nonatomic, weak) IBOutlet UILabel * infoLabel;

@property (nonatomic, weak) IBOutlet UIView * overlayView;

//


@end
