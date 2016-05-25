//
//  TweetDetailViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/20/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "TweetDetailViewController.h"
#import "UITextView+RoundedCorners.h"
#import "UIImage+OvalPortrait.h"
#import "NSDate+TimeAgo.h"
#import "AppDelegate.h"
#import "RoundedCornersButton.h"

@interface TweetDetailViewController ()

@property (nonatomic, weak) IBOutlet UIButton* backButton;
@property (nonatomic, weak) IBOutlet UIImageView *tweetImage;
@property (nonatomic, weak) IBOutlet RoundedCornersButton *likeButton;
@property (nonatomic, weak) IBOutlet RoundedCornersButton *retweetButton;
@property (nonatomic, weak) IBOutlet UITextView *tweetText;
@property (nonatomic, weak) IBOutlet UILabel *tweetPostDateLabel;
@end

@implementation TweetDetailViewController

-(void)viewDidLoad
{
    self.likeButton.borderColor = self.tweet.fillColor;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%lu", self.tweet.likeCount] forState:UIControlStateNormal];
    self.likeButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.likeButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.likeButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    self.retweetButton.borderColor = self.tweet.fillColor;
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%lu", self.tweet.rtCount] forState:UIControlStateNormal];
    
    self.tweetImage.image = [self.tweet defaultTweetImage];
    self.tweetText.text = self.tweet.text;
    [self.tweetText rounderCornersWithRadius:5.0 andColor:[self.tweet.fillColor CGColor]];
    self.tweetPostDateLabel.text = [NSString stringWithFormat:@"Posted %@", [[self.tweet.date timeAgo] lowercaseString]];
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
                                                     andStrokeColor:[self.tweet.fillColor CGColor]];
                    
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

-(IBAction)handleRetweetButtonAction:(id)sender
{
    if (self.tweet.retweeted) {
        [self raiseAlertDialogWithTitle:@"Oops!" andBody:@"You have already retweeted this tweet from PolCat or someplace else."];
        return;
    }
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            if (accounts.count > 0)
            {
                for (ACAccount *twitterAccount in accounts) {
                    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                   requestMethod:SLRequestMethodPOST
                                                                             URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json",self.tweet.tid]]
                                                                      parameters:nil];
                    [twitterRequest setAccount:twitterAccount];
                    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        if (!error) {
                            id result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            if (result[@"errors"]) {
                                if ([result[@"errors"][@"code"] integerValue] == 327) {
                                    [self raiseAlertDialogWithTitle:@"Oops!" andBody:result[@"errors"][@"message"]];
                                }
                                return;
                            }
                            self.tweet.rtCount = [result[@"retweet_count"] integerValue];
                            self.tweet.retweeted = YES;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.retweetButton setTitle:[NSString stringWithFormat:@"%lu", self.tweet.rtCount] forState:UIControlStateNormal];
                            });
                        } else {
                            NSLog(@"Failed to retweet %@: %@", self.tweet.tid, error.localizedDescription);
                        }
                    }];
                }
            } else {
                [self raiseNoAccountsAlertDialog];
            }
        } else {
            NSLog(@"Failed authorize: %@", error.localizedDescription);
        }
    }];
}

-(IBAction)handleLikeButtonAction:(id)sender
{
    if (self.tweet.liked) {
        [self raiseAlertDialogWithTitle:@"Oops!" andBody:@"You have already liked this tweet from PolCat or someplace else."];
        return;
    }
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            if (accounts.count > 0)
            {
                for (ACAccount *twitterAccount in accounts) {
                    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                   requestMethod:SLRequestMethodPOST
                                                                             URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/favorites/create.json?id=%@",self.tweet.tid]]
                                                                      parameters:nil];
                    [twitterRequest setAccount:twitterAccount];
                    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        if (!error) {
                            id result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            if (result[@"errors"]) {
                                if ([result[@"errors"][@"code"] integerValue] == 327) {
                                    [self raiseAlertDialogWithTitle:@"Oops!" andBody:result[@"errors"][@"message"]];
                                }
                                return;
                            }
                            self.tweet.likeCount++;
                            self.tweet.liked = YES;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.likeButton setTitle:[NSString stringWithFormat:@"%lu", self.tweet.likeCount] forState:UIControlStateNormal];
                            });
                        } else {
                            NSLog(@"Failed to like %@: %@", self.tweet.tid, error.localizedDescription);
                        }
                    }];
                }
            } else {
                [self raiseNoAccountsAlertDialog];
            }
        } else {
            NSLog(@"Failed authorize: %@", error.localizedDescription);
        }
    }];

}

-(void)raiseAlertDialogWithTitle:(NSString *)title andBody:(NSString *)body
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:body
                                                            preferredStyle:UIAlertControllerStyleAlert];
    // Just dismiss alert view.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)raiseNoAccountsAlertDialog
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                   message:@"PolCat cant' find your Twitter account. Please go into the Settings app and add your Twitter account. Return here once complete and try again."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
    }];
    // Just dismiss alert view.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

-(IBAction)handleDetailDismissAction:(id)sender
{
    [self performSegueWithIdentifier:@"TweetMasterUnwindSegue" sender:self];
}
@end
