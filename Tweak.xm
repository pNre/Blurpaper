#import "PNBlurController.h"
#import "Logging.h"

static void reloadSettings() {

    //  Load settings plist
    NSDictionary * settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.pNre.blurpaper.plist"];

    if (!settings)
        return;

    [[PNBlurController sharedInstance] applySettings:settings];

}

static void reloadSettingsNotification(CFNotificationCenterRef notificationCenterRef, void * arg1, CFStringRef arg2, const void * arg3, CFDictionaryRef dictionary)
{
    reloadSettings();
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    %orig;

    reloadSettings();
    //CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.pNre.blurpaper/settingsupdated"), NULL, NULL, TRUE);

}

%end

%ctor {

    @autoreleasepool {

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettingsNotification, CFSTR("com.pNre.blurpaper/settingsupdated"), NULL, CFNotificationSuspensionBehaviorCoalesce);

        %init;

    }

}