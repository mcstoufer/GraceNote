//
//  TweetDetailViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/20/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "TweetDetailViewController.h"
#import "UITextView+RoundedCorners.h"
#import "UIImage+OvalPortrait.h"
#import "NSDate+TimeAgo.h"
#import "AppDelegate.h"

@interface TweetDetailViewController ()

@property (nonatomic, weak) IBOutlet UIButton* backButton;
@property (nonatomic, weak) IBOutlet UIImageView *tweetImage;
@property (nonatomic, weak) IBOutlet UILabel *likeLabel;
@property (nonatomic, weak) IBOutlet UILabel *retweetLabel;
@property (nonatomic, weak) IBOutlet UITextView *tweetText;
@property (nonatomic, weak) IBOutlet UILabel *tweetPostDateLabel;
@end

@implementation TweetDetailViewController

-(void)viewDidLoad
{
    self.likeLabel.text = [NSString stringWithFormat:@"%lu", self.tweet.likeCount];
    self.retweetLabel.text = [NSString stringWithFormat:@"%lu", self.tweet.rtCount];
    self.tweetImage.image = [self.tweet defaultTweetImage];
    self.tweetText.text = self.tweet.text;
    [self.tweetText rounderCornersWithRadius:5.0 andColor:[[UIColor lightGrayColor] CGColor]];
    self.tweetPostDateLabel.text = [NSString stringWithFormat:@"Posted %@", [self.tweet.date timeAgo]];
}

-(void)viewWillAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        UIImage *roundedImage = [[AppDelegate sharedCache] objectForKey:self.tweet.tweetImageURL];
        if (roundedImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tweetImage.image = roundedImage;
            });
        } else {
            
            [self.tweetStream.feedHandle profileImageFor:self.tweet.username successBlock:^(id image) {
                if (image) {
                    
                    UIImage *roundedImage = [image ovalImageForRect:self.tweetImage.frame
                                                     andStrokeColor:[[UIColor greenColor] CGColor]];
                    
                    [[AppDelegate sharedCache] setObject:roundedImage forKey:self.tweet.tweetImageURL];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.tweetImage.image = roundedImage;
                    });
                }
            } errorBlock:^(NSError *error) {
                NSLog(@"Failed to retrieve profile image for %@: %@", self.tweet.username, error.localizedDescription);
            }];
        }
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(IBAction)handleDetailDismissAction:(id)sender
{
    [self performSegueWithIdentifier:@"TweetMasterUnwindSegue" sender:self];
}
@end
