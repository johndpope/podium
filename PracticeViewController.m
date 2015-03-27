//
//  PracticeViewController.m
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/20/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//
#import "MBProgressHUD.h"
#import "PracticeViewController.h"
#import "AnimatedGif.h"
#import "AppDelegate.h"
#import <DBChooser/DBChooser.h>
#import <Cordova/CDVWebViewDelegate.h>
#import <Cordova/CDVViewController.h>
//For Camera
#import <AVFoundation/AVFoundation.h>

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#import "CaptureSessionManager.h"

#import "SpeechClass.h"

//To Record Video
#import "SVProgressHUD.h"
#import "AVCaptureManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Parse/Parse.h>
#import "Toast.h"
#import "CustomGLView.h"
#import "TrackerWrapper.h"
@interface PracticeViewController ()<AVCaptureManagerDelegate, UIWebViewDelegate>{
    
    //for camera
    BOOL FrontCamera;
    AVCaptureSession *session;
    
    //for timer
    NSTimer *timer;
    
    //To Record Video
    NSTimeInterval startTime;
    BOOL isNeededToSave;
    NSString *resultStr;
    NSURL *fileUrl;
    NSData *fileData;
    UIBarButtonItem *anotherButton;
    UIImagePickerController *imgPickerController;
    UIImage *titleImage;
    NSMutableData *myData;
    NSURLConnection *myConnection;
    CDVWebViewDelegate* _webViewDelegate;
    
    NSString *isworking;
    NSString *setId;
    NSString *questionId;
    NSString *prevQuestionId;
    NSString *isNew;
    NSMutableArray *faceForQuestion;
    NSString *username;
}

//To Record Video
@property (nonatomic, strong) AVCaptureManager *captureManager;
@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, strong) UIImage *recStartImage;
@property (nonatomic, strong) UIImage *recStopImage;
@property (nonatomic, strong) UIImage *outerImage1;
@property (nonatomic, strong) UIImage *outerImage2;
@property (nonatomic, weak) IBOutlet UIButton *recBtn;
@property (nonatomic, weak) IBOutlet UIImageView *outerImageView;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

//End

//@property (retain) CaptureSessionManager *captureManager;

@end

@implementation PracticeViewController

@synthesize animatedImages,backButton,speechText,blackView,resultFrwrd,progressHUD,lookUpImageView;

//for camera
@synthesize imagePreview, captureImage, stillImageOutput,  tracker, resultsDisplayTimer;

NSArray *devices;
AVCaptureDevice *frontCamera,*backCamera;

AppDelegate *app;
SpeechClass *speechObj;
BOOL camera_on;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void) viewWillDisappear:(BOOL)animated   {
    //isNew = @"1";
    [self.tracker stopTracker];
    [super viewWillDisappear:YES];
    
    [resultsDisplayTimer invalidate];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //get video setting
    
    
    username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    isworking = @"0";
    setId = @"";
    questionId = @"";
    prevQuestionId = @"";
    isNew = @"0";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id toggleSwitchValue = [defaults objectForKey:@"camera_on"];
    camera_on = [toggleSwitchValue boolValue];
    
    
    //check timer settings
    id lookup_reminder = [defaults objectForKey:@"lookup_reminder"];
    app.secondsToSleepInDouble = [lookup_reminder integerValue];
    

    if(app.i < 0){
        app.i = 0;
        
        NSString *urlAddress = @"http://www.workexcel.info/frank/ipresentwell/autismSees.html";
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        //add webview with cordova
        UIWebView *myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20,500, 728, 510)];
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"www/autismSees" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        //[myWebView loadHTMLString:htmlString baseURL:nil];
        myWebView.delegate = self;
        [myWebView loadRequest:requestObj];
        [self.view addSubview:myWebView];
        
        
        
        /*CDVViewController* viewController = [CDVViewController new];
        viewController.wwwFolderName = @"www";
        viewController.view.frame = CGRectMake(20, 384, 728, 609);        
        _webViewDelegate = [[CDVWebViewDelegate alloc] initWithDelegate:self];
        viewController.webView.delegate = _webViewDelegate;
        [self.view addSubview:viewController.view];*/

    }
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    if (app.appResult != nil) {
        if (progressHUD == nil)
        {
            progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progressHUD.labelText = @"Importing..";
            
            progressHUD.dimBackground = YES;
        }
        
        resultStr = [app.appResult name];
        
       // NSData *data = [NSData dataWithContentsOfURL:url];
        //[self.restClient loadMetadata:@"/"];
        [self loadFile];
        speechText.hidden = YES;
        _overlayView.hidden = YES;
        
    }
    else{
    speechObj = [app.speecharray objectAtIndex:app.i];

    if (speechObj.speechText == nil) {
    if (app.appResult != nil) {
        if (progressHUD == nil)
        {
            progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progressHUD.labelText = @"Importing..";
            
            progressHUD.dimBackground = YES;
        }

        resultStr = [app.appResult name];
        [self.restClient loadMetadata:@"/"];
        speechText.hidden = YES;
       _overlayView.hidden = YES;
    }
    else
    {
        speechText.hidden = YES;
        _overlayView.hidden = YES;
        speechObj =[app.speecharray objectAtIndex:app.i];
        //speechText.text = speechObj.speechTitle;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //Create PDF_Documents directory
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"/Photo Application/"];
        documentsDirectory = [documentsDirectory stringByAppendingString:speechObj.speechTitle];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory];
        if (fileExists) {
            fileUrl = [NSURL fileURLWithPath: documentsDirectory];
            
            QLPreviewController *previewController = [[QLPreviewController alloc] init];
            [previewController setDataSource:self];
            previewController.delegate = self;
            [self addChildViewController:previewController];
            CGFloat w= 728;
            CGFloat h= speechText.frame.size.height;
            previewController.view.frame = CGRectMake(20, 333,w, h);
            [self.view addSubview:previewController.view];
            [previewController didMoveToParentViewController:self];
            // Which item to preview
            // [previewController setCurrentPreviewItemIndex:indexPath.row];
            
            // Push new viewcontroller, previewing the document
            //[[self navigationController] pushViewController:previewController animated:YES];
            [self.view addSubview:previewController.view];
            [self.view bringSubviewToFront:previewController.view];

        }
        else
        {
            NSString *path = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
            
            sqlite3_stmt *compiledStmt;
            sqlite3 *db;
            
            
            if(sqlite3_open([path UTF8String], &db)==SQLITE_OK)
            {
                NSString *insertSQL = [NSString stringWithFormat:@"Select speech_file from speech Where Id = %ld",(long)app.i];
                if(sqlite3_prepare_v2(database,[insertSQL cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStmt, NULL) == SQLITE_OK)
                {
                    while(sqlite3_step(compiledStmt) == SQLITE_ROW) {
                        
                        int length = sqlite3_column_bytes(compiledStmt, 0);
                        NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(compiledStmt, 0) length:length];
                        
                        NSLog(@"Length : %lu", (unsigned long)[imageData length]);
                        
                        if(imageData == nil)
                            NSLog(@"No image found.");
                        else
                           [imageData writeToFile:documentsDirectory atomically:YES];
                    }
                }
                sqlite3_finalize(compiledStmt);
            }
            sqlite3_close(db);
            
            fileUrl = [NSURL fileURLWithPath:documentsDirectory];
            
            QLPreviewController *previewController = [[QLPreviewController alloc] init];
            [previewController setDataSource:self];
            previewController.delegate = self;
            [self addChildViewController:previewController];
            CGFloat w= 728;
            CGFloat h= speechText.frame.size.height;
            previewController.view.frame = CGRectMake(20, 333,w, h);
            [self.view addSubview:previewController.view];
            [previewController didMoveToParentViewController:self];
            // Which item to preview
            // [previewController setCurrentPreviewItemIndex:indexPath.row];
            
            // Push new viewcontroller, previewing the document
            //[[self navigationController] pushViewController:previewController animated:YES];
            [self.view addSubview:previewController.view];
            [self.view bringSubviewToFront:previewController.view];

        }
      
        

    }
   
        
    }
}
    speechText.text = speechObj.speechText;
    
  #pragma mark --------------- speech selection override to show goodwill questions list ------------------------- 
    ////this had been put in to manually override and show hardcoded question list.
//    if ([speechObj.speechID  isEqual: @"1"]) {
//        _overlayView.hidden = NO;
//        [self addQButtons];
//    }

   // UIColor* darkColor = [UIColor colorWithRed:0/255 green:173.0/255 blue:239.0/255 alpha:1.0f];
    NSString* boldFontName = @"Avenir-Black";
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    self.infoLabel.text = @"";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
//    self.backButton.backgroundColor = darkColor;
//    self.backButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
//    [self.backButton setTitle:@"BACK" forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    app= (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    
    //if(app.camera_in_practice == 0){
    //if(app.camera_Blinking == 0){
    if(!camera_on){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 768, 226)];
        view.backgroundColor = [UIColor whiteColor];
        NSURL* firstUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"blinking_eyes" ofType:@"gif"]];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"titleImage"]) {
            NSData *imgData = [[NSUserDefaults standardUserDefaults]objectForKey:@"titleImage"];
            captureImage.image = [UIImage imageWithData:imgData];
           // captureImage.contentMode = UIViewContentModeScaleAspectFit;
            //captureImage.frame = CGRectMake(30, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width - 60, 100);
            captureImage.frame = CGRectMake(0, 0, 768, 226);
        }
        else
        {
        captureImage = [AnimatedGif getAnimationForGifAtUrl: firstUrl];
            //captureImage.image = [UIImage imageNamed:@"blinking_eyes.gif"];
        captureImage.frame = CGRectMake(47, 0, 768, 226);
        
        }
       
      //  captureImage.frame = CGRectMake(30, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width - 60, 100);
        [view addSubview:captureImage];
        [self.view addSubview:view];
        [self.view bringSubviewToFront:view];
    }
    else
    {
        //added back change picture button  -- change 001
        anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Picture" style:UIBarButtonItemStylePlain target:self action:@selector(changePicTapped:)];
        self.navigationItem.rightBarButtonItem = anotherButton;
//        //set right navmenu button to start recording  -- change 001
//        anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Record" style:UIBarButtonItemStylePlain target:self action:@selector(recButtonTapped:)];
//        anotherButton.tintColor = [UIColor greenColor];
//        self.navigationItem.rightBarButtonItem = anotherButton;
        
        
        
        //[self initializeCamera];
        self.tracker = [[TrackerWrapper alloc] init];
        [self.tracker initTracker:imagePreview];
        resultsDisplayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/5
                                                               target:self
                                                             selector:@selector(showResults:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.tracker startTrackingFromCam];
        //To Record Video
        //self.captureManager = [[AVCaptureManager alloc] initWithPreviewView:self.imagePreview];
        //self.captureManager.delegate = self;
        
        
        // Setup images for the Shutter Button
        UIImage *image;
        image = [UIImage imageNamed:@"ShutterButtonStart"];
        self.recStartImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.recBtn setImage:self.recStartImage
                     forState:UIControlStateNormal];
        
        image = [UIImage imageNamed:@"ShutterButtonStop"];
        self.recStopImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [self.recBtn setTintColor:[UIColor colorWithRed:245./255.
                                                  green:51./255.
                                                   blue:51./255.
                                                  alpha:1.0]];
        self.outerImage1 = [UIImage imageNamed:@"outer1"];
        self.outerImage2 = [UIImage imageNamed:@"outer2"];
        self.outerImageView.image = self.outerImage1;
    }
    
    ////turned this off.  camera_in_practice seems to be an older duplicate of camera_blinking
//    if (app.camera_in_practice == 1) {
//        
//        self.captureManager = [[AVCaptureManager alloc] initWithPreviewView:self.imagePreview];
//        self.captureManager.delegate = self;
//
//    }else{
//        
//        anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Picture" style:UIBarButtonItemStylePlain target:self action:@selector(changePicTapped:)];
//       // anotherButton.tintColor = [UIColor greenColor];
//        self.navigationItem.rightBarButtonItem = anotherButton;
//    }
    
    
    captureImage.backgroundColor = [UIColor whiteColor];
    app.timerCounter = 0;
    
    if(app.secondsToSleepInDouble>0){
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showBlackView) userInfo:nil repeats:YES];
    }
}

//-(void)viewWillAppear:(BOOL)animated{
//    if(app.secondsToSleepInDouble>0){
//        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showBlackView) userInfo:nil repeats:YES];
//    }
//}


-(void)addQButtons{
    
    
    _q1Btn.layer.cornerRadius = 5.0f;
    
    _q2Btn.layer.cornerRadius = 5.0f;
   
    _q3Btn.layer.cornerRadius = 5.0f;
    
    _q4Btn.layer.cornerRadius = 5.0f;
    
    _q5Btn.layer.cornerRadius = 5.0f;
   
    _q6Btn.layer.cornerRadius = 5.0f;
    
    _q7Btn.layer.cornerRadius = 5.0f;
    
    _q8Btn.layer.cornerRadius = 5.0f;
   
    _q9Btn.layer.cornerRadius = 5.0f;
    
    _q10Btn.layer.cornerRadius = 5.0f;
    
    _q11Btn.layer.cornerRadius = 5.0f;
   
    
    
}

-(void)showBlackView{
    
    app.timerCounter++;
    NSLog(@"app.timerCounter : %ld" , (long)app.timerCounter);
    
    int secondsToSleepInInt = (int)app.secondsToSleepInDouble;
    
    if((app.timerCounter % secondsToSleepInInt) == 0){
        blackView.hidden = NO;
        lookUpImageView.hidden = NO;
        [self.view bringSubviewToFront:blackView];
    }else{
        blackView.hidden = YES;
        lookUpImageView.hidden = YES;
    }
}

- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView
{
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect rect = [textView firstRectForRange:textRange];
    return [textView convertRect:rect fromView:textView.textInputView];
}

-(void)hideBlackView{
    
    blackView.hidden = YES;
    lookUpImageView.hidden = YES;
    
}

-(IBAction)hideBtn:(id)sender{
    
    UIButton *btn = (UIButton*)[_overlayView viewWithTag:[sender tag]];
    btn.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)redirectBackToMenuPage:(id)sender{
    
    //stopping timer
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"MenuViewController" bundle:nil];
    UIViewController *vc = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)redirectBackToSelectSpeechPage:(id)sender{
    
    //stopping timer
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    UIStoryboard *SelectSpeechViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];
    UIViewController *vc = [SelectSpeechViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

//To Record Video
-(IBAction)recordAndPlay:(id)sender{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
    // 1 - Validattions
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    // 3 - Display image picker
    //[controller presentModalViewController: cameraUI animated: YES ];
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    //[self dismissModalViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath =[NSString stringWithFormat:@"%@",[[info objectForKey:UIImagePickerControllerMediaURL] path]];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self,
                                                @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    else{
        NSLog(@"img");
        
        titleImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        //imageView.image = image;
        if (titleImage != nil) {
            ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:titleImage];
            controller.delegate = self;
            [[self navigationController] pushViewController:controller animated:YES];

        }
        
    }
}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


//To Record Video 2
#pragma mark - Private


- (void)saveRecordedFile:(NSURL *)recordedFile {
    
    [SVProgressHUD showWithStatus:@"Saving..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary writeVideoAtPathToSavedPhotosAlbum:recordedFile
                                         completionBlock:
         ^(NSURL *assetURL, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [SVProgressHUD dismiss];
                 
                 NSString *title;
                 NSString *message;
                 
                 if (error != nil) {
                     
                     title = @"Uh Oh! We encountered an error trying to save video. Please try again.";
                     message = [error localizedDescription];
                 }
                 else {
                     title = @"Recording has been saved to your Saved Videos folder in this app!";
                     message = nil;
                 }
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                 message:message
                                                                delegate:nil
                                                       cancelButtonTitle:@"Close"
                                                       otherButtonTitles:nil];
                 [alert show];
             });
         }];
    });
}

#pragma mark - AVCaptureManagerDeleagte

- (void)didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL error:(NSError *)error {
    
    if (error) {
        NSLog(@"error:%@", error);
        return;
    }
    
    if (!isNeededToSave) {
        return;
    }
    
    [self saveRecordedFile:outputFileURL];
}

#pragma mark - IBAction

- (IBAction)recButtonTapped:(id)sender {
    
    // REC START
    if (!self.captureManager.isRecording) {
        
        // change UI
        [self.recBtn setImage:self.recStopImage
                     forState:UIControlStateNormal];
        
//        //change right navmenu button to duplication stop button -- change 001
//        anotherButton.title = @"Stop";
//        anotherButton.tintColor = [UIColor redColor];
        
        [self.captureManager startRecording];
    }
    // REC STOP
    else {
//        //change right navmenu button to duplication record button -- change 001
//        anotherButton.title = @"Record";
//        anotherButton.tintColor = [UIColor greenColor];
        
        
        isNeededToSave = YES;
        [self.captureManager stopRecording];
        
        // change UI
        [self.recBtn setImage:self.recStartImage
                     forState:UIControlStateNormal];
    }
}


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    
    if (metadata.isDirectory) {
        
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSString *str = [NSString stringWithFormat:@"%@",file.filename];
            if ([str isEqualToString:resultStr]) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
               
                //Create PDF_Documents directory
                documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"/Photo Application/"];
                
                
                [self.restClient loadFile:file.path intoPath:[documentsDirectory stringByAppendingString:file.filename]];
                
                
                fileUrl = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingString:file.filename]];
                
            }
            
            else
            {
                NSLog(@"%@",file.contents);
                if (file.isDirectory) {
                    //[[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please place the file outside the folder and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                    
                    
                    /*
                    for (DBMetadata *file in file.contents) {
                        NSString *str = [NSString stringWithFormat:@"%@",file.filename];
                        if ([str isEqualToString:resultStr]) {
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString *documentsDirectory = [paths objectAtIndex:0];
                                                        //Create PDF_Documents directory
                            documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"/Photo Application/"];
                            
                            [self.restClient loadFile:file.path intoPath:[documentsDirectory stringByAppendingString:file.filename]];
                            fileUrl = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingString:file.filename]];
                        }
                     
                    }
                    */
                }
                else
                {
                    //return;
                    if ([str isEqualToString:resultStr]) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    
                    //Create PDF_Documents directory
                    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"/Photo Application/"];
                    
                   // NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"test.pdf"];
                   // [self.restClient loadFile:file.path intoPath:[documentsDirectory  stringByAppendingString:file.filename]];
                    
                    QLPreviewController *previewController = [[QLPreviewController alloc] init];
                    [previewController setDataSource:self];
                    previewController.delegate = self;
                    [self addChildViewController:previewController];
                    CGFloat w= 728;
                    CGFloat h= speechText.frame.size.height;
                    previewController.view.frame = CGRectMake(20, 333,w, h);
                    [self.view addSubview:previewController.view];
                    [previewController didMoveToParentViewController:self];
                    // Which item to preview
                    // [previewController setCurrentPreviewItemIndex:indexPath.row];
                    
                    // Push new viewcontroller, previewing the document
                    //[[self navigationController] pushViewController:previewController animated:YES];
                    [self.view addSubview:previewController.view];
                    [self.view bringSubviewToFront:previewController.view];
                    }
                }
                
            }
            NSLog(@"	%@", file.filename);
        }
    }
}


-(void)loadFile{
    
    fileUrl = [app.appResult link];
   // NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    NSURL *myUrl = [app.appResult link];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    myData = [[NSMutableData alloc] initWithLength:0];
    myConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self startImmediately:YES];

}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [myData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [myData appendData:data];
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[connection release];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[connection release];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //Create PDF_Documents directory
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"/Photo Application/"];
    
    
    // [self.restClient loadFile:file.path intoPath:[documentsDirectory stringByAppendingString:file.filename]];
    
    
    fileUrl = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingString:resultStr]];
    [myData writeToFile:[documentsDirectory stringByAppendingString:resultStr] atomically:YES];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/YY"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    //Insert record in to database
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
    /*if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
     {
     
     NSString *querySQL = [NSString stringWithFormat:@"insert into Speech (speech_file,speech_date,speech_title) Values (?,'%@','%@')",stringWithoutSpaces,dateString,title];
     const char *sql = [querySQL UTF8String];
     sqlite3_stmt *searchStatement;
     
     if (sqlite3_prepare_v2(database, sql, -1, &searchStatement, NULL) == SQLITE_OK)
     {
     while (sqlite3_step(searchStatement) == SQLITE_ROW)
     {
     
     }
     }
     sqlite3_finalize(searchStatement);
     }*/
    
    sqlite3_stmt *compiledStmt;
    sqlite3_close(database);
    if(sqlite3_open([path UTF8String], &database)==SQLITE_OK){
        NSString *insertSQL=[NSString stringWithFormat:@"insert into Speech (speech_file,speech_date,speech_title) Values (?,'%@','%@')",dateString,resultStr];
        if(sqlite3_prepare_v2(database,[insertSQL cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            //UIImage *image = [UIImage imageNamed:@"vegextra.png"];
            // NSData *fileData=[NSData dataWithContentsOfFile:localPath];
            
            sqlite3_bind_blob(compiledStmt, 1, [myData bytes], (int)[myData length], SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStmt) != SQLITE_DONE ) {
                NSLog( @"Error: %s", sqlite3_errmsg(database) );
            } else {
                NSLog( @"Insert into row id = %lld",  (sqlite3_last_insert_rowid(database)));
            }
            
            sqlite3_finalize(compiledStmt);
        }
    }
    sqlite3_close(database);
    
    Toast *mToast = [Toast toastWithMessage:@"Your speech has been saved successfully"];
    [mToast showOnView:self.view];
    
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    [previewController setDataSource:self];
    previewController.delegate = self;
    [self addChildViewController:previewController];
    CGFloat w= 728;
    CGFloat h= speechText.frame.size.height;
    previewController.view.frame = CGRectMake(20, 333,w, h);
    [self.view addSubview:previewController.view];
    [previewController didMoveToParentViewController:self];
    // Which item to preview
    // [previewController setCurrentPreviewItemIndex:indexPath.row];
    
    // Push new viewcontroller, previewing the document
    //[[self navigationController] pushViewController:previewController animated:YES];
    [self.view addSubview:previewController.view];
    [self.view bringSubviewToFront:previewController.view];
    

    
    //download finished - data is available in myData.
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
    [self hideProgressHUD];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    
    NSLog(@"File loaded into path: %@", localPath);
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/YY"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    //Insert record in to database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"IPresentWell.sqlite"];
    /*if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"insert into Speech (speech_file,speech_date,speech_title) Values (?,'%@','%@')",stringWithoutSpaces,dateString,title];
        const char *sql = [querySQL UTF8String];
        sqlite3_stmt *searchStatement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStatement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStatement) == SQLITE_ROW)
            {
                
            }
        }
        sqlite3_finalize(searchStatement);
    }*/
    sqlite3_stmt *compiledStmt;
    sqlite3_close(database);
    if(sqlite3_open([path UTF8String], &database)==SQLITE_OK){
        NSString *insertSQL=[NSString stringWithFormat:@"insert into Speech (speech_file,speech_date,speech_title) Values (?,'%@','%@')",dateString,[app.appResult name]];
        if(sqlite3_prepare_v2(database,[insertSQL cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            //UIImage *image = [UIImage imageNamed:@"vegextra.png"];
            NSData *fileData=[NSData dataWithContentsOfFile:localPath];
            
            sqlite3_bind_blob(compiledStmt, 1, [fileData bytes], [fileData length], SQLITE_TRANSIENT);
            
            if(sqlite3_step(compiledStmt) != SQLITE_DONE ) {
                NSLog( @"Error: %s", sqlite3_errmsg(database) );
            } else {
                NSLog( @"Insert into row id = %lld",  (sqlite3_last_insert_rowid(database)));
            }
            
            sqlite3_finalize(compiledStmt);
        }
    }
    sqlite3_close(database);
    
    Toast *mToast = [Toast toastWithMessage:@"Your speech has been saved successfully"];
    [mToast showOnView:self.view];
    

    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    [previewController setDataSource:self];
    previewController.delegate = self;
    [self addChildViewController:previewController];
    CGFloat w= 728;
    CGFloat h= 470;
    previewController.view.frame = CGRectMake(20, 333,w, h);
    [self.view addSubview:previewController.view];
    [previewController didMoveToParentViewController:self];
    // Which item to preview
    // [previewController setCurrentPreviewItemIndex:indexPath.row];
    
    // Push new viewcontroller, previewing the document
    //[[self navigationController] pushViewController:previewController animated:YES];
    [self.view addSubview:previewController.view];
    [self.view bringSubviewToFront:previewController.view];

}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    
    NSLog(@"There was an error loading the file: %@", error);
    
    [self hideProgressHUD];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];

}


#pragma mark QLPreviewControllerDataSource

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    // Break the path into its components (filename and extension)
   // NSArray *fileComponents = [[arrayOfDocuments objectAtIndex: index] componentsSeparatedByString:@"."];
    
    // Use the filename (index 0) and the extension (index 1) to get path
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"About Xcode" ofType:@"pdf"];
    //fileUrl = [app.appResult link];
    app.appResult = nil;
    [self hideProgressHUD];
    
        return fileUrl;
    
}



- (void)hideProgressHUD
{
    if (progressHUD)
    {
        [progressHUD hide:YES];
        [progressHUD removeFromSuperview];
        progressHUD = nil;
    }
}

-(IBAction)changePicTapped:(id)sender{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Close" otherButtonTitles:@"Camera", @"Photo Library",@"Default Image", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    //[actionSheet showFromBarButtonItem:moreTools animated:YES];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    

    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        NSLog(@"ok One");
        resultsDisplayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/5
                                                               target:self
                                                             selector:@selector(showResults:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.tracker startTrackingFromCam];
        [captureImage removeFromSuperview];
        captureImage = nil;
        //[self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    if (buttonIndex == 1) {
        
        imgPickerController = [[UIImagePickerController alloc] init];
        imgPickerController.delegate = self;
        imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //[self presentModalViewController:picker animated:YES];
        [self presentViewController:imgPickerController animated:YES completion:nil];
        //[self.tracker stopTracker];
        //[resultsDisplayTimer invalidate];
        //resultsDisplayTimer = nil;
        
        
    }
    if (buttonIndex == 2) {
        
        imgPickerController = [[UIImagePickerController alloc] init];
        imgPickerController.delegate = self;
        imgPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //[self presentModalViewController:picker animated:YES];
        [self presentViewController:imgPickerController animated:YES completion:nil];
        //[self.tracker stopTracker];
        //[resultsDisplayTimer invalidate];
        //resultsDisplayTimer = nil;
        
        
    }
    if (buttonIndex == 3) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"titleImage"];
        
        NSURL* firstUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"blinking_eyes" ofType:@"gif"]];
        [captureImage removeFromSuperview];
        captureImage = nil;
        captureImage = [UIImageView new];
        //captureImage.image = [UIImage imageNamed:@"blinking_eyes.gif"];
       
        captureImage = [AnimatedGif getAnimationForGifAtUrl: firstUrl];
         captureImage.frame = CGRectMake(0, 64, 768, 270);
        [self.view addSubview:captureImage];
        
        [self.tracker stopTracker];
        [resultsDisplayTimer invalidate];
        resultsDisplayTimer = nil;
        
    }
    
    
}

#pragma mark --------------- Crop Image Delegate -------------------------

- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    titleImage = croppedImage;
    [[NSUserDefaults standardUserDefaults]setObject:UIImagePNGRepresentation(titleImage) forKey:@"titleImage"];
   
   // imageView.image = croppedImage;
    [[self navigationController] popViewControllerAnimated:YES];
    [captureImage removeFromSuperview];
    captureImage = nil;
    captureImage = [UIImageView new];
    captureImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68, 768, 258)];
    captureImage.image = titleImage;
    captureImage.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:captureImage];

    
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    //imageView.image = image;
    [[self navigationController] popViewControllerAnimated:YES];
    //captureImage = nil;
   
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSArray *requestArray = [requestString componentsSeparatedByString:@"js2ios=1&"];
    
    if ([requestArray count] > 1){
       [self webviewMessageKey:requestArray[1]];
        return NO;
    }
    else if (navigationType == UIWebViewNavigationTypeLinkClicked && [self shouldOpenLinksExternally]) {
        // open links in safari
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}


- (void)webviewMessageKey:(NSString *)str {
    NSArray *requestArray = [str componentsSeparatedByString:@"&"];
    NSArray *requestArray1 = [requestArray[0] componentsSeparatedByString:@"="];
    NSArray *requestArray2 = [requestArray[1] componentsSeparatedByString:@"="];
    NSArray *requestArray3 = [requestArray[2] componentsSeparatedByString:@"="];
    isworking = requestArray1[1];
    setId = requestArray2[1];
    if(![questionId isEqualToString:requestArray3[1]]){
        isNew = @"1";
        prevQuestionId = questionId;
    }
    questionId = requestArray3[1];
    
}
-(void)showResults:(NSTimer *)timer {
    NSData *faceInMoment = [self.tracker displayTrackingResults:nil Status:nil Info:nil];
    if([isNew isEqualToString:@"1"]){
        
       if(![prevQuestionId isEqualToString:@""]){
           //username, setId, prevQuestionId, faceForQuestion
           NSString *tempUserName = username;
           NSString *tempSetId = setId;
           NSString *tempPrevQuestionId = prevQuestionId;
           NSMutableArray *tempQuestion = [[NSMutableArray alloc] init];
           for (int i = 0; i<[faceForQuestion count]-1; i++) {
               [tempQuestion addObject:[faceForQuestion objectAtIndex:i]];
           }
           
           PFObject *tableData = [PFObject objectWithClassName:@"FaceData"];
           tableData[@"username"] = tempUserName;
           tableData[@"setId"] = tempSetId;
           tableData[@"questionId"] = tempPrevQuestionId;
           tableData[@"faceQuestion"] = tempQuestion;
           [tableData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               if (succeeded) {
                   NSLog(@"success");
               }
               else
                   NSLog(@"failed");
           }];
        // Sending copy of faceForQuestion to server which should be worked in thread.           
       }
            
       faceForQuestion = nil;
       faceForQuestion = [[NSMutableArray alloc] init];
       isNew = @"0";
    }
    
    if([isworking isEqualToString:@"1"]){
        if(faceInMoment!=nil){
            [faceForQuestion addObject:faceInMoment];
        }
    }else{
        prevQuestionId=@"";
        questionId=@"";
    }
    
}
- (BOOL)shouldOpenLinksExternally {
    return YES;
}
@end
