#import "PNBlurController.h"
#import "PNWallpaperLayer.h"

#import "Private.h"

%hook SBDockView

- (id)initWithDockListView:(id)dockListView forSnapshot:(char)snapshot {

    self = %orig;

    if (self) {

        [[PNBlurController sharedInstance] applyDockChangesOnView:self];

    }

    return self;

}

%end
