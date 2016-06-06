//
//  TweetMessage+CoreDataProperties.h
//  
//
//  Created by Martin Stoufer on 5/31/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TweetMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tid;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *likeCount;
@property (nullable, nonatomic, retain) NSNumber *rtCount;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *tweetImageURL;
@property (nullable, nonatomic, retain) NSData *fillColor;
@property (nullable, nonatomic, retain) NSNumber *retweeted;
@property (nullable, nonatomic, retain) NSNumber *liked;
@property (nullable, nonatomic, retain) NSNumber *partyIntent;
@property (nullable, nonatomic, retain) NSNumber *partySource;
@property (nullable, nonatomic, retain) NSString *us_state;
@property (nullable, nonatomic, retain) NSData *defaultTweetImage;

@end

NS_ASSUME_NONNULL_END
