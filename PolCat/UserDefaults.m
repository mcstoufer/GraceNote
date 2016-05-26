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

-(void)togglePartyFilter:(Party)party state:(BOOL)state
{
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:stringForPartyEnum(party)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)stateForPartyFilter:(Party)party
{
    NSString *key = stringForPartyEnum(party);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    } else {
        [self togglePartyFilter:party state:YES];
        return YES;
    }
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
