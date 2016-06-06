//
//  PoliticalTweetStream.h
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "TweetStream.h"
#import "Constants.h"

#define kConsumerKey @"cND1ya5iTTH1wJOKMy1QU6MGq"
#define kConsumerSec @"0BNgErrNsTxtC6BwURFDEmuVskVXoRs3ENi2Za2SIpz2h5pwaf"

/**
 *  @brief A TweetStream subclass designed to implement base methods so that they are more closely able to track politic based tweets.
 */
@interface PoliticalTweetStream: TweetStream

+(UIImage *)partyIntentImageForTweetMessage:(TweetMessage *)tweet;

@end
