//  Created by Jay Marcyes on 10/9/14.

@import Foundation;
@import UIKit;

#define kFilterStates @"States"
#define kFilterParties @"Parties"
#define kFilterKeywords @"Keywords"

#import "Constants.h"

/**
 *  this brings all the disparate configuration objects (eg, NSUserDefaults, SSKeychain,
 *  FoEnviron) together under one roof
 *
 *  @code
 *  [FOUserDefaults standardUserDefaults]; // get the singleton instance
 *  @endcode
 */
@interface UserDefaults : NSObject


/**
 *  true if this is not the first launch
 */
@property (nonatomic) BOOL hasInstalled;
/**
 *  @brief Keep track of if a user has logged in at least once.
 *  @discussion The app may be launched/killed multiple times before a login has occured. 
 *              Also, once a user has logged out, this resets so the next login can behave as expected.
 */
@property (nonatomic) BOOL isInitialLogin;


@property (nonatomic, assign) BOOL hasCreatedAccount;

/**
 *  holds the params needed for a password reset
 */
@property (nonatomic, copy) NSDictionary *passcodeResetParams;

/**
 *  @brief Return the last calculated height of the keyboard when it was shown in this app.
 *  @discussion Value may have been changed if keyboard sizing was changed by another app.
 */
@property (nonatomic, assign) CGFloat expectedKeyboardHeight;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary *> *filterSettings;
/**
 *  return the shared instance object for user defaults
 *
 *  it's named this instead of instance (which I prefer) to match NSUserDefaults
 *
 *  @return the singleton instance of this class
 */
+ (instancetype)standardUserDefaults;
@end
