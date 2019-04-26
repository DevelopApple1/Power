#import "NSTask.h"
#import <libcolorpicker.h>
#import <Cephei/HBPreferences.h>

@interface SBAlert : UIViewController
@end

/*
	The heart of the tweak!
*/
@interface SBPowerDownController : SBAlert
-(void)powerDown;
-(void)cancel;
-(void)renderMain;
-(void)renderAdvanced;
@end

/*
	Used for rebooting the system
*/
@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)shutdownAndReboot:(BOOL)arg1;
@end

/*
	Some modifications to UIButton to make it nicer, don't have the source but it's from StackOverflow!
*/
@interface UIButton (VerticalLayout)
// Put the image above the label and center them
- (void)centerVertically;
@end

@implementation UIButton (VerticalLayout)
/*
	Put the image above the label and center them
*/
- (void)centerVertically {
	// Spacing between the text and the image
	CGFloat spacing = 2.0;

	// Lower the text and push it left so it appears centered below the image
	CGSize imageSize = self.imageView.frame.size;
	self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);

	// Raise the image and push it right so it appears centered above the text
	CGSize titleSize = self.titleLabel.frame.size;
	self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}
@end