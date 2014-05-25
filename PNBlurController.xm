#import <substrate.h>

#import "PNBlurController.h"
#import "PNBackdropView.h"

#import "PNBackdropViewSettingsDefault.h"
#import "PNBackdropViewSettingsUltraLight.h"

#import "Private.h"
#import "Logging.h"

#define kBackdropCCStyle 0x080C

@implementation PNBlurController {
    NSDictionary * _blurClasses;
    BOOL _didLoadSettings;
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

        _didLoadSettings = NO;

        //  Init settings to default values
        _settings.TweakEnabled = YES;

        _settings.ParallaxEnabled = YES;
        _settings.BlurFading = YES;

        _settings.ShowDockBackground = NO;
        _settings.ShowDockSeparator = YES;

        _settings.BlurHomescreen = YES;
        _settings.BlurLockscreen = YES;
        _settings.BlurControlCenter = YES;

        _settings.HomescreenBlurRadius = 2;
        _settings.HomescreenBlurRadiusDefault = YES;
        _settings.LockscreenBlurRadius = 2;
        _settings.LockscreenBlurRadiusDefault = YES;
        _settings.ControlCenterBlurRadius = 2;
        _settings.ControlCenterBlurRadiusDefault = YES;


        _settings.HomescreenBlurClass = [PNBackdropViewSettingsDefault class];
        _settings.LockscreenBlurClass = [PNBackdropViewSettingsDefault class];
        _settings.ControlCenterBlurClass = [%c(_UIBackdropViewSettingsDark) class];

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

- (void)dealloc {

    [_blurClasses release];
    [super dealloc];

}

- (struct BLPSettings)settings {

    if (!_didLoadSettings) {

        //  Load settings plist
        NSDictionary * settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.pNre.blurpaper.plist"];

        if (!settings)
            return _settings;

        [[PNBlurController sharedInstance] applySettings:settings];

    }

    return _settings;

}

//  Check if homescreen and lockscreen are using the same wallpaper & blur style
- (BOOL)variantsShareBlur {

    return ([self.settings.HomescreenBlurClass isEqual:self.settings.LockscreenBlurClass]) && self.settings.BlurHomescreen && self.settings.BlurLockscreen;

}

- (BOOL)shouldHook {

    return _settings.TweakEnabled && (_settings.BlurHomescreen || _settings.BlurLockscreen || _settings.BlurControlCenter);

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

    PNLog(@"Adding backdrop %@ to %@ with class %@", backdrop, view, backdropClass);

    if (variant == kVariantLockscreen && !self.settings.LockscreenBlurRadiusDefault) {
        [backdrop.inputSettings setBlurRadius:self.settings.LockscreenBlurRadius];
    } else if (variant == kVariantHomescreen && !self.settings.HomescreenBlurRadiusDefault) {
        [backdrop.inputSettings setBlurRadius:self.settings.HomescreenBlurRadius];
    }

    [view addSubview:backdrop];
    
    [backdrop release];

}

void SBControlCenterContentContainerViewReplaceBackdrop(SBControlCenterContentContainerView * view, _UIBackdropView * replaceView) {

    _UIBackdropView * &_originalBackdrop = MSHookIvar<_UIBackdropView *>(view, "_backdropView");

    if (!_originalBackdrop || !replaceView)
        return;

    [_originalBackdrop removeFromSuperview];
    [_originalBackdrop release];
        
    _originalBackdrop = replaceView;
    [_originalBackdrop setAppliesOutputSettingsAnimationDuration:1.0];
    [_originalBackdrop setGroupName:@"ControlCenter"];

    [view insertSubview:_originalBackdrop atIndex:0];
}

- (void)applyBackdropToControlCenter {

    SBControlCenterViewController * viewController = MSHookIvar<SBControlCenterViewController *>([%c(SBControlCenterController) sharedInstance], "_viewController");
    SBControlCenterContainerView *containerView = MSHookIvar<SBControlCenterContainerView *>(viewController, "_containerView");
    SBControlCenterContentContainerView *contentContainerView = MSHookIvar<SBControlCenterContentContainerView *>(containerView, "_contentContainerView");
    
    _UIBackdropView* backdrop = nil;
    if (!_settings.TweakEnabled || !_settings.BlurControlCenter) {
        backdrop = [[_UIBackdropView alloc] initWithPrivateStyle:kBackdropCCStyle];
    }
    else {
        Class backdropClass = _settings.ControlCenterBlurClass;
        backdrop = [[PNBackdropView alloc] initWithSettingsClass:backdropClass];
        if (!self.settings.ControlCenterBlurRadiusDefault) {
            [backdrop.inputSettings setBlurRadius:self.settings.ControlCenterBlurRadius];
        }
    }
    SBControlCenterContentContainerViewReplaceBackdrop(contentContainerView, backdrop);
}


- (void)applyDockChangesOnView:(SBDockView *)dockView {

    UIView * _backgroundView = MSHookIvar<UIView *>(dockView, "_backgroundView");
    UIView * _highlightView = MSHookIvar<UIView *>(dockView, "_highlightView");

    if (_backgroundView && [_backgroundView isHidden] == self.settings.ShowDockBackground) {
        [_backgroundView setHidden:!_settings.ShowDockBackground];
    }

    if (_highlightView && [_highlightView isHidden] == self.settings.ShowDockSeparator) {
        [_highlightView setHidden:!_settings.ShowDockSeparator];
    }

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

    [self applyDockChangesOnView:dockView];

}

- (void)cleanupBackdrops {

    SBWallpaperController * wallpaperController = [%c(SBWallpaperController) sharedInstance];

    SBFWallpaperView * _lockscreenWallpaperView = MSHookIvar<SBFWallpaperView *>(wallpaperController, "_lockscreenWallpaperView");
    SBFWallpaperView * _homescreenWallpaperView = MSHookIvar<SBFWallpaperView *>(wallpaperController, "_homescreenWallpaperView");
    SBFWallpaperView * _sharedWallpaperView = MSHookIvar<SBFWallpaperView *>(wallpaperController, "_sharedWallpaperView");

    [[PNBlurController sharedInstance] removeBackdropFromWallpaperView:_sharedWallpaperView];
    [[PNBlurController sharedInstance] removeBackdropFromWallpaperView:_lockscreenWallpaperView];
    [[PNBlurController sharedInstance] removeBackdropFromWallpaperView:_homescreenWallpaperView];

}

- (void)settingsDidChange {

    [self applyDockChanges];

    [self cleanupBackdrops];

    [[%c(SBWallpaperController) sharedInstance] _updateWallpaperForLocations:0 withCompletion:nil];
    [[%c(SBWallpaperController) sharedInstance] _updateEffectViewForVariant:kVariantLockscreen withFactory:nil];
    [[%c(SBWallpaperController) sharedInstance] _updateEffectViewForVariant:kVariantHomescreen withFactory:nil];

    [self applyBackdropToControlCenter];

}

//  Load settings from settings dictionary
- (void)applySettings:(NSDictionary *)settings {

    _didLoadSettings = YES;

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

    if ([settings objectForKey:@"ControlCenter"])
        _settings.BlurControlCenter = [[settings objectForKey:@"ControlCenter"] boolValue];


    if ([settings objectForKey:@"Parallax"])
        _settings.ParallaxEnabled = [[settings objectForKey:@"Parallax"] boolValue];
    
    if ([settings objectForKey:@"BlurFading"])
        _settings.BlurFading = [[settings objectForKey:@"BlurFading"] boolValue];

    if ([settings objectForKey:@"LockscreenStyle"])
        _settings.LockscreenBlurClass = [_blurClasses objectForKey:[settings objectForKey:@"LockscreenStyle"]];

    if ([settings objectForKey:@"HomescreenStyle"])
        _settings.HomescreenBlurClass = [_blurClasses objectForKey:[settings objectForKey:@"HomescreenStyle"]];

    if ([settings objectForKey:@"ControlCenterStyle"])
        _settings.ControlCenterBlurClass = [_blurClasses objectForKey:[settings objectForKey:@"ControlCenterStyle"]];
    
    if (!_settings.LockscreenBlurClass)
        _settings.LockscreenBlurClass = [%c(_UIBackdropViewSettingsBlur) class];
    
    if (!_settings.HomescreenBlurClass)
        _settings.HomescreenBlurClass = [%c(_UIBackdropViewSettingsBlur) class];

    if (!_settings.ControlCenterBlurClass)
        _settings.ControlCenterBlurClass = [%c(_UIBackdropViewSettingsDark) class];

    if ([settings objectForKey:@"HomescreenBlurRadius"])
        _settings.HomescreenBlurRadius = [[settings objectForKey:@"HomescreenBlurRadius"] floatValue];

    if ([settings objectForKey:@"LockscreenBlurRadius"])
        _settings.LockscreenBlurRadius = [[settings objectForKey:@"LockscreenBlurRadius"] floatValue];

    if ([settings objectForKey:@"ControlCenterBlurRadius"])
        _settings.ControlCenterBlurRadius = [[settings objectForKey:@"ControlCenterBlurRadius"] floatValue];
    
    if ([settings objectForKey:@"HomescreenBlurRadiusDefault"])
        _settings.HomescreenBlurRadiusDefault = [[settings objectForKey:@"HomescreenBlurRadiusDefault"] boolValue];

    if ([settings objectForKey:@"LockscreenBlurRadiusDefault"])
        _settings.LockscreenBlurRadiusDefault = [[settings objectForKey:@"LockscreenBlurRadiusDefault"] boolValue];

    if ([settings objectForKey:@"LockscreenBlurRadiusDefault"])
        _settings.ControlCenterBlurRadiusDefault = [[settings objectForKey:@"ControlCenterBlurRadiusDefault"] boolValue];

}

@end
