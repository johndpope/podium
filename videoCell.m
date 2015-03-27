//
//  videoCell.m
//  IPresentWell
//
//  Created by Ambika on 4/18/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import "videoCell.h"

@implementation videoCell


- (void) setAsset:(ALAsset *)asset
{
    _asset = asset;
    self.myImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}
@end
