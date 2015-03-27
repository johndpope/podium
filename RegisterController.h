//
//  RegisterController.h
//  UserMgr
//
//  Created by netGALAXY Studios on 30/05/2013.
//  Copyright (c) 2013 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLoginController.h"
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import <sqlite3.h>
#import "STTwitter.h"
sqlite3	*database;

@interface RegisterController : BaseLoginController <UITextFieldDelegate,FBLoginViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField * usernameField;

@property (nonatomic, weak) IBOutlet UITextField * passwordField;
@property (nonatomic, weak) IBOutlet UITextField * passwordConfirmField;

@property (nonatomic, weak) IBOutlet UITextField * emailField;

@property (nonatomic, weak) IBOutlet UIButton *backButton;

@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;

@property (nonatomic, weak) IBOutlet UIView * infoView;

@property (nonatomic, weak) IBOutlet UILabel * infoLabel;

@property (nonatomic, weak) IBOutlet UIView * overlayView;
- (IBAction)twitterLogin:(id)sender;

//twitter stuff
@property (nonatomic, strong) STTwitterAPI *twitter;
//


@end
