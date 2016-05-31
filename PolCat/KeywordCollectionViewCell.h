//
//  KeywordCollectionViewCell.h
//  PolCat
//
//  Created by Martin Stoufer on 5/28/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeywordCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, weak) IBOutlet UILabel *keyword;

-(void)configureCellWithKeyword:(NSString *)keyword andSelection:(BOOL)selected;
-(void)toggleCheckState;

@end
