//
//  videoViewController.m
//  IPresentWell
//
//  Created by Ambika on 4/17/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "videoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "videoCell.h"
#import "PhotoCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>

@interface videoViewController ()

{
    NSMutableArray *allVideos;
    NSMutableDictionary *dic;
    MPMoviePlayerController *movie;
    BOOL shareEnabled;
    NSMutableArray *selectedVideos;
    UIBarButtonItem *shareButton;
}
@end

@implementation videoViewController

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
    selectedVideos = [NSMutableArray new];
    shareEnabled = NO;
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(selectButtonClicked:)];
    shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    shareButton.enabled = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.navigationItem.rightBarButtonItems = @[shareButton,settingsButton,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item,item];
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    // 1
    ALAssetsLibrary *assetsLibrary = [videoViewController defaultAssetsLibrary];
    // 2
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
       
        if (group) {
        
        
        [group setAssetsFilter:[ALAssetsFilter allVideos]];
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if(result)
            {
                
                
                
                // 3
                [tmpAssets addObject:result];
            }
        
         
        }];
        }
        // 4
        //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        //self.assets = [tmpAssets sortedArrayUsingDescriptors:@[sort]];
        self.assets = tmpAssets;
        if ([self.assets count] == 0 ) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No videos available at the moment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            
        }
        // 5
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];

    
   
}



+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   // return allVideos.count;
    return self.assets.count;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PhotoCell";
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    ALAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    cell.backgroundColor = [UIColor whiteColor];
    for(UIView *view in cell.photoImageView.subviews){
        if([view isMemberOfClass:[UIButton class]]){
            [(UIButton *)view removeFromSuperview];
        }
    }
    if (shareEnabled) {
         cell.selectedBackgroundView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"running.png"]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(120, 80, 35, 35)];
        [btn setImage:[UIImage imageNamed:@"deselect.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = indexPath.row;
        [cell.photoImageView addSubview:btn];
    }
    
    
   
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (shareEnabled) {
        // Determine the selected items by using the indexPath
        NSString *selectedRecipe = [self.assets objectAtIndex:indexPath.row];
        // Add the selected item into the array
        //PhotoCell *cell = [[PhotoCell alloc]init];
       // cell.backgroundColor = [UIColor redColor];
        [selectedVideos addObject:selectedRecipe];
    }
    else
    {
     ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
   
       movie = [[MPMoviePlayerController alloc]
                                    initWithContentURL:[[asset defaultRepresentation] url]];
      CGRect videoFrame = CGRectMake(0,0, self.view.frame.size.width  , self.view.frame.size.height);
    

    [[movie view] setFrame:videoFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

    
    movie.controlStyle = MPMovieControlStyleDefault;
    movie.shouldAutoplay = YES;
    [self.view addSubview:movie.view];
    //[self presentMoviePlayerViewControllerAnimated:NO];
    
    
    [movie setFullscreen:YES animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (shareEnabled) {
       
    }
}

- (void)willEnterFullscreen:(NSNotification*)notification {
    NSLog(@"willEnterFullscreen");
}

- (void)enteredFullscreen:(NSNotification*)notification {
    NSLog(@"enteredFullscreen");
}

- (void)willExitFullscreen:(NSNotification*)notification {
    NSLog(@"willExitFullscreen");
}

- (void)exitedFullscreen:(NSNotification*)notification {
    NSLog(@"exitedFullscreen");
    [movie.view removeFromSuperview];
    movie = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished:(NSNotification*)notification {
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackFinished. Reason: Playback Ended");
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"playbackFinished. Reason: Playback Error");
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackFinished. Reason: User Exited");
            break;
        default:
            break;
    }
    [movie setFullscreen:NO animated:YES];
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
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

-(void)selectButtonClicked:(id)sender{
    shareEnabled = YES;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    shareButton.enabled = YES;
    [_collectionView reloadData];
    
}

-(IBAction)buttonPressed:(id)sender{
    
    if ([sender imageForState:UIControlStateNormal] == [UIImage imageNamed:@"deselect.png"]) {
        [sender setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        ALAsset *asset = [self.assets objectAtIndex:[sender tag]];
        
        [selectedVideos addObject:[[asset defaultRepresentation]url]];
       
    }
    else if ([sender imageForState:UIControlStateNormal] == [UIImage imageNamed:@"select.png"]){
        [sender setImage:[UIImage imageNamed:@"deselect.png"] forState:UIControlStateNormal];
        
       ALAsset *asset = [self.assets objectAtIndex:[sender tag]];
        if ([selectedVideos containsObject:[[asset defaultRepresentation]url]]) {
            [selectedVideos removeObject:[[asset defaultRepresentation]url]];
        }
        
    }
}

-(void)share{
    //NSArray *activityItems = [[NSArray alloc]initWithObjects:@"text",nil];
   
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:selectedVideos
     applicationActivities:nil];
   activityController.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
   // activityController.excludedActivityTypes = excludedActivities;
    
    activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
        //if (completed) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [selectedVideos removeAllObjects];
        //}
    };
    
    [self presentViewController:activityController animated:YES completion:nil];
    
    shareButton.enabled = NO;
    shareEnabled = NO;
    [_collectionView reloadData];
    /*
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Share on Facebook",
                            @"Share via E-mail",
                            @"Share via YouTube",
                            @"Share via Vimeo",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];*/
}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:{
                    shareButton.enabled = NO;
                    shareEnabled = NO;
                    NSArray *subViewArray = [self.view subviews];
                    for (id obj in subViewArray)
                    {
                        // here **`obj`**  get each object of subView of UIView.
                    }
                    [_collectionView reloadData];
                }
                    break;
                case 1:
                    
                    break;
                case 2:
                    
                    break;
                case 3:
                   
                    break;
                case 4:
                   
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
@end
