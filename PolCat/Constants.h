//
//  Constants.h
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define kUnchecked @"w"
#define kChecked @"u"

typedef enum : NSUInteger {
    PartyDemocrat = 0,
    PartyRepublican,
    PartyOther,
    PartyUndefined
} Party;

#endif /* Constants_h */
