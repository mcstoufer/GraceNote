//
//  StateFilterTableCell.h
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Additions.h"

@interface StateFilterTableCell : UITableViewCell

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, weak) IBOutlet UILabel *checkboxLabel;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;

-(void)toggleCheckState;
-(void)configureWithStateValue:(NSString *)state withSelection:(BOOL)selected;
-(void)checkState;
-(void)uncheckState;
@end
