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

NSString* abvForState(NSString *state)
{
    if([states() containsObject:state])
    {
        return states()[[states() indexOfObject:state]+1];
    }
    return nil;
}

NSArray *states()
{
    static NSArray *_states;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _states =@[@"Alabama", @"AL",
                   @"Alaska", @"AK",
                   @"Arizona", @"AZ",
                   @"Arkansas", @"AR",
                   @"California", @"CA",
                   @"Colorado", @"CO",
                   @"Connecticut", @"CT",
                   @"Delaware", @"DE",
                   @"Florida", @"FL",
                   @"Georgia", @"GA",
                   @"Hawaii", @"HI",
                   @"Idaho", @"ID",
                   @"Illinois", @"IL",
                   @"Indiana", @"IN",
                   @"Iowa", @"IA",
                   @"Kansas", @"KS",
                   @"Kentucky", @"KY",
                   @"Louisiana", @"LA",
                   @"Maine", @"ME",
                   @"Maryland", @"MD",
                   @"Massachusetts", @"MA",
                   @"Michigan", @"MI",
                   @"Minnesota", @"MN",
                   @"Mississippi", @"MS",
                   @"Missouri", @"MO",
                   @"Montana", @"MT",
                   @"Nebraska", @"NE",
                   @"Nevada", @"NV",
                   @"New Hampshire", @"NH",
                   @"New Jersey", @"NJ",
                   @"New Mexico", @"NM",
                   @"New York", @"NY",
                   @"North Carolina", @"NC",
                   @"North Dakota", @"ND",
                   @"Ohio", @"OH",
                   @"Oklahoma", @"OK",
                   @"Oregon", @"OR",
                   @"Pennsylvania", @"PA",
                   @"Rhode Island", @"RI",
                   @"South Carolina", @"SC",
                   @"South Dakota", @"SD",
                   @"Tennessee", @"TN",
                   @"Texas", @"TX",
                   @"Utah", @"UT",
                   @"Vermont", @"VT",
                   @"Virginia", @"VA",
                   @"Washington", @"WA",
                   @"West Virginia", @"WV",
                   @"Wisconsin", @"WI",
                   @"Wyoming", @"WY"];
    });
    return _states;
}

NSArray *statesOnly()
{
    static NSArray *_statesOnly;
    static dispatch_once_t statesOnlyToken;
    dispatch_once(&statesOnlyToken, ^{
        
        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:50];
        NSArray *__states = states();
        for (int x=0; x<__states.count; x+=2) {
            [mutArr addObject:__states[x]];
        }
        _statesOnly = [NSArray arrayWithArray:mutArr];
    });
    return _statesOnly;
}
