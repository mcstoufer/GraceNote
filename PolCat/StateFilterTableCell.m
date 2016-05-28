//
//  StateFilterTableCell.m
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "StateFilterTableCell.h"

@implementation StateFilterTableCell

-(void)toggleCheckState
{
    if (!self.checked) {
        [self checkState];
    } else {
        [self uncheckState];
    }
}

-(void)checkState
{
    self.checkboxLabel.text = kChecked;
    self.checkboxLabel.backgroundColor = [UIColor colorWithHexString:@"#48B093"];
    self.checked = !self.checked;
}

-(void)uncheckState
{
    self.checkboxLabel.text = kUnchecked;
    self.checkboxLabel.backgroundColor = [UIColor clearColor];
    self.checked = !self.checked;
}

-(void)configureWithStateValue:(NSString *)state withSelection:(BOOL)selected
{
    self.stateLabel.text = state;
    self.checked = selected;
    if (selected) {
        self.checkboxLabel.text = kChecked;
        self.checkboxLabel.backgroundColor = [UIColor colorWithHexString:@"#48B093"];
    } else {
        self.checkboxLabel.text = kUnchecked;
        self.checkboxLabel.backgroundColor = [UIColor clearColor];
    }
}
@end
