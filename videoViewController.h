//
//  videoViewController.h
//  IPresentWell
//
//  Created by Ambika on 4/17/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface videoViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *assets;

@end
