//
//  CustomCellView.h
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/24/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellView : UITableViewCell
{
    UILabel *speechTitle;
    UILabel *speechDate;
}
@property(nonatomic,retain)IBOutlet UILabel *speechTitle,*speechDate;
@end
