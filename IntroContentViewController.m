//
//  IntroContentViewController.m
//  IPresentWell
//
//  Created by walter zesk on 8/18/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "IntroContentViewController.h"

@interface IntroContentViewController ()

@end

@implementation IntroContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    
}
- (IBAction)ExitWalkthrough:(id)sender {
    NSLog(@"exiting");
//    [self.parentViewController dismissViewControllerAnimated:NO completion:^{
//        NSLog(@"exiting");
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
