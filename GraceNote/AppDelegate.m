//
//  AppDelegate.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "AppDelegate.h"
#import "FlickrKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSCache *_sharedCache;
+(NSCache *)sharedCache
{
    static dispatch_once_t sharedCacheToken;
    dispatch_once(&sharedCacheToken, ^{
        if (!_sharedCache) {
            _sharedCache = [NSCache new];
        }
    });
    return _sharedCache;
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *scheme = [url scheme];
    
    // NOTE: This scheme is defined in the Info.plist and is used by Flickr for OAuth purposes.
    if([@"gracenotedemo" isEqualToString:scheme]) {
        // I don't recommend doing it like this, it's just a demo... I use an authentication
        // controller singleton object in my projects
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:kflickrKey sharedSecret:kflickrSec];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
