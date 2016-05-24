//
//  Tweet.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "Tweet.h"

static NSDateFormatter *_tweetDateFormatter;

@implementation Tweet

-(instancetype)initTweetWithDict:(NSDictionary *)dict
{
    Tweet *tweet = [super init];
    if (tweet) {
        tweet.username = dict[@"user"][@"screen_name"];
        tweet.text = dict[@"text"];
        tweet.date = [Tweet dateForTweetCreated:dict[@"created_at"]];
        tweet.likeCount = [dict[@"user"][@"favourites_count"] unsignedIntegerValue];
        tweet.rtCount = [dict[@"retweet_count"] unsignedIntegerValue];
        tweet.tid = dict[@"id_str"];
        NSString *normalImage = dict[@"user"][@"profile_image_url_https"];
        normalImage = [normalImage stringByReplacingOccurrencesOfString:@"_normal" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, normalImage.length)];
        
        tweet.tweetImageURL = [NSURL URLWithString:normalImage];
    }

    return tweet;
}

+(NSDate *)dateForTweetCreated:(NSString *)created_at
{
    if (!_tweetDateFormatter) {
        _tweetDateFormatter = [[NSDateFormatter alloc] init];
        _tweetDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [_tweetDateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    }
    return [_tweetDateFormatter dateFromString:created_at];
}

-(UIImage *)defaultTweetImage
{
    return nil;
}
@end
