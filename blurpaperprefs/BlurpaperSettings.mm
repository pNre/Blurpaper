#import <Preferences/Preferences.h>
#import "BlurpaperSettings.h"

@implementation BlurpaperSettingsListController

- (id)specifiers {

    if (_specifiers == nil)
        _specifiers = [[self loadSpecifiersFromPlistName:@"BlurpaperSettings" target:self] retain];

    return _specifiers;
}

@end

@implementation BlurpaperSettingsHSBlurRadius

- (id)specifiers {

    if (_specifiers == nil)
        _specifiers = [[self loadSpecifiersFromPlistName:@"BlurpaperSettingsHSBlurRadius" target:self] retain];

    return _specifiers;
}

@end

@implementation BlurpaperSettingsLSBlurRadius

- (id)specifiers {

    if (_specifiers == nil)
        _specifiers = [[self loadSpecifiersFromPlistName:@"BlurpaperSettingsLSBlurRadius" target:self] retain];

    return _specifiers;
}

@end
