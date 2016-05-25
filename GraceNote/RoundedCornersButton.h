//
// RoundedCornersButton.h
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface RoundedCornersButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end
