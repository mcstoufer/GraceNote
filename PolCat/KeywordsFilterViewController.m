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
#import "UserDefaults.h"

@interface KeywordsFilterViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collection;

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSArray *> *keywordsDict;

@end

@implementation KeywordsFilterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.keywordsDict = [NSMutableDictionary dictionaryWithCapacity:2];
    self.keywordsDict[@"Democrat"] = [[UserDefaults standardUserDefaults] keywordsForParty:PartyDemocrat];
    self.keywordsDict[@"Republican"] = [[UserDefaults standardUserDefaults] keywordsForParty:PartyRepublican];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collection.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 5, 20, 5);
    collectionViewLayout.estimatedItemSize = CGSizeMake(1, 20);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
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
    [cell configureCellWithKeyword:[self.keywordsDict[key] objectAtIndex:indexPath.row] andSelection:YES];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
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
    KeywordCollectionViewCell *cell = (KeywordCollectionViewCell *)[self.collection cellForItemAtIndexPath:indexPath];
    [cell toggleCheckState];
}
@end
