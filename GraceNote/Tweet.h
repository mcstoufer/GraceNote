//
//  Tweet.h
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @brief A base class representing the common properties of a given tweet we would be interested in keeping track of.
 */
@interface Tweet : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSThread *tid;
/**
 *  @brief The text of a given tweet.
 */
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSUInteger likeCount;
@property (nonatomic, assign) NSUInteger rtCount;
/**
 *  @brief The date this tweet was initialy posted.
 */
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSURL *tweetImageURL;

-(instancetype)initTweetWithDict:(NSDictionary *)dict;

+(NSDate *)dateForTweetCreated:(NSString *)created_at;

-(UIImage *)defaultTweetImage;

@end
