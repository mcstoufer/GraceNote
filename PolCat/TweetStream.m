//
//  TweetStream.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "TweetStream.h"

@implementation TweetStream

-(instancetype)init
{
    self = [super init];
    if (self) {
        _tweets = @[];
    }
    return self;
}

-(void)loadTweetsForStreamWithCompletion:(TweetFeedCompletionBlock)complete
{
    NSLog(@"Must implement in subclass");
    return;
}

-(NSString *)titleForTweetAtIndex:(NSUInteger)index
{
    if (index <= self.tweets.count-1) {
        return ((Tweet *)(self.tweets[index])).text;
    }
    return nil;
}

+(void)primaryImageForTweet:(TweetMessage *)tweet withCompletion:(FlickrImageCompletionBlock)complete
{
    return;
}

+(UIImage *)auxImageForTweet:(TweetMessage *)tweet
{
    return nil;
}

-(Tweet *)objectInTweetsAtIndex:(NSUInteger)index
{
    if (index <= self.tweets.count-1) {
        return self.tweets[index];
    }
    return nil;
}
@end
