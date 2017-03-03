//
//  YNTagView.h
//  ABTagView
//
//  Created by zyn on 2017/3/2.
//  Copyright © 2017年 张艳能. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNTagView : UIView

/**
 *  tagView内部的内容间距，默认为 UIEdgeInsetsZero
 */
@property(nonatomic, assign) UIEdgeInsets padding;

/**
 *  item 的最小宽高，默认为 CGSizeZero，也即不限制。
 */
@property(nonatomic, assign) IBInspectable CGSize minimumItemSize;

/**
 *  item 的最大宽高，默认为 CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)，也即不限制
 */
@property(nonatomic, assign) IBInspectable CGSize maximumItemSize;

/**
 *  item 之间的间距，默认为 UIEdgeInsetsZero。
 *
 *  @warning 上、下、左、右四个边缘的 item 布局时不会考虑 itemMargins.left/bottom/left/right。
 */
@property(nonatomic, assign) UIEdgeInsets itemMargins;

/**
    是否支持多选，默认是单选
 */
@property (nonatomic, assign) BOOL multiSelect;

/**
    数据源，传入字符串数组
 */
@property (nonatomic,strong) NSArray<NSString *> *dataSources;


- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;

- (void)setTitileColor:(UIColor *)color selectedTitileColor:(UIColor *)selColor;

- (void)setBackgroundColor:(UIColor *)backgroundColor selectedBackgroundColor:(UIColor *)selectedColor;




@end
