//
//  ImportTextViewController.h
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/26/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <DropboxSDK/DropboxSDK.h>
#import <DBChooser/DBChooser.h>



@interface ImportTextViewController : UIViewController <DBRestClientDelegate>{
    DBRestClient *restClient;
}



@property (nonatomic, weak) IBOutlet UIButton *messageButton,*mailButton,*gmailButton,*backButton,*bookstoreButton;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;

@property (nonatomic, weak) IBOutlet UIView * infoView;

@property (nonatomic, weak) IBOutlet UILabel * infoLabel;
@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, weak) IBOutlet UIView * overlayView;

@end
