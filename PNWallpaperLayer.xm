#import "PNBlurController.h"
#import "PNWallpaperLayer.h"
#import "Logging.h"

@implementation PNWallpaperLayer

- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key {

    if (![[PNBlurController sharedInstance] shouldHook] || 
         [PNBlurController sharedInstance].settings.BlurFading) {
        [super addAnimation:animation forKey:key];
        return;
    }

    if ([key isEqualToString:@"opacity"] && [animation isKindOfClass:[%c(CASpringAnimation) class]]) {

        [[self sublayers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            
            if ([obj isKindOfClass:[%c(PNLayer) class]])
                return;

            [obj addAnimation:animation forKey:key];

        }];

    } else {

        [super addAnimation:animation forKey:key];

    }

}

@end
