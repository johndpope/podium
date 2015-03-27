//
//  PracticeViewController.h
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/20/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ImageCropView.h"
//To Record Video
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <DBChooser/DBChooser.h>
#import <DropboxSDK/DropboxSDK.h>
#import <QuickLook/QuickLook.h>
#import <sqlite3.h>
@class CustomGLView;
@class TrackerWrapper;

sqlite3	*database;

@interface PracticeViewController : UIViewController<DBRestClientDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageCropViewControllerDelegate>
{
    DBRestClient *restClient;
    /**
     * View for displaying tracking results frame and 3D face wireframe
     *
     */
    CustomGLView *imagePreview;
    
    /**
     * Wrapper class around C++ calls controlling the tracker.
     *
     */
    TrackerWrapper *tracker;
    /**
     * Timer for periodically refreshing of the results display.
     *
     */
    NSTimer *resultsDisplayTimer;

}

@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIImageView *animatedImages;
@property (nonatomic, weak) IBOutlet UIView *infoView;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UITextView *speechText;

//for camera
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) IBOutlet CustomGLView *imagePreview;
@property (nonatomic, retain) TrackerWrapper *tracker;
@property (nonatomic, retain) NSTimer *resultsDisplayTimer;
@property (strong, nonatomic) IBOutlet UIImageView *captureImage;


@property (strong, nonatomic) DBChooserResult *resultFrwrd;
//for timer
@property (nonatomic, weak) IBOutlet UIView * blackView;
@property (nonatomic, strong) DBRestClient *restClient;
@property (strong, nonatomic) IBOutlet UIView *lookUpImageView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIButton *q1Btn;
@property (strong, nonatomic) IBOutlet UIButton *q2Btn;
@property (strong, nonatomic) IBOutlet UIButton *q3Btn;
@property (strong, nonatomic) IBOutlet UIButton *q4Btn;
@property (strong, nonatomic) IBOutlet UIButton *q5Btn;
@property (strong, nonatomic) IBOutlet UIButton *q6Btn;
@property (strong, nonatomic) IBOutlet UIButton *q7Btn;
@property (strong, nonatomic) IBOutlet UIButton *q8Btn;
@property (strong, nonatomic) IBOutlet UIButton *q9Btn;
@property (strong, nonatomic) IBOutlet UIButton *q10Btn;
@property (strong, nonatomic) IBOutlet UIButton *q11Btn;


-(IBAction)hideBtn:(id)sender;

//To Record Video
-(IBAction)recordAndPlay:(id)sender;
-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate;
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;

@end
