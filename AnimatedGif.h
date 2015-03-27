//
//  AnimatedGif.m
//

#ifdef TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif //TARGET_OS_IPHONE

@interface AnimatedGifQueueObject : NSObject
{
    UIImageView *uiv;
    NSURL *url;
}

@property (nonatomic, retain) UIImageView *uiv;
@property (nonatomic, retain) NSURL *url;

@end


@interface AnimatedGif : NSObject
{
	NSData *GIF_pointer;
	NSMutableData *GIF_buffer;
	NSMutableData *GIF_screen;
	NSMutableData *GIF_global;
	NSMutableData *GIF_frameHeader;
	
	NSMutableArray *GIF_delays;
	NSMutableArray *GIF_framesData;
    
    NSMutableArray *imageQueue;
	bool busyDecoding;
	
	int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
	int animatedGifDelay;
	
	int dataPointer;
    
    UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView* imageView;
@property bool busyDecoding;

- (void) addToQueue: (AnimatedGifQueueObject *) agqo;
+ (UIImageView*) getAnimationForGifAtUrl: (NSURL *) animationUrl;
- (void) decodeGIF:(NSData *)GIF_Data;
- (void) GIFReadExtensions;
- (void) GIFReadDescriptor;
- (bool) GIFGetBytes:(int)length;
- (bool) GIFSkipBytes: (int) length;
- (NSMutableData*) getFrameAsDataAtIndex:(int)index;
- (UIImage*) getFrameAsImageAtIndex:(int)index;
- (UIImageView*) getAnimation;

@end
