//
//  UITextView+RoundedCorners.m
//  PolCat
//
//  Created by Martin Stoufer on 5/23/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "UITextView+RoundedCorners.h"

@implementation UITextView (RoundedCorners)

-(void)rounderCornersWithRadius:(CGFloat)radius andColor:(CGColorRef)color
{
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.70];
    self.layer.borderColor = color;
    self.layer.borderWidth = 2.0;
    self.layer.cornerRadius = radius;
    [self setClipsToBounds:YES];
}
@end
