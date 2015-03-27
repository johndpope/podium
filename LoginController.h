//
//  LoginController.h
//  UserMgr
//
//  Created by netGALAXY Studios on 30/05/2013.
//  Copyright (c) 2013 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLoginController.h"
#import "MBProgressHUD.h"

@interface LoginController : BaseLoginController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField * usernameField;

@property (nonatomic, weak) IBOutlet UITextField * passwordField;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, weak) IBOutlet UIButton * forgotButton;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;

@property (nonatomic, weak) IBOutlet UIView * infoView;

@property (nonatomic, weak) IBOutlet UILabel * infoLabel;

@property (nonatomic, weak) IBOutlet UIView * overlayView;

////disabled this because of duplicate event
//- (IBAction)signIn:(id)sender;
- (IBAction)registerButtonClicked:(id)sender;
- (IBAction)forgotPassPressed:(id)sender;


@end
