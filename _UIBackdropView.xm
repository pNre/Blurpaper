#import "PNBlurController.h"
#import "PNBackdropView.h"

%hook _UIBackdropView

//  Bypass Reduce Contrast option removing custom views from the list of all backdrop views.
+ (id)allBackdropViews {

    NSArray * views = %orig;

    if (![[PNBlurController sharedInstance] shouldHook])
        return views;

    return [views filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary * bindings) {
        return ![object isKindOfClass:[PNBackdropView class]];
    }]];

    return views;

}

%end
