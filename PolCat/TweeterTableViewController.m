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
#import "DataStore.h"
#import "Filters.h"

@interface TweeterTableViewController ()

@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSTimer *fetchTimer;

@end

@implementation TweeterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [NSFetchedResultsController deleteCacheWithName:@"TweetMessages"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBackgroundNotification:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [self dispatchTableViewLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fetchTimer = [NSTimer scheduledTimerWithTimeInterval:15*60
                                                       target:self
                                                     selector:@selector(dispatchTableViewLoad)
                                                     userInfo:nil
                                                      repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshTable
{
    [self dispatchTableViewLoad];
}

-(void)handleBackgroundNotification:(NSNotification *)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dispatchTableViewLoad
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [self.tweetStream loadTweetsForStreamWithCompletion:^(BOOL complete) {
            // TODO: How to handle when the timeout to fetch all the tweets fires and return NO here?
            // Refire off loading, display alert message?
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.streamCompletionBlock) {
                    self.streamCompletionBlock(complete);
                    self.streamCompletionBlock = nil;
                }
                
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(TweeterTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TweetMessage *tweetMessage  = [_fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureCellWithTweetMessage:tweetMessage];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     TweeterTableViewCell *cell = (TweeterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TweeterTableViewCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetMessage *tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"TweetDetailPushSegue" sender:tweet];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TweetDetailPushSegue"]) {
        TweetDetailViewController *destination = (TweetDetailViewController *)segue.destinationViewController;
        destination.tweet = (TweetMessage *)sender;
        destination.tweetStream = self.tweetStream;
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    DataStore *dataStore = [DataStore sharedStore];    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TweetMessage"
                                              inManagedObjectContext:dataStore.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setPredicate:[[Filters sharedFilters] filteredPredicate]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:dataStore.mainUIManagedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:@"TweetMessages"];
    _fetchedResultsController.delegate = (id)self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"FRC lookup error %@\n%@", error.localizedDescription, [error userInfo]);
        //abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}@end
