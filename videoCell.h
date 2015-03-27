//
//  videoCell.h
//  IPresentWell
//
//  Created by Ambika on 4/18/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>


@interface videoCell : UICollectionViewCell
@property(nonatomic, strong) ALAsset *asset;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end
