//  Created by Jay Marcyes on 10/9/14.

#import "UserDefaults.h"
#import "Utility.h"

@implementation UserDefaults

+ (instancetype)standardUserDefaults {
    static UserDefaults *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserDefaults alloc] init];
     });
    return instance;
}

-(void)setHasCreatedAccount:(BOOL)hasCreatedAccount
{
    [self changeKey:@"has_created_account" toVal:[NSNumber numberWithBool:hasCreatedAccount]];
}

-(BOOL)hasCreatedAccount
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"has_created_account"] boolValue];
}

-(void)setExpectedKeyboardHeight:(CGFloat)expectedKeyboardHeight
{
    NSNumber *height;
    if (expectedKeyboardHeight > 0) {
        height = [NSNumber numberWithFloat:expectedKeyboardHeight];
    }
    [self changeKey:@"KEYBOARD_HEIGHT" toVal:height];
}

-(CGFloat)expectedKeyboardHeight
{
    NSNumber *height = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEYBOARD_HEIGHT"];
    if (height) {
        return [height floatValue];
    }
    return 0.0;
}

- (BOOL)hasInstalled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kHasInstalled"];
}

- (void)setHasInstalled:(BOOL)view
{
    [[NSUserDefaults standardUserDefaults] setBool:view forKey:@"kHasInstalled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsInitialLogin:(BOOL)hasLoggedIn
{
    [self changeKey:@"kHasLoggedIn" toVal:@(hasLoggedIn)];
}

-(BOOL)isInitialLogin
{
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHasLoggedIn"];
    return !loggedIn;
}

-(void)setFilterSettings:(NSMutableDictionary<NSString *,NSMutableDictionary *> *)filterSettings
{
    [[NSUserDefaults standardUserDefaults] setObject:filterSettings forKey:@"kFilterSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableDictionary<NSString *,NSMutableDictionary *> *)filterSettings
{
    NSMutableDictionary *filterSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"kFilterSettings"]];
    if (!filterSettings || filterSettings.count == 0) {
        filterSettings = [NSMutableDictionary dictionaryWithDictionary:@{kFilterStates : [NSMutableDictionary dictionary],
                           kFilterParties : [NSMutableDictionary dictionary],
                           kFilterKeywords : [NSMutableDictionary dictionary]}];
        [self setFilterSettings:filterSettings];
    }
    return filterSettings;
}

/**
 *  synchronize the environment to a user defined value instead of what is in the environment plist
 *
 *  @param key the key to sync to the user defaults
 *  @param val the value to sync at key
 */
- (void) changeKey:(NSString *) key toVal:(id)val
{
    if (val) {
        [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
        
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
