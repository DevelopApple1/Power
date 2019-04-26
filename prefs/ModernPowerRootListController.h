#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import "../NSTask.h"

@interface ModernPowerRootListController : HBRootListController
- (void)respring;
- (void)share;
- (void)import;
@property(nonatomic, retain) UIBarButtonItem *respringButton;
@end

@interface ModernPowerCreditsController : HBRootListController
@end

@interface ModernPowerDefSettingsController : HBRootListController
@end

@interface ModernPowerModernSettingsController : HBRootListController
@end

@interface ModernPowerCustomSettingsController : HBRootListController
@end