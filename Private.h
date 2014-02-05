#define kVariantLockscreen 0
#define kVariantHomescreen 1

@interface SBLockOverlayStyleProperties

@property(readonly, assign, nonatomic) float blurRadius;

@end

@interface SBLockOverlayStylePropertiesFactory

+ (id)overlayPropertiesFactoryWithStyle:(unsigned)style;
- (SBLockOverlayStyleProperties *)propertiesWithDeviceDefaultGraphicsQuality;

@end

@interface SBFProceduralWallpaperView {
}

- (void)setWallpaperOptions:(id)options;

@end

@interface SBFWallpaperView : UIView {

}

@property (assign,nonatomic) BOOL parallaxEnabled;

- (void)setZoomFactor:(float)factor;

- (int)variant;
- (void)setVariant:(int)variant;

@end

@interface SBIconController

+ (id)sharedInstance;

- (id)_rootFolderController;

- (id)dockListView;

@end

@interface SBDockView : UIView 
{
    id _iconListView;
    id _highlightView;
    id _backgroundView;
    UIImageView * _backgroundImageView;
}

@end

@interface SBRootFolderView

- (id)dockView;

@end

@interface SBRootFolderController

@property (nonatomic, readonly) SBRootFolderView * contentView; 

@end

@interface SBWallpaperController

- (BOOL)variantsShareWallpaper;

- (void)_updateSeparateWallpaper;
- (void)_updateSharedWallpaper;

- (void)_updateWallpaperForLocations:(int)locations withCompletion:(id)completion;
- (BOOL)_updateEffectViewForVariant:(int)arg1 withFactory:(id)arg2;

- (void)_beginSuspendingMotionEffectsForBlurIfNeeded;
- (void)_endSuspendingMotionEffectsForBlurIfNeeded;

- (id)_newFakeBlurViewForVariant:(int)variant;
- (id)_newWallpaperViewForProcedural:(id)procedural orImage:(id)image;

- (void)_handleWallpaperChangedForVariant:(int)variant;

@end

@interface _UIBackdropColorSettings : NSObject {

    float _averageHue;
    float _averageSaturation;
    float _averageBrightness;
    float _contrast;
    id _parentSettings;
    float _previousAverageHue;
    float _previousAverageSaturation;
    float _previousAverageBrightness;
    float _previousContrast;

}

@property (assign,nonatomic) float averageHue;                                      //@synthesize averageHue=_averageHue - In the implementation block
@property (assign,nonatomic) float averageSaturation;                               //@synthesize averageSaturation=_averageSaturation - In the implementation block
@property (assign,nonatomic) float averageBrightness;                               //@synthesize averageBrightness=_averageBrightness - In the implementation block
@property (assign,nonatomic) float contrast;                                        //@synthesize contrast=_contrast - In the implementation block
@property (nonatomic,readonly) UIColor * color; 
@property (assign,nonatomic) id parentSettings;              //@synthesize parentSettings=_parentSettings - In the implementation block
@property (assign,nonatomic) float previousAverageHue;                              //@synthesize previousAverageHue=_previousAverageHue - In the implementation block
@property (assign,nonatomic) float previousAverageSaturation;                       //@synthesize previousAverageSaturation=_previousAverageSaturation - In the implementation block
@property (assign,nonatomic) float previousAverageBrightness;                       //@synthesize previousAverageBrightness=_previousAverageBrightness - In the implementation block
@property (assign,nonatomic) float previousContrast;                                //@synthesize previousContrast=_previousContrast - In the implementation block
- (void)setValuesFromModel:(id)arg1 ;
- (void)setAverageHue:(float)arg1 ;
- (void)setAverageSaturation:(float)arg1 ;
- (void)setAverageBrightness:(float)arg1 ;
- (void)setContrast:(float)arg1 ;
- (float)averageSaturation;
- (float)averageBrightness;
- (id)color;
- (void)setDefaultValues;
- (float)contrast;
- (void)setParentSettings:(id)arg1 ;
- (float)averageHue;
- (void)setPreviousAverageHue:(float)arg1 ;
- (void)setPreviousAverageSaturation:(float)arg1 ;
- (void)setPreviousAverageBrightness:(float)arg1 ;
- (void)setPreviousContrast:(float)arg1 ;
- (id)parentSettings;
- (float)previousAverageHue;
- (float)previousAverageSaturation;
- (float)previousAverageBrightness;
- (float)previousContrast;
- (BOOL)applyCABackdropLayerStatistics:(id)arg1 ;
@end

@interface _UIBackdropViewSettings : NSObject {
}

+ (id)settingsForStyle:(unsigned)style;
+ (id)settingsForPrivateStyle:(int)style;

- (id)initWithDefaultValues;

- (_UIBackdropColorSettings *)colorSettings;
- (void)setColorSettings:(_UIBackdropColorSettings *)colorSettings;

- (void)setBackdropVisible:(BOOL)visible;
- (void)setSaturationDeltaFactor:(CGFloat)factor;

- (void)setBlurRadius:(float)arg1;
- (float)blurRadius;

- (void)setGrayscaleTintAlpha:(float)arg1;

- (void)setColorTint:(UIColor *)color;
- (void)setColorTintAlpha:(float)alpha;

- (void)setGrayscaleTintLevel:(float)arg1;
- (void)setGrayscaleTintAlpha:(float)arg1;

- (float)grayscaleTintAlpha;

- (void)setExplicitlySetGraphicsQuality:(BOOL)arg1;

- (void)setGraphicsQuality:(int)arg1;
- (void)setDefaultValues;

@end

@interface _UIBackdropView : UIView {
    
}

@property(retain) _UIBackdropViewSettings * inputSettings;
@property(retain) _UIBackdropViewSettings * outputSettings;

- (id)init;
- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame style:(int)style;
- (id)initWithStyle:(int)style;
- (id)initWithPrivateStyle:(int)style;
- (id)initWithFrame:(CGRect)frame settings:(_UIBackdropViewSettings *)settings;
- (id)initWithSettings:(id)arg1;

- (void)setBlurRadius:(float)arg1;

- (void)setShouldRasterizeEffectsView:(BOOL)arg1;

- (void)setComputesColorSettings:(BOOL)arg1;
- (void)setWantsColorSettings:(BOOL)arg1;

- (void)applySettings:(id)settings;
- (void)transitionToSettings:(id)settings;

- (void)setAppliesOutputSettingsAnimationDuration:(double)duration;

- (void)setGroupName:(NSString *)groupName;

- (void)setGraphicsQualityChangeDelegate:(id)arg1;

- (BOOL)applyingTransition;

- (void)addObserver:(id)observer;

@end

@interface _SBDockBackgroundView : UIView

- (void)setStyle:(int)arg1;

@end

UIKIT_EXTERN BOOL _UIAccessibilityEnhanceBackgroundContrast();

@interface UIDevice (Priv8)

- (int)_graphicsQuality;

@end

