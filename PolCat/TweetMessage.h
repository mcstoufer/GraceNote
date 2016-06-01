//
//  TweetMessage.h
//  
//
//  Created by Martin Stoufer on 5/31/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "PoliticalTweet.h"
NS_ASSUME_NONNULL_BEGIN

@interface TweetMessage : NSManagedObject

+(instancetype)tweetMessageFromTweet:(PoliticalTweet *)tweet;

- (UIColor *)fillColorForImages;
- (UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END

#import "TweetMessage+CoreDataProperties.h"
