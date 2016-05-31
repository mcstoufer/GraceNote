//
//  Utility.h
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#ifndef Utility_h
#define Utility_h

#import <Foundation/Foundation.h>
#import "Constants.h"

NSString* stringForPartyEnum(Party party);
/**
 *  @brief A helper list of states/abbreviations.
 */
NSArray* states();
NSArray* statesOnly();

NSString* abvForState(NSString *state);

#endif /* Utility_h */
