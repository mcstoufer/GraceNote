//
//  TweeterTableViewController.h
//  PolCat
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

#import "TweetStream.h"

typedef void(^TweetStreamCompletionBlock)(BOOL complete);

@interface TweeterTableViewController <UITableViewDelegate, UITableViewDataSource> : UITableViewController

@property (nonatomic, strong) TweetStream* tweetStream;
@property (nonatomic, strong) TweetStreamCompletionBlock streamCompletionBlock;

-(void)updateFetchedResultsFromFilterChange;

@end

