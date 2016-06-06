//
//  TweetStream.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "TweetStream.h"

@implementation TweetStream

+(instancetype)sharedStream
{
    NSLog(@"Must implement singleton in subclass");
    return nil;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
//        _tweets = @[];
    }
    return self;
}

-(void)loadTweetsForStreamWithCompletion:(TweetFeedCompletionBlock)complete
{
    NSLog(@"Must implement loader in subclass");
    return;
}

//-(NSString *)titleForTweetAtIndex:(NSUInteger)index
//{
//    if (index <= self.tweets.count-1) {
//        return ((Tweet *)(self.tweets[index])).text;
//    }
//    return nil;
//}

+(void)primaryImageForTweet:(TweetMessage *)tweet withCompletion:(FlickrImageCompletionBlock)complete
{
    return;
}

+(UIImage *)auxImageForTweetMessage:(TweetMessage *)tweet
{
    return nil;
}

//-(Tweet *)objectInTweetsAtIndex:(NSUInteger)index
//{
//    if (index <= self.tweets.count-1) {
//        return self.tweets[index];
//    }
//    return nil;
//}
@end
