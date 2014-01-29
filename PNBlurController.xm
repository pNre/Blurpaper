#import "PNBlurController.h"
#import "PNBackdropView.h"

#import "PNBackdropViewSettingsDefault.h"
#import "PNBackdropViewSettingsUltraLight.h"

#import "Private.h"
#import "Logging.h"

@implementation PNBlurController {
    NSDictionary * _blurClasses;
}

+ (instancetype)sharedInstance {

    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;

}

- (instancetype)init {

    self = [super init];

    if (self) {

        //  Init settings to default values
        _settings.TweakEnabled = YES;

        _settings.ParallaxEnabled = YES;
        _settings.BlurFading = YES;

        _settings.ShowDockBackground = NO;
        _settings.ShowDockSeparator = YES;

        _settings.BlurHomescreen = YES;
        _settings.BlurLockscreen = YES;

        _settings.HomescreenBlurClass = [PNBackdropViewSettingsDefault class];
        _settings.LockscreenBlurClass = [PNBackdropViewSettingsDefault class];

        //  Load blur classes
        _blurClasses = [@{

            @"UltraLight":      [PNBackdropViewSettingsUltraLight class],
            @"Light":           [%c(_UIBackdropViewSettingsLight) class],
            @"AdaptiveLight":   [%c(_UIBackdropViewSettingsAdaptiveLight) class],
            @"SemiLight":       [%c(_UIBackdropViewSettingsSemiLight) class],
            @"Blur":            [PNBackdropViewSettingsDefault class],
            @"Dark":            [%c(_UIBackdropViewSettingsDark) class],
            @"DarkZoom":        [%c(_UIBackdropViewSettingsDarkWithZoom) class],
            @"UltraDark":       [%c(_UIBackdropViewSettingsUltraDark) class],
            @"BlurDefault":     [%c(_UIBackdropViewSettingsBlur) class],
            @"BW":              [%c(_UIBackdropViewSettingsColored) class]

        } retain];

    }

    return self;

}

//  Check if homescreen and lockscreen are using the same wallpaper & blur style
- (BOOL)variantsShareBlur {

    return ([_settings.HomescreenBlurClass isEqual:_settings.LockscreenBlurClass]) && _settings.BlurHomescreen && _settings.BlurLockscreen;

}

- (BOOL)shouldHook {

    return _settings.TweakEnabled;

}

- (void)removeBackdropFromWallpaperView:(SBFWallpaperView *)view {

    [[view subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        if ([obj isKindOfClass:[PNBackdropView class]])
            [obj removeFromSuperview];

    }];

}

- (void)applyBackdropToWallpaperView:(SBFWallpaperView *)view forVariant:(NSInteger)variant {

    Class backdropClass = variant == kVariantLockscreen ? _settings.LockscreenBlurClass : _settings.HomescreenBlurClass;

    PNBackdropView * backdrop = [[PNBackdropView alloc] initWithSettingsClass:backdropClass];

    PNLog(@"Adding backdrop %@ to %@", backdrop, view);

    [view addSubview:backdrop];
    
    [backdrop release];

}

- (void)applyDockChanges {

    SBRootFolderController * rootFolderController = [[%c(SBIconController) sharedInstance] _rootFolderController];

    if (!rootFolderController) {
        PNLog(@"rootFolderController = nil");
        return;
    }

    SBRootFolderView * rootFolderView = [rootFolderController contentView];

    if (!rootFolderView) {
        PNLog(@"rootFolderView = nil");
        return;
    }

    SBDockView * dockView = [rootFolderView dockView];

    if (!dockView) {
        PNLog(@"rootFolderView = nil");
        return;
    }

    UIView * _backgroundView = MSHookIvar<UIView *>(dockView, "_backgroundView");
    UIView * _highlightView = MSHookIvar<UIView *>(dockView, "_highlightView");

    if (_backgroundView) {
        [_backgroundView setHidden:!_settings.ShowDockBackground];
    }

    if (_highlightView) {
        [_highlightView setHidden:!_settings.ShowDockSeparator];
    }

}

- (void)settingsDidChange {

    [self applyDockChanges];

    [[%c(SBWallpaperController) sharedInstance] _updateWallpaperForLocations:0 withCompletion:nil];
    [[%c(SBWallpaperController) sharedInstance] _updateEffectViewForVariant:kVariantLockscreen withFactory:nil];
    [[%c(SBWallpaperController) sharedInstance] _updateEffectViewForVariant:kVariantHomescreen withFactory:nil];

}

//  Load settings from settings dictionary
- (void)applySettings:(NSDictionary *)settings {

    if ([settings objectForKey:@"TweakEnabled"])
        _settings.TweakEnabled = [[settings objectForKey:@"TweakEnabled"] boolValue];

    if ([settings objectForKey:@"DockBackground"])
        _settings.ShowDockBackground = [[settings objectForKey:@"DockBackground"] boolValue];

    if ([settings objectForKey:@"DockSeparator"])
        _settings.ShowDockSeparator = [[settings objectForKey:@"DockSeparator"] boolValue];

    if ([settings objectForKey:@"Homescreen"])
        _settings.BlurHomescreen = [[settings objectForKey:@"Homescreen"] boolValue];

    if ([settings objectForKey:@"Lockscreen"])
        _settings.BlurLockscreen = [[settings objectForKey:@"Lockscreen"] boolValue];

    if ([settings objectForKey:@"Parallax"])
        _settings.ParallaxEnabled = [[settings objectForKey:@"Parallax"] boolValue];
    
    if ([settings objectForKey:@"BlurFading"])
        _settings.BlurFading = [[settings objectForKey:@"BlurFading"] boolValue];

    if ([settings objectForKey:@"LockscreenStyle"])
        _settings.LockscreenBlurClass = [_blurClasses objectForKey:[settings objectForKey:@"LockscreenStyle"]];

    if ([settings objectForKey:@"HomescreenStyle"])
        _settings.HomescreenBlurClass = [_blurClasses objectForKey:[settings objectForKey:@"HomescreenStyle"]];
    
    if (!_settings.LockscreenBlurClass)
        _settings.LockscreenBlurClass = [%c(_UIBackdropViewSettingsBlur) class];
    
    if (!_settings.HomescreenBlurClass)
        _settings.HomescreenBlurClass = [%c(_UIBackdropViewSettingsBlur) class];

    [self settingsDidChange];

}

@end
