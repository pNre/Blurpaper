#import <UIKit/UIKit.h>
#import "Private.h"

@interface PNBlurController : NSObject

@property (nonatomic, assign) struct {

        BOOL TweakEnabled;

        BOOL ParallaxEnabled;
        BOOL BlurFading;

        //  Dock
        BOOL ShowDockBackground;
        BOOL ShowDockSeparator;

        //  Wallpapers
        BOOL BlurLockscreen;
        BOOL BlurHomescreen;

        //  Blur classes
        Class LockscreenBlurClass;
        Class HomescreenBlurClass;

    } settings;

+ (instancetype)sharedInstance;

- (void)applySettings:(NSDictionary *)settings;

- (void)removeBackdropFromWallpaperView:(SBFWallpaperView *)view;
- (void)applyBackdropToWallpaperView:(SBFWallpaperView *)view forVariant:(NSInteger)variant;

- (BOOL)shouldHook;
- (BOOL)variantsShareBlur;

@end
