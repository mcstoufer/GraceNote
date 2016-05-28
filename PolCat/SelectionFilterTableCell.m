//
//  SelectionFilterTableCell.m
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "SelectionFilterTableCell.h"

@implementation SelectionFilterTableCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.checked = YES;
    [self configureWithSelectionState];
}

-(void)toggleSelectionState
{
    if (!self.checked) {
        [self checkState];
        self.stateLabel.text = @"Deselect all";
    } else {
        [self uncheckState];
        self.stateLabel.text = @"Select all";
    }
}
-(void)configureWithSelectionState
{
    if (self.checked) {
        self.checkboxLabel.text = kChecked;
        self.checkboxLabel.backgroundColor = [UIColor colorWithHexString:@"#48B093"];
        self.stateLabel.text = @"Deselect all";
    } else {
        self.checkboxLabel.text = kUnchecked;
        self.checkboxLabel.backgroundColor = [UIColor clearColor];
        self.stateLabel.text = @"Select all";
        
    }
}

@end
