//
//  DataStore.m
//  PolCat
//
//  Created by Martin Stoufer on 5/31/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "DataStore.h"
#import "Filters.h"

@interface DataStore ()

@property (nonatomic, strong)dispatch_queue_t saveQueue;

@end

@implementation DataStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize mainUIManagedObjectContext = _mainUIManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (DataStore *)sharedStore {
    static DataStore *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DataStore alloc] init];
        _sharedClient.saveQueue = dispatch_queue_create("com.polcat.datastore.tweet_queue", DISPATCH_QUEUE_SERIAL);
        NSLog(@"Created %@ singleton", [self class]);
    });
    
    return _sharedClient;
}

-(id)searchForTweetWithId:(NSString *)tid
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"TweetMessage" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"tid == %@", tid];
    request.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array.count > 0) {
        return [array firstObject];
    }
    return nil;
}

- (NSArray <TweetMessage *> *)searchForTweetsWithFilteredConstraints
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"TweetMessage" inManagedObjectContext:self.managedObjectContext];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]];
    
    request.predicate = [[Filters sharedFilters] filteredPredicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array.count > 0) {
        return [array firstObject];
    }
    return nil;
}

-(void)batchSaveTweetMessages:(NSArray<PoliticalTweet *> *)tweets
{
    dispatch_async(self.saveQueue, ^{
        for (PoliticalTweet *tweet in tweets) {
            [TweetMessage tweetMessageFromTweet:tweet]; // Ignore return value.
        }
        [self saveContext];
    });
}

- (void)saveContext
{
    NSLog(@"Hit saveContext");
    dispatch_async(self.saveQueue, ^{
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Error in saving changes to core data model:%@,\n%@", error.localizedDescription, [error userInfo]);
                abort();
            }
        }
    });
}

- (void)clearTweets
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *deleteError;
    [self.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
    if (deleteError) {
        NSLog(@"Error in removing Tweet entities: %@", deleteError.localizedDescription);
    }
    [self saveContext];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectContext *)mainUIManagedObjectContext
{
    if (!_mainUIManagedObjectContext) {
        
        // Setup MOC attached to parent privateMOC in main queue
        _mainUIManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainUIManagedObjectContext setParentContext:[[DataStore sharedStore] managedObjectContext]];
        
        // Add notification to perform save when the child is updated
//        _mainUIContextSaveObserver =
//        [[NSNotificationCenter defaultCenter]
//         addObserverForName:NSManagedObjectContextDidSaveNotification
//         object:nil
//         queue:nil
//         usingBlock:^(NSNotification *note) {
//             NSManagedObjectContext *savedContext = [note object];
//             if (savedContext.parentContext == _mainUIManagedObjectContext) {
//                 NSLog(@"AMBCoreData -> saving mainUIMOC");
//                 [_mainUIManagedObjectContext performBlock:^{
//                     NSError *error;
//                     if (![_mainUIManagedObjectContext save:&error]) {
//                         NSLog(@"AMBCoreData -> error saving mainUIMOC: %@ %@", [error localizedDescription], [error userInfo]);
//                     }
//                 }];
//             }
//         }];
    }
    return _mainUIManagedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TweetModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
    
    //if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Failed to create PSC: %@\n%@", error.localizedDescription, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
