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
-(NSMutableDictionary <NSString *, id> *)states;
-(NSArray <NSString *> *)excludedStates;

-(void)setParties:(NSArray <NSString *> *)parties;
-(NSDictionary <NSString *, NSNumber *> *)parties;
-(NSArray <NSString *> *)excludedParties;

-(void)setKeywords:(NSArray <NSString *> *)keywords forParty:(Party)party;
-(NSMutableDictionary <NSString *, NSNumber *> *)keywordsForParty:(Party)party;
-(NSArray <NSString *> *)excludedKeywords;

-(void)updateStates:(NSDictionary <NSString *, NSNumber *> *)us_states;
-(void)updateSelectedParties:(NSDictionary <NSString *, NSNumber *> *)parties;
-(void)updateKeywords:(NSDictionary <NSString *, NSNumber *> *)keywords forParty:(Party)party;

-(NSPredicate *)filteredPredicate;
 

- (void)togglePartyFilter:(Party)party state:(BOOL)state;
- (BOOL)stateForPartyFilter:(Party)party;
  /*
 - (void)toggleStateFilter:(NSString *)us_state state:(BOOL)state;
 - (void)toggleStateFilters:(NSDictionary <NSString *, NSNumber *> *)us_states;
 - (BOOL)selectedState:(NSString *)us_state;
 
 - (void)setKeywords:(NSArray <NSString *> *)keywords forParty:(Party)party;
 
 - (NSArray <NSString *> *)keywordsForParty:(Party)party;
 
 - (void)toggleKeywordFilters:(NSDictionary <NSString *, NSNumber *> *)keywords;
 -(BOOL)selectedKeyword:(NSString *)keyword;
 */

@end
