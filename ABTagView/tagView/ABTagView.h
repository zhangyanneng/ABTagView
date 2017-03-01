//
//  ABTagView.h
//  anbang_ios
//
//  Created by zyn on 2017/2/28.
//  Copyright © 2017年 ch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TAG_ALIGNMENT_LEFT,
    TAG_ALIGNMENT_RIGHT
} ABTagAlignment;


@interface UIButton (ABTagButton)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end


@class ABTagView;
@protocol ABTagViewDataSource <NSObject>

@required
- (NSInteger)numberOfTagView:(ABTagView *)tagView;

- (UIButton *)tagView:(ABTagView *)tagView tagForIndex:(NSInteger)index;

@end


@protocol ABTagViewDelegate <NSObject>

- (void)tagView:(ABTagView *)tagView didSelectForIndex:(NSInteger)index;


@end


@interface ABTagView : UIView

@property (nonatomic, weak) id<ABTagViewDelegate> delegate;

@property (nonatomic, weak) id<ABTagViewDataSource> dataSource;

@property (nonatomic, assign) BOOL multiSelect; //是否是多选，默认是单选

@property (nonatomic, assign) ABTagAlignment alignment; //对齐方式，默认左对齐


- (void)setHorizontalMargin:(CGFloat)hMargin verticalityMargin:(CGFloat)vMargin;

//- (void)setEdgeInsets:(UIEdgeInsets)insets horizontalMargin:(CGFloat)hMargin verticalityMargin:(CGFloat)vMargin;
/**
 返回选中的tag的index

 @return array
 */
- (NSArray *)selectedTagDatas;

/**
 刷新数据
 */
- (void)reloadData;

/**
 返回所有按钮

 @return @[]
 */
- (NSArray *)allButtons;

@end
