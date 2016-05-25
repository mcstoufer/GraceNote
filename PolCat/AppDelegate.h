//
//  AppDelegate.h
//  GraceNote
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kflickrKey @"41db9418e95eed2bf561db7ac5dfb2da"
#define kflickrSec @"e131c0a9513e2172"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  @brief A system cache that will hold onto images for a given tweet. This object responds to low-memory warnings itself, so the cache may flush at any time.
 */
+(NSCache *)sharedCache;

@end

