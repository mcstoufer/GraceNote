//
//  KeywordCollectionViewCell.m
//  PolCat
//
//  Created by Martin Stoufer on 5/28/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "KeywordCollectionViewCell.h"
#import "Constants.h"
#import "UIColor+Additions.h"

@interface KeywordCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *checkbox;

@end

@implementation KeywordCollectionViewCell

-(void)awakeFromNib
{
    self.layer.cornerRadius = 5.0;
}

-(void)toggleCheckState
{
    (self.checked ? [self uncheckState] : [self checkState]);
}

-(void)configureCellWithKeyword:(NSString *)keyword andSelection:(BOOL)selected
{
    self.keyword.text = keyword;
    self.checked = selected;
    self.checkbox.text = (selected ? kChecked : kUnchecked);
    self.checkbox.backgroundColor = (selected ? [UIColor colorWithHexString:@"#48B093"] : [UIColor clearColor]);
}

-(void)checkState
{
    self.checkbox.text = kChecked;
    self.checkbox.backgroundColor = [UIColor colorWithHexString:@"#48B093"];
    self.checked = !self.checked;
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.backgroundColor = [UIColor clearColor];
    }];
}

-(void)uncheckState
{
    self.checkbox.text = kUnchecked;
    self.checkbox.backgroundColor = [UIColor clearColor];
    self.checked = !self.checked;
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.backgroundColor = [UIColor clearColor];
    }];
}

@end
