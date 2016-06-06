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

-(NSPredicate *)filteredPredicate
{
    NSMutableArray *filterPredicates = [NSMutableArray array];
    [filterPredicates addObject:[NSPredicate predicateWithFormat:@"NOT (us_state IN %@)",
                                 [self excludedStates]]];
    [filterPredicates addObject:[NSPredicate predicateWithFormat:@"NOT (partySource in %@)",
                                 [self excludedParties]]];
    
    NSCompoundPredicate *compoundFilterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:filterPredicates];
    
    return compoundFilterPredicate;
}

#pragma mark - States
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

-(NSMutableDictionary <NSString *, id> *)allStates
{
    return self.masterDict[kFilterStates];
}

-(NSArray <NSString *> *)filteredStates
{
    NSMutableDictionary *dict = [self.masterDict[kFilterStates] mutableCopy];
    [dict removeObjectsForKeys:[self excludedStates]];
    return [dict allKeys];
}

-(NSArray<NSString *> *)excludedStates
{
    NSMutableArray *mutArr = [NSMutableArray array];
    [self.masterDict[kFilterStates] enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key,
                                                                        NSNumber *_Nonnull obj,
                                                                        BOOL * _Nonnull stop) {
        if ( ![obj boolValue]) {
            [mutArr addObject:key];
        }
    }];
    return mutArr;
}

-(void)updateStates:(NSDictionary<NSString *,NSNumber *> *)us_states
{
    NSMutableDictionary *dict = self.masterDict[kFilterStates];
    [us_states enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                                   NSNumber * _Nonnull obj,
                                                   BOOL * _Nonnull stop) {
        [dict setObject:obj forKey:key];
    }];
    
    NSMutableDictionary *filters = [[UserDefaults standardUserDefaults] filterSettings][kFilterStates] = [dict copy];
    [[UserDefaults standardUserDefaults] setFilterSettings:filters];
}

#pragma mark - Parties
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

-(NSArray<NSNumber *> *)excludedParties
{
    return [[self.parties allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSNumber *_Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ![evaluatedObject boolValue];
    }]];
}

#pragma mark Keywords
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

-(NSMutableDictionary<NSString *,NSNumber *> *)allKeywordsForParty:(Party)party
{
    return self.masterDict[kFilterKeywords][stringForPartyEnum(party)];
}

-(NSArray<NSString *> *)filteredKeywordsForParty:(Party)party
{
    NSMutableDictionary *dict = [self.masterDict[kFilterKeywords][stringForPartyEnum(party)] mutableCopy];
    [dict removeObjectsForKeys:[self excludedKeywordsForParty:party]];
    return [dict allKeys];
}

-(NSArray<NSString *> *)excludedKeywordsForParty:(Party)party
{
    NSMutableArray *mutArr = [NSMutableArray array];
    [self.masterDict[kFilterKeywords][stringForPartyEnum(party)] enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSNumber *_Nonnull obj, BOOL * _Nonnull stop) {
        if ( ![obj boolValue]) {
            [mutArr addObject:key];
        }
    }];
    return mutArr;
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
@end
