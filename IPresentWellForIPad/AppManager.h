//
//  AppManager.h
//  IPresentWell
//
//  Created by Frank Bakker on 3/21/15.
//  Copyright (c) 2015 netGALAXY Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSNumber *userId;

+ (AppManager*) sharedInstance;

@end
