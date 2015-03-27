//
//  CaptureSessionManager.h
//  InstaSelfie
//
//  Created by netGALAXY Studios on 1/31/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CaptureSessionManager : NSObject{
    AVCaptureDeviceInput *frontFacingCameraDeviceInput;
    AVCaptureDeviceInput *backFacingCameraDeviceInput;
}

@property (nonatomic, strong) AVCaptureSession *captureSession;

-(void)toggleCamera:(BOOL)front;

@end
