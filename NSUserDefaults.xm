%hook NSUserDefaults

- (NSDictionary *)dictionaryForKey:(NSString *)key {

    NSDictionary * dictionary = %orig;

    if ([key isEqualToString:@"kSBProceduralWallpaperLockOptionsKey"]) {
        dictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [(NSMutableDictionary *)dictionary setObject:@(YES) forKey:@"kBlurPaperPlaceholder"];
    }

    return dictionary;

}

%end
