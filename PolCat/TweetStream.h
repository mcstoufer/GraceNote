//
//  TweetStream.h
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STTwitter.h"
#import "Tweet.h"

@class TweetMessage;

/**
 *  @brief A block definition to handle code execution for when Twitter feed(s) are completely loaded
 *
 *  @param complete If the load of feeds was successful. A value of NO means the internal timeout fired. It is up to the code block to decide how to handle this state.
 */
typedef void(^TweetFeedCompletionBlock)(BOOL complete,
                                        NSUInteger count,
                                        UIBackgroundFetchResult result);
/**
 *  @brief A block definition to handle code execution for when Flickr image(s) are completely loaded and available.
 *
 *  @param image The image that was loaded from Flickr. Nil otherwise.
 */
typedef void(^FlickrImageCompletionBlock)(UIImage* image);

/**
 *  @brief The base Tweet Stream object. Various common properties and methods are defined
 *          here. Some do nothing and will require proper definitions in the subclass
 */
@interface TweetStream : NSObject

/**
 *  @brief The list of tweets retrieved from Twitter.
 */
//@property (nonatomic, strong) NSArray *tweets;
/**
 *  @brief The handle for talking to the Twitter API.
 */
@property (nonatomic, strong) STTwitterAPI *feedHandle;
@property (nonatomic, strong) NSArray <NSString *> *usernames;

+(instancetype)sharedStream;

/**
 *  @brief Called when it is appropriate to star the (re)loading of Tweets.
 *
 *  @param complete The block to excute once the feed(s) have been loaded.
 */
-(void)loadTweetsForStreamWithCompletion:(TweetFeedCompletionBlock)complete;
/**
 *  @brief Get the text for a given Tweet.
 *
 *  @param index The index offset of tweets to find the Tweet for.
 *
 *  @return The text for the given Tweet. Nil if the index is out of range.
 */
//-(NSString *)titleForTweetAtIndex:(NSUInteger)index;
//-(Tweet *)objectInTweetsAtIndex:(NSUInteger)index;
/**
 *  @brief Cause the stream to start the lookup for the primary image of the tweet. 
 *  @discussion Subclasses will be required to implement this method and decice what/how to
 *               accomplish this.
 *
 *  @param tweetMessage    The TweetMessage Managed Object subclass used to derive info from and resolve a primary image for.
 *  @param complete The block of code to execute once the image has been resolved.
 */
+(void)primaryImageForTweet:(TweetMessage *)tweet withCompletion:(FlickrImageCompletionBlock)complete;
/**
 *  @brief Cause the stream o start the lookup for the auxilary image of the tweet.
 *  @discussion Subclasses will be required to implement this method and decice what/how to
 *               accomplish this.

 *
 *  @param tweet The tweet used to derive info from and resolve a auxiliary image for.
 *
 *  @return The aux image or nil if one could not be resolved given the tweet.
 */
+(UIImage *)auxImageForTweetMessage:(TweetMessage *)tweet;

@end
