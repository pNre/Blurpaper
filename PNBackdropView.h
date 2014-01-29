#import <UIKit/UIKit.h>
#import "Private.h"

@interface PNBackdropView : _UIBackdropView {
    
}

@property (nonatomic, assign) Class settingsClass;

- (instancetype)initWithSettingsClass:(Class)settings;

@end
