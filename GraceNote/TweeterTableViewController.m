//
//  ViewController.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "TweeterTableViewController.h"
#import "TweeterTableViewCell.h"
#import "TweetDetailViewController.h"

@interface TweeterTableViewController ()

@property (nonatomic, strong) TweetStream* tweetStream;
@property (nonatomic, strong) UIRefreshControl *refresh;

@end

@implementation TweeterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Disconnect table loading until we have data.
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

-(void)refreshTable
{
    [self dispatchTableViewLoadWithCompletion:nil];
}

/**
 *  @brief Set the Tweet stream object that will supply the table with data to populate the cells with.
 *
 *  @param tweetStream         The new stream object. It is best to assume that there is nothing useful in the
 *                               stream at this point.
 *  @param streamCompleteBlock The block to execute once the stream has loaded its tweets from Twitter.
 */
-(void)setTweetStream:(TweetStream *)tweetStream withCompletion:(TweetStreamCompletionBlock)streamCompleteBlock
{
    _tweetStream = tweetStream;
    [self dispatchTableViewLoadWithCompletion:streamCompleteBlock];
}

-(void)dispatchTableViewLoadWithCompletion:(TweetStreamCompletionBlock)streamCompleteBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [self.tweetStream loadTweetsForStreamWithCompletion:^(BOOL complete) {
            // TODO: How to handle when the timeout to fetch all the tweets fires and return NO here?
            // Refire off loading, display alert message?
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!self.tableView.delegate) {
                    self.tableView.delegate = self;
                    self.tableView.dataSource = self;
                }
                
                if (streamCompleteBlock) {
                    streamCompleteBlock(complete);
                }
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            });
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     TweeterTableViewCell *cell = (TweeterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TweeterTableViewCell"];
    [cell configureCellWithTweetStream:self.tweetStream forIndex:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetStream.tweets.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [self.tweetStream objectInTweetsAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"TweetDetailPushSegue" sender:tweet];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TweetDetailPushSegue"]) {
        TweetDetailViewController *destination = (TweetDetailViewController *)segue.destinationViewController;
        destination.tweet = (Tweet *)sender;
        destination.tweetStream = self.tweetStream;
    }
}
@end
