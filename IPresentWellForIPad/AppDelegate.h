//
//  AppDelegate.h
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/20/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KiipSDK/KiipSDK.h>
#import <DBChooser/DBChooser.h>
#import "JASidePanelController.h"
@class JASidePanelController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,KiipDelegate>{
    NSInteger camera_in_practice,i,camera_Blinking;
    NSMutableArray *speecharray;
    NSString *speechText;
    
    //for timer
    NSString *secondsToSleep;
    double secondsToSleepInDouble;
    NSInteger timerCounter;
    DBChooserResult *appResult;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)NSInteger camera_in_practice,i,camera_Blinking;
@property(nonatomic,retain)IBOutlet NSMutableArray *speecharray;
@property(nonatomic,retain)IBOutlet NSString *speechText;

@property (strong, nonatomic) JASidePanelController *viewController;
//for timer
@property(nonatomic,retain)IBOutlet NSString *secondsToSleep;
@property(nonatomic) double secondsToSleepInDouble;
@property(nonatomic) NSInteger timerCounter;
@property (nonatomic, strong) DBChooserResult *appResult;


@property (nonatomic, strong) NSString * userName;
@end
