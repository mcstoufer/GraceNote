//  Created by Jay Marcyes on 11/4/14.

@import UIKit;

/**
 *  provides enhancements to the standard UIColor
 *
 *  @see http://weblog.highorderbit.com/post/11656225202/appropriate-use-of-c-macros-for-objective-c-developers
 *  @see UIColor
 */
@interface UIColor (Additions)

/**
 *  just makes it easier to create a color
 *
 *  @see https://developer.apple.com/library/mac/qa/qa1405/_index.html
 *  @see http://www.cprogramming.com/tutorial/c/lesson17.html
 *  @param values R, G, B, a as integers between 0-255, (eg 140, 140, 139, 50)
 *
 *  @return UIColor instance
 */
+ (instancetype)colorWithRGBa:(int) values, ...;

/**
 *  return True if the color is not white
 *
 *  @see http://stackoverflow.com/questions/970475/how-to-compare-uicolors
 *
 *  @return boolean
 */
- (BOOL)isNonWhite;

/**
 *  @brief Convert a string representation of a Hex color code into a UIColor reference.
 *  @discussion The following combinations are supported:
 *  @code
 *  - #AARRGGBB
 *  - #ARGB
 *  - #RRGGBB
 *  - #RGB
 *  @endcode
 *  An alpha of 1.0 is assumed if not provided.
 *
 *  @param hexString A string representing a hex color.
 *  @return A valid UIColor reference if the string provided was properly formatted. Nil otherwise.
 */
+ (UIColor *) colorWithHexString: (NSString *) hexString;

/**
 *  Convert a string constant refering to a Hex color code into a UIColor reference.
 *
 *  @param colorKey A string constant refereing a hex color code.
 *
 *  @see [colorWithHexString:]
 *
 *  @return A valid UIColor reference if the string key was valid. Nil otherwise.
 */
+ (UIColor *)colorWithFOKey:(NSString *)colorKey;
@end
