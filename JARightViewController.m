/*
 Copyright (c) 2012 Jesse Andersen. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 If you happen to meet one of the copyright holders in a bar you are obligated
 to buy them one pint of beer.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */


#import "JARightViewController.h"
#import "JASidePanelController.h"
#import "SettingViewController.h"
#import "UIViewController+JASidePanel.h"

@interface JARightViewController ()

@end

@implementation JARightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = CGRectMake(360.0f, 70.0f, 171.0f, 171.0f);
//    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
//    [button setBackgroundImage:[UIImage imageNamed:@"settingsButton.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(settingTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//
	self.view.backgroundColor = [UIColor grayColor];
    
}
- (void)settingTapped:(id)sender {
   
    
}

- (void)viewWillAppear:(BOOL)animated {
//    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SettingViewController" bundle:nil];
//    UIViewController *SettingView = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
//	self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:SettingView];
//    //[self.view addSubview:SettingView.view];
//    [super viewWillAppear:animated];
   
}

@end
