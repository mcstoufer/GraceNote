//
//  Filters.m
//  PolCat
//
//  Created by Martin Stoufer on 5/30/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "Filters.h"
#import "UserDefaults.h"

@interface Filters ()

@property (nonatomic, strong) NSDictionary<NSString *, NSMutableDictionary <NSString *, id> *> *masterDict;

@end


@implementation Filters

+(instancetype)sharedFilters
{
    static Filters *_filters;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _filters = [Filters new];
    });
    return _filters;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.masterDict = @{kFilterStates : [NSMutableDictionary dictionary],
                            kFilterParties : [NSMutableDictionary dictionary],
                            kFilterKeywords : [NSMutableDictionary dictionary]};
    }
    return self;
}

-(void)setStates:(NSArray<NSString *> *)us_states
{
    NSMutableDictionary *dict = self.masterDict[kFilterStates];
    if (dict.count == 0) {
        for (NSString *us_state in us_states) {
            [dict setObject:@(YES) forKey:us_state];
        }
        
        NSMutableDictionary *filters = [[UserDefaults standardUserDefaults] filterSettings];
        filters[kFilterStates] = [dict copy];
        [[UserDefaults standardUserDefaults] setFilterSettings:filters];
    }
}

-(NSMutableDictionary <NSString *, id> *)states
{
    return self.masterDict[kFilterStates];
}

-(void)setParties:(NSArray<NSString *> *)parties
{
    NSMutableDictionary *dict = self.masterDict[kFilterParties];
    if (dict.count == 0) {
        for (NSString *party in parties) {
            [dict setObject:@(YES) forKey:party];
        }
        
        NSMutableDictionary *filters = [[UserDefaults standardUserDefaults] filterSettings];
        filters[kFilterParties] = [dict copy];
        [[UserDefaults standardUserDefaults] setFilterSettings:filters];
    }
}

-(NSDictionary<NSString *,NSNumber *> *)parties
{
    return self.masterDict[kFilterParties];
}

-(void)togglePartyFilter:(Party)party state:(BOOL)state
{
    NSString *key = stringForPartyEnum(party);
    NSMutableDictionary *dict = self.masterDict[kFilterParties];
    
    dict[key] = @(state);
    NSMutableDictionary *filters = [[UserDefaults standardUserDefaults] filterSettings][kFilterParties] = [dict copy];
    [[UserDefaults standardUserDefaults] setFilterSettings:filters];
}

-(BOOL)stateForPartyFilter:(Party)party
{
    NSString *key = stringForPartyEnum(party);
    NSMutableDictionary *dict = self.masterDict[kFilterParties];

    if (dict[key]) {
        return [dict[key] boolValue];
    } else {
        dict[key] = @(YES);
        NSMutableDictionary *filters = [[UserDefaults standardUserDefaults] filterSettings][kFilterParties] = [dict copy];
        [[UserDefaults standardUserDefaults] setFilterSettings:filters];

        return YES;
    }
}

-(void)setKeywords:(NSArray<NSString *> *)keywords forParty:(Party)party
{
    NSString *key = stringForPartyEnum(party);
    NSMutableDictionary *dict = self.masterDict[kFilterKeywords];

    if (!dict[key]) {
        dict[key] = [NSMutableDictionary dictionary];
    } else {
        [dict[key] removeAllObjects];
    }
    
    for (NSString *keyword in keywords) {
        [dict[key] setObject:@(YES) forKey:keyword];
    }
    
    NSMutableDictionary *filters = [[UserDefaults standardUserDefaults] filterSettings];
    NSMutableDictionary *keywordsFilter = filters[kFilterKeywords];
    
    if (keywordsFilter.count == 0) {
        filters[kFilterKeywords] = [NSMutableDictionary dictionary];
    } else {
        filters[kFilterKeywords] = [NSMutableDictionary dictionaryWithDictionary:filters[kFilterKeywords]];
    }
    if (!filters[kFilterKeywords][key]) {
        filters[kFilterKeywords][key] = [NSMutableDictionary dictionary];
    }
    filters[kFilterKeywords][key] = [dict[key] copy];
    [[UserDefaults standardUserDefaults] setFilterSettings:filters];
}

-(NSMutableDictionary<NSString *,NSNumber *> *)keywordsForParty:(Party)party
{
    return self.masterDict[kFilterKeywords][stringForPartyEnum(party)];
}

-(void)updateStates:(NSDictionary<NSString *,NSNumber *> *)us_states
{
    NSMutableDictionary *dict = self.masterDict[kFilterStates];
    [us_states enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        [dict setObject:obj forKey:key];
    }];
    
    NSMutableDictionary *filters = [[UserDefaults standardUserDefaults] filterSettings][kFilterStates] = [dict copy];
    [[UserDefaults standardUserDefaults] setFilterSettings:filters];
}

-(void)updateSelectedParties:(NSDictionary<NSString *,NSNumber *> *)parties
{
    NSMutableDictionary *dict = self.masterDict[kFilterParties];
    [parties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        [dict setObject:obj forKey:key];
    }];
    
    NSMutableDictionary *filters = [[UserDefaults standardUserDefaults] filterSettings];
    filters[kFilterParties] = [dict copy];
    [[UserDefaults standardUserDefaults] setFilterSettings:filters];
}

-(void)updateKeywords:(NSDictionary <NSString *, NSNumber *> *)keywords forParty:(Party)party
{
    NSString *key = stringForPartyEnum(party);
    NSMutableDictionary *dict = self.masterDict[kFilterKeywords];
    
    [keywords enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        [dict[key] setObject:obj forKey:key];
    }];
   
    NSMutableDictionary *filters = [[UserDefaults standardUserDefaults] filterSettings];
    NSMutableDictionary *keywordsFilter = [NSMutableDictionary dictionaryWithDictionary:filters[kFilterKeywords]];

    keywordsFilter[key] = [dict[key] copy];
    filters[kFilterKeywords] = keywordsFilter;
    [[UserDefaults standardUserDefaults] setFilterSettings:filters];
}

-(NSPredicate *)filteredPredicate
{
    NSMutableArray *filterPredicates = [NSMutableArray array];
    [filterPredicates addObject:[NSPredicate predicateWithFormat:@"NOT (us_state IN %@)", [self excludedStates]]];
    [filterPredicates addObject:[NSPredicate predicateWithFormat:@"NOT (party in %@)", [self excludedParties]]];
    [filterPredicates addObject:[NSPredicate predicateWithFormat:@"NOT (keywords in %@)", [self excludedKeywords]]];
    
    NSCompoundPredicate *compoundFilterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:filterPredicates];
    
    return compoundFilterPredicate;
}

-(NSArray<NSString *> *)excludedStates
{
    return @[];
}

-(NSArray<NSString *> *)excludedParties
{
    return @[];
}

-(NSArray<NSString *> *)excludedKeywords
{
    return @[];
}

/*
 
 -(void)toggleStateFilter:(NSString *)us_state state:(BOOL)state
 {
 [[NSUserDefaults standardUserDefaults] setBool:state forKey:us_state];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 
 -(void)toggleStateFilters:(NSDictionary <NSString *, NSNumber *> *)us_states
 {
 [us_states enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
 [[NSUserDefaults standardUserDefaults] setBool:[obj boolValue] forKey:key];
 }];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 
 -(BOOL)selectedState:(NSString *)us_state
 {
 if (![[NSUserDefaults standardUserDefaults] objectForKey:us_state]) {
 [self toggleStateFilter:us_state state:YES];
 return YES;
 }
 return [[[NSUserDefaults standardUserDefaults] objectForKey:us_state] boolValue];
 }
 
 -(void)setKeywords:(NSArray<NSString *> *)keywords forParty:(Party)party
 {
 NSString *key = [NSString stringWithFormat:@"%@_keywords", stringForPartyEnum(party)];
 [[NSUserDefaults standardUserDefaults] setObject:keywords forKey:key];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 
 -(NSArray<NSString *> *)keywordsForParty:(Party)party
 {
 NSString *key = [NSString stringWithFormat:@"%@_keywords", stringForPartyEnum(party)];
 return [[NSUserDefaults standardUserDefaults] objectForKey:key];
 }
 
 -(void)toggleKeywordFilters:(NSDictionary<NSString *,NSNumber *> *)keywords
 {
 [keywords enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
 [[NSUserDefaults standardUserDefaults] setBool:[obj boolValue] forKey:key];
 }];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 
 -(BOOL)selectedKeyword:(NSString *)keyword
 {
 if (![[NSUserDefaults standardUserDefaults] objectForKey:keyword]) {
 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:keyword];
 return YES;
 }
 return [[[NSUserDefaults standardUserDefaults] objectForKey:keyword] boolValue];
 }
 */
@end

