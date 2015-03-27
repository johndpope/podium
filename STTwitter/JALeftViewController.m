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


#import "JALeftViewController.h"
#import "JASidePanelController.h"
#import "SelectSpeechViewController.h"
#import "UIViewController+JASidePanel.h"
#import "MenuViewController.h"
#import "WriteTextViewController.h"
#import "ImportTextViewController.h"
//#import "JARightViewController.h"
//#import "JACenterViewController.h"
#import "videoViewController.h"

@interface JALeftViewController ()

@property (nonatomic, weak) UILabel  *label;
@property (nonatomic, weak) UIButton *hide;
@property (nonatomic, weak) UIButton *show;
@property (nonatomic, weak) UIButton *removeRightPanel;
@property (nonatomic, weak) UIButton *addRightPanel;
@property (nonatomic, weak) UIButton *changeCenterPanel;
@property (nonatomic, retain) NSArray  *menuArray;

@end

@implementation JALeftViewController
@synthesize menuTableView,menuArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor lightGrayColor];
	menuArray = [[NSArray alloc]initWithObjects:@"Practice",@"Write",@"Import From Dropbox",@"Saved Videos", nil];
    menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, self.view.frame.size.height-420)];
    menuTableView.backgroundColor = [UIColor blackColor];
    menuTableView.scrollEnabled = NO;
    menuTableView.dataSource = self;
    menuTableView.delegate   = self;
    [self.view addSubview:menuTableView];
    
    self.view.opaque = NO;
    

	UILabel *label  = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
	label.text = @"Menu";
	[label sizeToFit];
	label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    //[self.view addSubview:label];
   // self.label = label;
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(220.0f,422.0f, 171.0f, 171.0f);
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [button setBackgroundImage:[UIImage imageNamed:@"practiceButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(practiceTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(220.0f,70.0f , 171.0f, 171.0f);
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [button setBackgroundImage:[UIImage imageNamed:@"writeButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(writeTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //self.show = button;
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(220.0f,246.0f, 171.0f, 171.0f);
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [button setBackgroundImage:[UIImage imageNamed:@"importButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(importTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
  //  self.removeRightPanel = button;
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(220.0f,600.0f, 171.0f, 171.0f);
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [button setBackgroundImage:[UIImage imageNamed:@"videoButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_addRightPanelTapped:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:button];
  //self.addRightPanel = button;
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 170.0f, 200.0f, 40.0f);
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
   // [button setTitle:@"Change Center Panel" forState:UIControlStateNormal];
   // [button addTarget:self action:@selector(_changeCenterPanelTapped:) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addSubview:button];
   // self.changeCenterPanel = button;
     */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.label.center = CGPointMake(floorf(self.sidePanelController.leftVisibleWidth/2.0f), 25.0f);
}


#pragma UITableViewDelegate & UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text =[menuArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:30.0];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mic.png"];
    }
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"write.png"];
    }
    if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"dropbox.png"];
    }
    if (indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"video.png"];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];
        UIViewController *SelectSpeech = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:SelectSpeech];
        

    }
    if (indexPath.row == 1) {
        UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"WriteTextViewController" bundle:nil];
        UIViewController *WriteTextView = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"WriteTextViewController"];
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:WriteTextView];
    }
    if (indexPath.row == 2) {
        UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"ImportTextViewController" bundle:nil];
        UIViewController *ImportTextView = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"ImportTextViewController"];
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:ImportTextView];

    }
    if (indexPath.row == 3) {
        UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"videoViewController" bundle:nil];
        UIViewController *ImportTextView = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"videoViewController"];
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:ImportTextView];
    }

}


#pragma mark - Button Actions


- (void)practiceTapped:(id)sender {
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"SelectSpeechViewController" bundle:nil];
    UIViewController *SelectSpeech = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"SelectSpeechViewController"];
	self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:SelectSpeech];

}

- (void)writeTapped:(id)sender {
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"WriteTextViewController" bundle:nil];
    UIViewController *WriteTextView = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"WriteTextViewController"];
	self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:WriteTextView];

}

- (void)importTapped:(id)sender {
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"ImportTextViewController" bundle:nil];
    UIViewController *ImportTextView = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"ImportTextViewController"];
	self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:ImportTextView];
}

- (void)_removeRightPanelTapped:(id)sender {
    self.sidePanelController.rightPanel = nil;
    self.removeRightPanel.hidden = YES;
    self.addRightPanel.hidden = NO;
}

- (void)_addRightPanelTapped:(id)sender {
    UIStoryboard *menuViewControllerStoryboard = [UIStoryboard storyboardWithName:@"videoViewController" bundle:nil];
    UIViewController *ImportTextView = [menuViewControllerStoryboard instantiateViewControllerWithIdentifier:@"videoViewController"];
	self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:ImportTextView];

}

- (void)_changeCenterPanelTapped:(id)sender {
   }

@end
