//
//  TweetDetailViewController.h
//  PolCat
//
//  Created by Martin Stoufer on 5/20/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetStream.h"

@interface TweetDetailViewController : UIViewController

@property (nonatomic, strong) TweetStream *tweetStream;

@property (nonatomic, strong) Tweet* tweet;

@end
