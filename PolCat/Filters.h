//
//  Filters.h
//  PolCat
//
//  Created by Martin Stoufer on 5/30/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Utility.h"

@interface Filters : NSObject

+(instancetype)sharedFilters;

-(void)setStates:(NSArray <NSString *> *)us_states;
-(NSMutableDictionary <NSString *, id> *)allStates;
-(NSArray <NSString *> *)filteredStates;
-(NSArray <NSString *> *)excludedStates;

-(void)setParties:(NSArray <NSString *> *)parties;
-(NSDictionary <NSString *, NSNumber *> *)parties;
-(NSArray <NSNumber *> *)excludedParties;

-(void)setKeywords:(NSArray <NSString *> *)keywords forParty:(Party)party;
-(NSMutableDictionary <NSString *, NSNumber *> *)allKeywordsForParty:(Party)party;
-(NSArray<NSString *> *)filteredKeywordsForParty:(Party)party;
-(NSArray <NSString *> *)excludedKeywordsForParty:(Party)party;

-(void)updateStates:(NSDictionary <NSString *, NSNumber *> *)us_states;
-(void)updateSelectedParties:(NSDictionary <NSString *, NSNumber *> *)parties;
-(void)updateKeywords:(NSDictionary <NSString *, NSNumber *> *)keywords forParty:(Party)party;

-(NSPredicate *)filteredPredicate;
 

- (void)togglePartyFilter:(Party)party state:(BOOL)state;
- (BOOL)stateForPartyFilter:(Party)party;
@end
