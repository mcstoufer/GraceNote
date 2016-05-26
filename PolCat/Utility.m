//
//  Utility.m
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//
#import "Utility.h"

NSString* stringForPartyEnum(Party party)
{
    switch (party) {
        case PartyDemocrat:
            return @"Democrat";
            break;
        
        case PartyRepublican:
            return @"Republican";
            break;
            
        case PartyOther:
            return @"Other";
            break;
            
        default:
            return @"";
            break;
    }
}
