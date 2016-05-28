//
//  UIImage+OvalPortrait.m
//  PolCat
//
//  Created by Martin Stoufer on 5/23/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "UIImage+OvalPortrait.h"

@implementation UIImage (OvalPortrait)

-(UIImage *)ovalImageForRect:(CGRect)rect andStrokeColor:(CGColorRef)color
{
    CGRect imageRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Create the clipping path and add it
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:imageRect];
    [path addClip];
    [self drawInRect:imageRect];
    
    CGContextSetStrokeColorWithColor(ctx, color);
    [path setLineWidth:5.0f];
    [path stroke];
    
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

-(UIImage *)resizeWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
@end
