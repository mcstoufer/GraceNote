//
//  TweeterTableViewCell.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "TweeterTableViewCell.h"
#import "Tweet.h"

@implementation TweeterTableViewCell

/**
 *  @brief Configure a given (reused) table view cell subclass instance with a new set of information for displahy.
 *
 *  @param stream    The TweetStream subclass that will provide an access object to the info we need
 *  @param path      The upcoming index path this cell will be displayed at.
 */
-(void)configureCellWithTweetStream:(TweetStream *)stream forIndex:(NSIndexPath *)path
{
    Tweet *tweet = stream.tweets[path.row];
    
    self.tweetTitle.text = tweet.text;
    self.tweetImage.image = [UIImage imageNamed:@"Missing"];
    self.auxImage.image = nil;
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:tweet.date
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterMediumStyle];
    // Pull off loading of images from main thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        // A quick local lookup against tweet text. Result is cached in stream.
        UIImage *auxImage = [stream auxImageForTweet:tweet];
        
        /**
         *  @brief A more involved lookup that requires hitting the Flickr server (and possible OAuth prior)
         *
         *  @param image The image that the lookup resolved. May be nil.
         */
        [stream primaryImageForTweet:tweet withCompletion:^(UIImage *image) {
            // Once complete, re-dispatch on main thread so images can be set properly.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (image) {
                    self.tweetImage.image = image;
                }
                if (auxImage) {
                    self.auxImage.image = auxImage;
                }
                [self setNeedsLayout];
            });
        }];
    });
}

@end