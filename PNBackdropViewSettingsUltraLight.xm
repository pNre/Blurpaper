#import "PNBackdropViewSettingsUltraLight.h"

@implementation PNBackdropViewSettingsUltraLight

+ (void)applySettingsToBackdropView:(PNBackdropView *)view {

    _UIBackdropViewSettings * backdropSettings = [[%c(_UIBackdropViewSettingsLight) alloc] initWithDefaultValues];
    
    [backdropSettings setGraphicsQuality:[[UIDevice currentDevice] _graphicsQuality]];
    [backdropSettings setDefaultValues];

    [backdropSettings setGrayscaleTintAlpha:0.4];

    [view applySettings:backdropSettings];
    [view transitionToSettings:backdropSettings];

    [backdropSettings release];

}

@end
