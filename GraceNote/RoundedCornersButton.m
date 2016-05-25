//
//  RoundedCornersButton.m
//

#import "RoundedCornersButton.h"

@implementation RoundedCornersButton

- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.borderColor = [self.borderColor CGColor];
    self.layer.borderWidth = self.borderWidth;
    
    self.clipsToBounds = YES;
}

@end
