#import <UIKit/UIKit.h>
#import "Private.h"

@interface PNBlurController : NSObject

@property (nonatomic, assign) struct BLPSettings {

        BOOL TweakEnabled;

        BOOL ParallaxEnabled;
        BOOL BlurFading;

        //  Dock
        BOOL ShowDockBackground;
        BOOL ShowDockSeparator;

        //  Wallpapers
        BOOL BlurLockscreen;
        BOOL BlurHomescreen;

        //  Radius
        CGFloat HomescreenBlurRadius;
        BOOL HomescreenBlurRadiusDefault;

        CGFloat LockscreenBlurRadius;
        BOOL LockscreenBlurRadiusDefault;

        //  Blur classes
        Class LockscreenBlurClass;
        Class HomescreenBlurClass;

    } settings;

+ (instancetype)sharedInstance;

- (void)settingsDidChange;
- (void)applySettings:(NSDictionary *)settings;
- (void)applyDockChangesOnView:(SBDockView *)dockView;

- (void)removeBackdropFromWallpaperView:(SBFWallpaperView *)view;
- (void)applyBackdropToWallpaperView:(SBFWallpaperView *)view forVariant:(NSInteger)variant;

- (BOOL)shouldHook;
- (BOOL)variantsShareBlur;

@end
