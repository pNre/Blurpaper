#import "PNBackdropView.h"
#import "PNBackdropViewCustomSettings.h"

#import "Private.h"

@implementation PNBackdropView

+ (Class)layerClass 
{
    return [%c(PNLayer) class];
}

- (instancetype)initWithSettingsClass:(Class)settings {

    _UIBackdropViewSettings * backdropSettings = nil;

    if ([settings isSubclassOfClass:[_UIBackdropViewSettings class]]) {

        backdropSettings = [[[settings alloc] initWithDefaultValues] autorelease];

        [backdropSettings setGraphicsQuality:[[UIDevice currentDevice] _graphicsQuality]];
        [backdropSettings setDefaultValues];

    }

    self = backdropSettings ? [super initWithSettings:backdropSettings] : [super init];

    if (self) {

        _settingsClass = settings;

        if (!backdropSettings) {
            [settings applySettingsToBackdropView:self];
        }

        [self setAppliesOutputSettingsAnimationDuration:0.];
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

    }

    return self;

}

@end
