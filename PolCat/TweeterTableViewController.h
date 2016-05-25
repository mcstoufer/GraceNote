//
//  ViewController.h
//  GraceNote
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetStream.h"

typedef void(^TweetStreamCompletionBlock)(BOOL complete);

@interface TweeterTableViewController <UITableViewDelegate, UITableViewDataSource> : UITableViewController


-(void)setTweetStream:(TweetStream *) tweetStream
       withCompletion:(TweetStreamCompletionBlock)complete;

@end

