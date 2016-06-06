//
//  TweetImageView.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/18/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "TweetImageView.h"

@implementation TweetImageView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.layer setCornerRadius:10.0];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:2.0];
    [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}
@end
