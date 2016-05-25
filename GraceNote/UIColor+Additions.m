//  Created by Jay Marcyes on 11/4/14.

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (instancetype)colorWithRGBa:(int)red, ...
{
    va_list gba;
    va_start(gba, red);
    
    double green = (double)va_arg(gba, int);
    double blue = (double)va_arg(gba, int);
    double alpha = (double)va_arg(gba, int);
    va_end(gba);
    
    UIColor *color = [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:(alpha/255.0)];
    return color;
}


- (BOOL)isNonWhite
{
    CGFloat red1, green1, blue1, alpha1;
    CGFloat red2 = 1.0;
    CGFloat green2 = 1.0;
    CGFloat blue2 = 1.0;
    
    [self getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    return (red1 != red2 && green1 != green2 && blue1 != blue2);
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (UIColor *)colorWithFOKey:(NSString *)colorKey {
    return [self colorWithHexString:colorKey];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
