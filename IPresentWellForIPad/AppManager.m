//
//  AppManager.m
//  IPresentWell
//
//  Created by Frank Bakker on 3/21/15.
//  Copyright (c) 2015 netGALAXY Studios. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

static AppManager *appManager = nil;

+ (AppManager*) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appManager = [[AppManager alloc] init];
        
        appManager.userName = @"Test";
        appManager.userId = [NSNumber numberWithInt:1];
    });
    
    return appManager;
}

@end
