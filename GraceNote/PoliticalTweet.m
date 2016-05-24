//
//  PoliticalTweet.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "PoliticalTweet.h"

@implementation PoliticalTweet

+(instancetype)initTweetWithDict:(NSDictionary *)dict
{
    PoliticalTweet *tweet = [[super alloc] initTweetWithDict:dict];

    return tweet;
}

-(UIImage *)defaultTweetImage
{
    if (self.party != PartyUndefined) {
        return [UIImage imageNamed:[self partyAsString]];
    }
    return nil;
}

-(NSString *)partyAsString
{
    switch (self.party) {
        case PartyDemocrat:
            return @"Democrat";
            break;
            
        case PartyRepublican:
            return @"Republican";
            break;
            
        case PartyOther:
            return @"OtherParty";
            break;
            
        default:
            return @"undefined";
            break;
    }
}
@end
