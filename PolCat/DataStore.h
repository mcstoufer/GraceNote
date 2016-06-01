//
//  DataStore.h
//  PolCat
//
//  Created by Martin Stoufer on 5/31/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetMessage.h"

@interface DataStore : NSObject

#pragma mark - CORE DATA STACK
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext  *mainUIManagedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(DataStore *)sharedStore;
- (void)saveContext;

- (void)batchSaveTweetMessages:(NSArray <PoliticalTweet *> *)tweets;

- (NSArray <TweetMessage *> *)searchForTweetsWithFilteredConstraints;
-(TweetMessage *)searchForTweetWithId:(NSString *)tid;
- (void)clearTweets;
@end
