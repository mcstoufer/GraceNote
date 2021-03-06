
//  PoliticalTweetStream.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "PoliticalTweetStream.h"
#import "PoliticalTweet.h"
#import "NSString+Utility.h"
#import "FlickrKit.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Utility.h"
#import "Filters.h"
#import "DataStore.h"
#import "TweetMessage.h"

@interface PoliticalTweetStream ()

/**
 *  @brief A GCD group desinged to better handle the simultaneous lookup of user's twitter feeds.
 */
@property (nonatomic, strong) dispatch_group_t feedGroup;
/**
 *  @brief A compound predicate created to help identify the party affiliation of a given tweet. This adddresses hot Democratic keywords.
 */
@property (nonatomic, strong) NSCompoundPredicate *democratPredicate;
/**
 *  @brief A compound predicate created to help identify the party affiliation of a given tweet. This adddresses hot Republican keywords.
 */
@property (nonatomic, strong) NSCompoundPredicate *republicanPredicate;

@property (nonatomic, strong) NSMutableDictionary *lastTweetIDs;
@property (nonatomic, assign) NSUInteger lastTweetFetchCount;
@end


@implementation PoliticalTweetStream

static PoliticalTweetStream *_stream;

+(instancetype)sharedStream
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stream = [[self class] new];
    });
    return _stream;
}

/**
 *  @brief Initialize a Stream
 *
 *  @return A new instance of the stream. Various initial objects are setup to allow for later procecssing of 
 *           Twitter feeds.
 */
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.feedHandle = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:kConsumerKey
                                                          consumerSecret:kConsumerSec];
        self.feedGroup = dispatch_group_create();
        self.lastTweetIDs = [NSMutableDictionary dictionary];
        
        // Common trending democrat words
        NSMutableArray *predicates = [NSMutableArray new];
        for (NSString *keyword in [[Filters sharedFilters] filteredKeywordsForParty:PartyDemocrat]) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"self contains[cd] %@", keyword]];
        }
        self.democratPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
        
        // Common trending republican words. Rather small!
        [predicates removeAllObjects];
        for (NSString *keyword in [[Filters sharedFilters] filteredKeywordsForParty:PartyRepublican]) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"self contains[cd] %@", keyword]];
        }
        self.republicanPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    }
    
    return self;
}

/**
 *  @brief Load the recent tweets for a fixed set of Twitter users.
 *  @discussion Each tweet retrieval can be done in parallel here to speed things up.
 *
 *  @param complete The completion block to execute once all the feed retrievals are complete.
 *
 */
-(void)loadTweetsForStreamWithCompletion:(TweetFeedCompletionBlock)complete
{
    [self.feedHandle verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            for (NSString *username in self.usernames) {
                dispatch_group_enter(self.feedGroup);
                [self populateTweetsForUsername:username];
            }
            
            // 60 seconds in nanoseonds.
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 60 * 1e9);
            long success = dispatch_group_wait(self.feedGroup, timeout);
            
            if (complete) {
                complete(success == 0,
                         self.lastTweetFetchCount,
                         (success > 0 ? UIBackgroundFetchResultFailed : (self.lastTweetFetchCount > 0 ? UIBackgroundFetchResultNewData : UIBackgroundFetchResultNoData)));
                self.lastTweetFetchCount = 0;
            }
        });
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Failed to verify credentials: %@", error.localizedDescription);
        complete(NO, 0, UIBackgroundFetchResultFailed);
    }];
}

+(void)primaryImageForTweet:(TweetMessage *)tweet withCompletion:(FlickrImageCompletionBlock)complete
{
    NSString *state = tweet.us_state;
    if (state) {
        /*  Otherwise, we need to fire up a Flicker search and attempt to pull down something useful.
         *  Again, cache valid result and execute completion block with image.
         */
        FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
        search.text = tweet.text;
        search.tags = @"California";
        search.per_page = @"15";
        [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error) {
            if (response) {
                
                /* So unfortunate to have to hack this last bit. I was unable to find a reliable
                 *  query set of text & tags that would always bring back an image that was easily
                 *  identifiable for the state.
                 * We punt here and just do a straight lookup against a known set of URLs that bring
                 *  back a flag pic.
                 */
                //                        NSMutableArray *photoURLs = [NSMutableArray array];
                //                        for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                //                            NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmallSquare75 fromPhotoDictionary:photoDictionary];
                //                            [photoURLs addObject:url];
                //                        }
                // NOTE: A NSAppTransportSecurity exception was made in the Info.plist to allow this HTTP traffic.
                NSURL *flagUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.crwflags.com/art/states/%@75.gif", [[self stateAbbv:state] lowercaseString]]];
                
                NSData *flagData = [NSData dataWithContentsOfURL:flagUrl options:NSDataReadingMappedAlways error:nil];
                UIImage *flag = [UIImage imageWithData:flagData];

                if (complete) {
                    complete(flag);
                }
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                
                [[self topMostController] presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    /* If no state could be resolved, then we just leave the placeholder image in the cell. */
    else {
        if (complete) {
            complete(nil);
        }
    }
}

+ (UIViewController*)topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    //NSLog(@"Top View is: %@",NSStringFromClass([topController class]));
    return topController;
}

/**
 *  @brief Determine what the auxiliary image for the given cell should be.
 *  @discussion This is relaized as the 'party' most closely associated with the intent of the tweet.
 *
 *  @param tweet The highly charged political tweet we want to determine some party affiliation with.
 *
 *  @return An image reflecting the party affiliation if one could be found, or nil if one could not.
 */
+(UIImage *)auxImageForTweetMessage:(TweetMessage *)tweet
{
    if ([[AppDelegate sharedCache] objectForKey:tweet.text]) {
        return [[AppDelegate sharedCache] objectForKey:tweet.text];
    }
    
    UIImage *aux;
    switch ((Party)[tweet.partySource integerValue]) {
        case PartyDemocrat:
            aux= [UIImage imageNamed:@"Democrat"];
            break;
            
        case PartyRepublican:
            aux= [UIImage imageNamed:@"Republican"];
            break;
            
        case PartyOther:
            aux= [UIImage imageNamed:@"OtherParty"];
            break;
            
        default:
            break;
    }
    [[AppDelegate sharedCache] setObject:aux forKey:tweet.text];
    return aux;
}

+(UIImage *)partyIntentImageForTweetMessage:(TweetMessage *)tweet
{
    NSString *key = [NSString stringWithFormat:@"partyIntent_%@", tweet.partyIntent];
    if ([[AppDelegate sharedCache] objectForKey:key]) {
        return [[AppDelegate sharedCache] objectForKey:key];
    }
    
    UIImage *aux;
    switch ((Party)[tweet.partyIntent integerValue]) {
        case PartyDemocrat:
            aux= [UIImage imageNamed:@"Democrat"];
            break;
            
        case PartyRepublican:
            aux= [UIImage imageNamed:@"Republican"];
            break;
            
        case PartyOther:
            aux= [UIImage imageNamed:@"OtherParty"];
            break;
            
        default:
            break;
    }
    [[AppDelegate sharedCache] setObject:aux forKey:key];
    return aux;
}

/**
 *  @brief Attempt to derive the first mentioned state (either fullname or abbreviation) if it is there.
 *  @discussion If a state could be determined, we set the .state property in the tweet to this value for later
 *               caching purposes.
 *
 *  @param tweet The tweet to find a state in.
 *
 *  @return The state if one could be found, nil otherwie.
 */
-(NSString *)possibleStateFromTweet:(PoliticalTweet *)tweet
{
    if (tweet.state) {
        return tweet.state;
    }
    
    for (NSString *us_state in statesOnly()) {
        if ([tweet.text containsString:us_state]) {
            tweet.state = us_state;
            return us_state;
        }
    }
    return nil;
}

/**
 *  @brief Minor hack to resolve the state abbreviation given a state. This is only really used in the hack mentioned
 *   in the [primaryTargetForTweet:...] method. A +1 index offset is used against the static states array.
 *
 *  @param state The state to resolve the abbreviation against.
 *
 *  @return The state abbreviation. or nil if one could not be found. I.e., the state was invalid to begin with.
 */
+(NSString *)stateAbbv:(NSString *)state
{
    NSOrderedSet *_states = states();
    if (state.length == 2) {
        return state;
    }

    if ([_states containsObject:state]) {
        return _states[[_states indexOfObject:state]+1];
    }
    return nil;
}

/**
 *  @brief Derive a possible party affiliation for the given tweet.
 *  @discussion Using fixed compound predicates, we compare the tweet text against them to see if any of the 
 *               predicate values are present. If an affiliation can be derived, we set that value on the 
 *               .party property for later cached lookup. If multiple affiliations are found, the democratic 
 *               party is used. Because.
 *
 *  @param tweet The tweet used to pull some party affiliation out of.
 *
 *  @return A party affiliation or nil otherwise. This is possible if none of the compound predicates caused a
 *           hit.
 */
-(Party)possiblePartyIntentFromTweet:(PoliticalTweet *)tweet
{
    if (tweet.partyIntent) {
        return tweet.partyIntent;
    }
    
    NSArray *arr = @[tweet.text];
    NSArray *usr = @[tweet.username];
    // Scan text of tweet first to see if there is an obvious party affiliation mentioned.
    if (([arr filteredArrayUsingPredicate:self.democratPredicate].count +
         [usr filteredArrayUsingPredicate:self.democratPredicate].count) > 0) {
        tweet.partyIntent = PartyDemocrat;
        return PartyDemocrat;
    } else if (([arr filteredArrayUsingPredicate:self.republicanPredicate].count +
                [usr filteredArrayUsingPredicate:self.republicanPredicate].count) > 0) {
        tweet.partyIntent = PartyRepublican;
        return PartyRepublican;
    }
    
    tweet.partyIntent = PartyOther;
    return PartyOther;
}

-(Party)possiblePartySourceFromTweet:(PoliticalTweet *)tweet
{
    NSArray *usr = @[tweet.username];

    if (([usr filteredArrayUsingPredicate:self.democratPredicate].count) > 0) {
        tweet.partySource = PartyDemocrat;
        return PartyDemocrat;
    } else if (([usr filteredArrayUsingPredicate:self.republicanPredicate].count) > 0) {
        tweet.partySource = PartyRepublican;
        return PartyRepublican;
    }
    
    tweet.partySource = PartyOther;
    return PartyOther;
}

/**
 *  @brief A helper method to pull most recent tweets for a given user's Twitter feed and combine them into 
 *          one tweets list.
 *
 *  @param username The screename or user_id of the Twitter user we want to pull tweets from.
 */
-(void)populateTweetsForUsername:(NSString  *)username
{
    [self.feedHandle getUserTimelineWithScreenName:username
                                           sinceID:(self.lastTweetIDs[username] ?: nil)
                                             maxID:nil
                                             count:20
                                      successBlock:^(NSArray *statuses) {
                                          [self addRawTweetsToStream:statuses forUsername:username];
                                      } errorBlock:^(NSError *error) {
                                          [self handleTweetFetchError:error forUsername:username];
                                      }];
}

-(void)addRawTweetsToStream:(NSArray *)statuses forUsername:(NSString  *)username
{
    NSMutableArray <PoliticalTweet *> *mut_arr = [NSMutableArray array];
    for (NSDictionary *status in statuses) {
        PoliticalTweet *tweet = [[PoliticalTweet alloc] initTweetWithDict:status];
        tweet.partyIntent = [self possiblePartyIntentFromTweet:tweet];
        tweet.partySource = [self possiblePartySourceFromTweet:tweet];
        tweet.state = [self possibleStateFromTweet:tweet];
        [mut_arr addObject:tweet];
    }
    [[DataStore sharedStore] batchSaveTweetMessages:mut_arr];
    
    self.lastTweetIDs[username] = [mut_arr firstObject].tid;
    
    dispatch_group_leave(self.feedGroup);
}

-(void)handleTweetFetchError:(NSError *)error forUsername:(NSString *)username
{
    dispatch_group_leave(self.feedGroup);
    NSLog(@"Failed to get timeline for %@: %@", username, error.localizedDescription);
}
@end
