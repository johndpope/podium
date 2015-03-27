//
//  CaptureSessionManager.m
//  InstaSelfie
//
//  Created by netGALAXY Studios on 1/31/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "CaptureSessionManager.h"

@implementation CaptureSessionManager

-(void)toggleCamera:(BOOL)front
{
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
     //   NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
           //     NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
           //     NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    [[self captureSession] beginConfiguration];
    NSError *error = nil;
    // AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    // AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    if (front)
    {
        [[self captureSession] removeInput:backFacingCameraDeviceInput];
        if (!error) {
            
            //  frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
            if ([[self captureSession] canAddInput:frontFacingCameraDeviceInput]) {
                [[self captureSession] addInput:frontFacingCameraDeviceInput];
            } else {
         //       NSLog(@"Couldn't add front facing video input");
            }
            
        }
    } else
    {
        [[self captureSession] removeInput:frontFacingCameraDeviceInput];
        if (!error) {
            // backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
            
            if ([[self captureSession] canAddInput:backFacingCameraDeviceInput]) {
                [[self captureSession] addInput:backFacingCameraDeviceInput];
            } else {
          //      NSLog(@"Couldn't add back facing video input");
            }
            
        }
    }
    
    [[self captureSession] commitConfiguration];
}
    
@end
