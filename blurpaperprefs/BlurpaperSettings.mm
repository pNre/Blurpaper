#import <Preferences/Preferences.h>
#import "BlurpaperSettings.h"

@implementation BlurpaperSettingsListController

- (id)specifiers {

    if (_specifiers == nil)
        _specifiers = [[self loadSpecifiersFromPlistName:@"BlurpaperSettings" target:self] retain];

    return _specifiers;
}

@end
