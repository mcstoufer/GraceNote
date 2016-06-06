//
//  KeywordsFilterViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "KeywordsFilterViewController.h"
#import "KeywordCollectionViewCell.h"
#import "KeywordPartyHeaderView.h"
#import "Filters.h"

@interface KeywordsFilterViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collection;

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary <NSString *, NSNumber *> *> *keywordsDict;
//@property (nonatomic, strong) NSMutableDictionary <NSString *, NSNumber *> *selectDict;
@end

@implementation KeywordsFilterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.keywordsDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    self.keywordsDict[@"Democrat"] = [[Filters sharedFilters] allKeywordsForParty:PartyDemocrat];
    self.keywordsDict[@"Republican"] = [[Filters sharedFilters] allKeywordsForParty:PartyRepublican];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collection.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 5, 20, 5);
    collectionViewLayout.estimatedItemSize = CGSizeMake(1, 20);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.touched) {
        [[Filters sharedFilters] updateKeywords:self.keywordsDict[@"Democrat"] forParty:PartyDemocrat];
        [[Filters sharedFilters] updateKeywords:self.keywordsDict[@"Republican"] forParty:PartyRepublican];
        self.touched = NO;
    }
}

-(void)saveState
{
    if (self.touched) {
        [[Filters sharedFilters] updateKeywords:self.keywordsDict[@"Democrat"] forParty:PartyDemocrat];
        [[Filters sharedFilters] updateKeywords:self.keywordsDict[@"Republican"] forParty:PartyRepublican];
        self.touched = NO;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.keywordsDict allKeys].count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.keywordsDict[@"Democrat"].count;
    } else {
        return self.keywordsDict[@"Republican"].count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KeywordCollectionViewCell *cell = (KeywordCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"KeywordCell" forIndexPath:indexPath];
    
    NSString *key = (indexPath.section == 0 ? @"Democrat" : @"Republican");
    NSString *keyword = [[self.keywordsDict[key] allKeys] objectAtIndex:indexPath.row];
    BOOL selection = [self.keywordsDict[key][keyword] boolValue];
    [cell configureCellWithKeyword:keyword andSelection:selection];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = [UICollectionReusableView new];
    
    if (kind == UICollectionElementKindSectionHeader) {
        KeywordPartyHeaderView *headerView = (KeywordPartyHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KeywordHeaderView" forIndexPath:indexPath];
        NSString *title = (indexPath.section == 0 ? @"Democrat" : @"Republican");
        [headerView configureHeaderViewWithTitle:title];
        reusableview = headerView;
    }
    
    return reusableview;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.touched = YES;
    KeywordCollectionViewCell *cell = (KeywordCollectionViewCell *)[self.collection cellForItemAtIndexPath:indexPath];
    [cell toggleCheckState];
    NSString *key = (indexPath.section == 0 ? @"Democrat" : @"Republican");
    self.keywordsDict[key][cell.keyword.text] = @(cell.checked);
}
@end
