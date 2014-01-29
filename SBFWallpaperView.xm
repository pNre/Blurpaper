#import "PNBlurController.h"
#import "PNWallpaperLayer.h"

#import "Private.h"

%hook SBFWallpaperView

+ (id)layerClass {
    
    return [PNWallpaperLayer class];

}

//  Rasterization breaks blur along wallpaper's margin.
//  This method returns YES when Reduce Motion is enabled in Accessibility.
- (BOOL)wantsRasterization {

    if (![[PNBlurController sharedInstance] shouldHook])
        return %orig;

    //  Where am I? Lockscreen or homescreen?
    if ([self variant] == 0 && ![PNBlurController sharedInstance].settings.BlurLockscreen)
        return %orig;

    if ([self variant] == 1 && ![PNBlurController sharedInstance].settings.BlurHomescreen)
        return %orig;
    
    return NO;

}

%end
