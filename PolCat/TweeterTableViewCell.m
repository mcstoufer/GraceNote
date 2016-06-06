//
//  TweeterTableViewCell.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "TweeterTableViewCell.h"
#import "UIImage+OvalPortrait.h"
#import "PoliticalTweetStream.h"
#import "AppDelegate.h"

#define partyImagesMaxWidth 26.0

@interface TweeterTableViewCell ()

@property (nonatomic, strong) NSString *tid;

@end

@implementation TweeterTableViewCell

/**
 *  @brief Configure a given (reused) table view cell subclass instance with a new set of information for displahy.
 *
 *  @param stream    The TweetStream subclass that will provide an access object to the info we need
 *  @param path      The upcoming index path this cell will be displayed at.
 */
-(void)configureCellWithTweetMessage:(TweetMessage *)tweetMessage
{
    self.tweetTitle.text = tweetMessage.text;
    self.tweetImage.image = [UIImage imageNamed:@"Missing"];
    self.partySourceImage.image = nil;
    self.partyIntentImage.image = nil;
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:tweetMessage.date
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterMediumStyle];
    self.tid = tweetMessage.tid;
    
    // Pull off loading of images from main thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // A quick local lookup against tweet text. Result is cached in stream.
        UIImage *partySourceImage = [PoliticalTweetStream auxImageForTweetMessage:tweetMessage];
        
        UIImage *partyIntentImage;
        BOOL differentTargets = !([tweetMessage.partySource integerValue] == [tweetMessage.partyIntent integerValue]);
        if (differentTargets) {
            partyIntentImage = [PoliticalTweetStream partyIntentImageForTweetMessage:tweetMessage];
        }
        
        /* Check to see if the image for the state has been retrieved before and chached. Speeds up recall greatly.
         * If there is any completion block to execute once we have the image, execute it now.
         */
        if ([[AppDelegate sharedCache] objectForKey:tweetMessage.us_state]) {
            UIImage *img = [[AppDelegate sharedCache] objectForKey:tweetMessage.us_state];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.tid isEqualToString:tweetMessage.tid]) {
                    self.tweetImage.image = img;
                }
            });
        } else {
            /**
             *  @brief A more involved lookup that requires hitting the Flickr server (and possible OAuth prior)
             *
             *  @param image The image that the lookup resolved. May be nil.
             */
            [PoliticalTweetStream primaryImageForTweet:tweetMessage withCompletion:^(UIImage *image) {
                image = [image resizeWithSize:self.tweetImage.frame.size];
                // Once complete, re-dispatch on main thread so images can be set properly.
                if (image) {
                    [[AppDelegate sharedCache] setObject:image forKey:tweetMessage.us_state];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.tid isEqualToString:tweetMessage.tid]) {
                            self.tweetImage.image = image;
                        }
                    });
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.tid isEqualToString:tweetMessage.tid]) {
                [self populateSourceImage:partySourceImage withPartyIntentImage:partyIntentImage withDifferingTargets:differentTargets];
            }
        });
    });
}

-(void)populateSourceImage:(UIImage *)partySourceImage withPartyIntentImage:(UIImage *)partyIntentImage withDifferingTargets:(BOOL)differentTargets
{
    if (partySourceImage && !differentTargets) {
        self.partySourceImage.image = partySourceImage;
        self.partySourceImageWidthConstraint.constant = partyImagesMaxWidth;
        self.partyIntentImage.hidden = YES;
    } else {
        self.partySourceImageWidthConstraint.constant = partyImagesMaxWidth/2.0;
        self.partySourceImage.image = partySourceImage;
        self.partyIntentImage.image = partyIntentImage;
        self.partyIntentImage.hidden = NO;
    }
    [self layoutIfNeeded];
}
@end
