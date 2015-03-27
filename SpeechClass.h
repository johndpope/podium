//
//  SpeechClass.h
//  IPresentWellForIPad
//
//  Created by netGALAXY Studios on 2/24/14.
//  Copyright (c) 2014 netGALAXY Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeechClass : NSObject
{
    NSString *speechID,*speechText,*speechDate,*speechTitle;
}

@property(nonatomic,retain)IBOutlet NSString *speechID,*speechText,*speechDate,*speechTitle;
@end
