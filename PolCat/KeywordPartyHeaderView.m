//
//  KeywordPartyHeaderView.m
//  PolCat
//
//  Created by Martin Stoufer on 5/28/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "KeywordPartyHeaderView.h"

@interface KeywordPartyHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *header;

@end

@implementation KeywordPartyHeaderView

-(void)configureHeaderViewWithTitle:(NSString *)title
{
    self.header.text = title;
}
@end
