//
//  TweetMessage.m
//  
//
//  Created by Martin Stoufer on 5/31/16.
//
//

#import "TweetMessage.h"
#import "DataStore.h"

@implementation TweetMessage

+(instancetype)newTweetMessage
{
    DataStore *instance = [DataStore sharedStore];
    return [NSEntityDescription insertNewObjectForEntityForName:@"TweetMessage"
                                         inManagedObjectContext:instance.managedObjectContext];
}

+(instancetype)tweetMessageFromTweet:(PoliticalTweet *)tweet
{
    TweetMessage *tweetMessage = nil;
    tweetMessage = [[DataStore sharedStore] searchForTweetWithId:tweet.tid];
    if (!tweetMessage) {
        tweetMessage = [[self class] newTweetMessage];
        [tweetMessage updateWithTweet:tweet];
    }
    return tweetMessage;
}

- (UIColor *)fillColorForImages
{
    UIColor *_fillColor = [NSKeyedUnarchiver unarchiveObjectWithData:self.fillColor];
    return _fillColor;
}

- (UIImage *)placeholderImage
{
    UIImage *_image = [NSKeyedUnarchiver unarchiveObjectWithData:self.defaultTweetImage];
    return _image;
}

- (void)updateWithTweet:(PoliticalTweet *)tweet
{
    self.tid = tweet.tid;
    self.username = tweet.username;
    self.text = tweet.text;
    self.likeCount = @(tweet.likeCount);
    self.rtCount = @(tweet.rtCount);
    self.date = tweet.date;
    self.tweetImageURL = [tweet.tweetImageURL absoluteString];
    self.fillColor = [NSKeyedArchiver archivedDataWithRootObject:tweet.fillColor];
    self.retweeted = @(tweet.retweeted);
    self.liked = @(tweet.liked);
    self.partyIntent = @(tweet.partyIntent);
    self.partySource = @(tweet.partySource);
    self.us_state = tweet.state;
    self.defaultTweetImage = [NSKeyedArchiver archivedDataWithRootObject:[tweet defaultTweetImage]];
}

//- (id) valueForUndefinedKey:(NSString *)key
//{
////    NSLog(@"Tried to find undefined key: %@", key);
//   return @"foo";
//} // valueForUndefinedKey
@end
