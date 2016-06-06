//
//  PoliticalTweet.h
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "Tweet.h"
#import "PoliticalTweetStream.h"
/**
 *  @brief A Tweet sublclass to capture tweet politic-properties.
 */
@interface PoliticalTweet : Tweet

/**
 *  @brief Some general party affilication that best aligns with the intent of the tweet. Not who posted it.
 */
@property (nonatomic, assign) Party partyIntent;
@property (nonatomic, assign) Party partySource;
/**
 *  @brief If the tweet mentioned a state, we extract that during the first
 *          time this tweet is displayed and save it here.
 */
@property (nonatomic, strong) NSString *state;

@end
