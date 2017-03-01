//
//  NSString+TextSize.h
//

#import <UIKit/UIKit.h>

@interface NSString (TextSize)


/**
 根据字体，最大宽，高返回文本大小

 @param font 字体
 @param width width
 @param height height
 @return size
 */
- (CGSize)stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)width maxHeight:(CGFloat)height;

/**
 根据字体，最大宽返回文本大小
 @param font 字体
 @param width 最大宽
 @return size
 */
- (CGSize)stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)width;

/**
 根据字体返回文本的大小

 @param font 字体
 @return size
 */
- (CGSize)stringSizeWithFont:(UIFont *)font;



- (CGSize)sizeWithMaxSize:(CGSize)size withFont:(UIFont *)font;

@end
