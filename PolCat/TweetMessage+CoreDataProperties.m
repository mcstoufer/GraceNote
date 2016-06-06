//
//  TweetMessage+CoreDataProperties.m
//  
//
//  Created by Martin Stoufer on 5/31/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TweetMessage+CoreDataProperties.h"

@implementation TweetMessage (CoreDataProperties)

@dynamic tid;
@dynamic username;
@dynamic text;
@dynamic likeCount;
@dynamic rtCount;
@dynamic date;
@dynamic tweetImageURL;
@dynamic fillColor;
@dynamic retweeted;
@dynamic liked;
@dynamic partyIntent;
@dynamic partySource;
@dynamic us_state;
@dynamic defaultTweetImage;

@end
