#import "PNBackdropViewSettingsDefault.h"
#import "PNBackdropView.h"

@implementation PNBackdropViewSettingsDefault

+ (void)applySettingsToBackdropView:(PNBackdropView *)view {

    _UIBackdropViewSettings * backdropSettings = [_UIBackdropViewSettings settingsForPrivateStyle:-2];
    
    [backdropSettings setGraphicsQuality:[[UIDevice currentDevice] _graphicsQuality]];
    [backdropSettings setDefaultValues];

    [backdropSettings setBackdropVisible:YES];
    [backdropSettings setSaturationDeltaFactor:1.8];

    SBLockOverlayStyleProperties * props = [[%c(SBLockOverlayStylePropertiesFactory) overlayPropertiesFactoryWithStyle:0] propertiesWithDeviceDefaultGraphicsQuality];
    
    [backdropSettings setBlurRadius:props.blurRadius];

    //[view applySettings:backdropSettings];
    [view transitionToSettings:backdropSettings];

}

@end
