//
//  DisplayTimerViewController.h
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/24/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayTimerViewController : UIViewController{
    
    //for custom time picker
    IBOutlet UIPickerView *pickerView;
    //NSMutableArray *minsArray;
    NSMutableArray *secsArray;
    
    NSTimeInterval interval;
}

@property (nonatomic, weak) IBOutlet UIButton *backButton,*saveButton;

@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;

@property (nonatomic, weak) IBOutlet UIView * infoView;

@property (nonatomic, weak) IBOutlet UILabel * infoLabel;

@property (nonatomic, weak) IBOutlet UIView * overlayView;

@property (nonatomic, retain) IBOutlet UITextField * timerSecondsTextField;

//for custom time picker
@property(retain, nonatomic) UIPickerView *pickerView;
//@property(retain, nonatomic) NSMutableArray *minsArray;
@property(retain, nonatomic) NSMutableArray *secsArray;
@property(nonatomic) NSTimeInterval interval;

@end
