//
//  YNTagView.m
//  ABTagView
//
//  Created by zyn on 2017/3/2.
//  Copyright © 2017年 张艳能. All rights reserved.
//

#import "YNTagView.h"

@interface YNTagView()
{
    CGFloat _radius;
    CGFloat _borderWidth;
    UIFont  *_font;
    UIColor *_borderColor;
    UIColor *_titileColor;
    UIColor *_selTitileColor;
    UIColor *_backgroundColor;
    UIColor *_selBackgroundColor;
    
}
@property (nonatomic,strong) UIButton *tmpBtn;

@end

@implementation YNTagView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.padding = UIEdgeInsetsZero;
        self.minimumItemSize = CGSizeZero;
        self.maximumItemSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.itemMargins = UIEdgeInsetsZero;
    }
    return self;
}


- (CGSize)sizeThatFits:(CGSize)size {
    return [self layoutSubviewsWithSize:size shouldLayout:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutSubviewsWithSize:self.bounds.size shouldLayout:YES];
}

- (CGSize)layoutSubviewsWithSize:(CGSize)size shouldLayout:(BOOL)shouldLayout {
    NSArray<UIView *> *visibleItemViews = [self visibleSubviews];
    
    if (visibleItemViews.count == 0) {
        return CGSizeMake(self.padding.left + self.padding.right, self.padding.top + self.padding.bottom);
    }
    CGPoint itemViewOrigin = CGPointZero;
    if (self.alignment) {
        itemViewOrigin = CGPointMake(self.padding.left, self.padding.top);
    } else {
        itemViewOrigin = CGPointMake(size.width - self.padding.right, self.padding.top);
    }
    
    
    CGFloat currentRowMaxY = itemViewOrigin.y;
    
    for (NSInteger i = 0, l = visibleItemViews.count; i < l; i ++) {
        UIView *itemView = visibleItemViews[i];
        
        CGSize itemViewSize = [itemView sizeThatFits:CGSizeMake(self.maximumItemSize.width, self.maximumItemSize.height)];
        itemViewSize.width = fmaxf(self.minimumItemSize.width, itemViewSize.width);
        itemViewSize.height = fmaxf(self.minimumItemSize.height, itemViewSize.height);
        
        //左边
        if (self.alignment) {
            if (itemViewOrigin.x + self.itemMargins.left + itemViewSize.width > size.width - self.padding.right) {
                // 换行，左边第一个 item 是不考虑 itemMargins.left 的
                if (shouldLayout) {
                    itemView.frame = CGRectMake(self.padding.left, currentRowMaxY + self.itemMargins.top, itemViewSize.width, itemViewSize.height);
                }
                
                itemViewOrigin.x = self.padding.left + itemViewSize.width + self.itemMargins.right;
                itemViewOrigin.y = currentRowMaxY;
            } else {
                // 当前行放得下
                if (shouldLayout) {
                    itemView.frame = CGRectMake(itemViewOrigin.x + self.itemMargins.left, itemViewOrigin.y + self.itemMargins.top, itemViewSize.width, itemViewSize.height);
                }
                
                itemViewOrigin.x += self.itemMargins.left + self.itemMargins.right + itemViewSize.width;
            }
        } else {
            //右边
            if (itemViewOrigin.x - self.itemMargins.right - itemViewSize.width < self.padding.left) {
                // 换行，左边第一个 item 是不考虑 itemMargins.left 的
                CGFloat itemX =size.width - self.padding.right - itemViewSize.width - self.itemMargins.right;
                if (shouldLayout) {
                    itemView.frame = CGRectMake(itemX, currentRowMaxY + self.itemMargins.top, itemViewSize.width, itemViewSize.height);
                }
                
                itemViewOrigin.x = itemX;
                itemViewOrigin.y = currentRowMaxY;
            } else {
                // 当前行放得下
                if (shouldLayout) {
                    itemView.frame = CGRectMake(itemViewOrigin.x - itemViewSize.width - self.itemMargins.right, itemViewOrigin.y + self.itemMargins.top, itemViewSize.width, itemViewSize.height);
                }
                
                itemViewOrigin.x -= (self.itemMargins.right + itemViewSize.width);
            }
        }
        
        
        currentRowMaxY = fmaxf(currentRowMaxY, itemViewOrigin.y + self.itemMargins.top + self.itemMargins.bottom + itemViewSize.height);
    }
    
    // 最后一行不需要考虑 itemMarins.bottom，所以这里减掉
    currentRowMaxY -= self.itemMargins.bottom;
    
    CGSize resultSize = CGSizeMake(size.width, currentRowMaxY + self.padding.bottom);
    return resultSize;
}

- (NSArray<UIView *> *)visibleSubviews {
    NSMutableArray<UIView *> *visibleItemViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0, l = self.subviews.count; i < l; i++) {
        UIView *itemView = self.subviews[i];
        if (!itemView.hidden) {
            [visibleItemViews addObject:itemView];
        }
    }
    
    return visibleItemViews;
}

- (void)setupUIWithData:(NSArray *)array {
    //数据默认设置
    _font           = _font ? _font : [UIFont systemFontOfSize:12];
    _radius         = _radius ? _radius : 5.0f;
    _borderWidth    = _borderWidth ? _borderWidth : 1.0f;
    _borderColor    = _borderColor ? _borderColor : [UIColor grayColor];
    _titileColor    = _titileColor ? _titileColor : [UIColor blackColor];
    _selTitileColor = _selTitileColor ? _selTitileColor : [UIColor whiteColor];
    _backgroundColor= _backgroundColor ? _backgroundColor : [UIColor whiteColor];
    _selBackgroundColor = _selBackgroundColor ? _selBackgroundColor : [UIColor colorWithRed:0/255.0f green:204/255.0f blue:255/255.0f alpha:1.0];
    if (self.itemContentInsets.left == 0
        && self.itemContentInsets.right == 0
        && self.itemContentInsets.top == 0
        && self.itemContentInsets.bottom == 0) {
        self.itemContentInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    }
    
    //添加按钮
    for (NSString *title in array) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:_titileColor forState:UIControlStateNormal];
        [button setTitleColor:_selTitileColor forState:UIControlStateSelected];
        button.titleLabel.font = _font;
        button.layer.cornerRadius = _radius;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = _borderWidth;
        button.layer.borderColor = _borderColor.CGColor;
        button.contentEdgeInsets = self.itemContentInsets;
        
        [self setUIButton:button backgroundColor:_backgroundColor forState:UIControlStateNormal];
        [self setUIButton:button backgroundColor:_selBackgroundColor forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        [button setAdjustsImageWhenHighlighted:NO]; //取消高亮状态
        
        [button setTitleColor: [button titleColorForState:UIControlStateSelected] forState:UIControlStateHighlighted];
        
        [self addSubview:button];
    }
}

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
    _radius = radius;
    _borderWidth = borderWidth;
    _borderColor = color;
}

- (void)setFont:(UIFont *)font titileColor:(UIColor *)color selectedTitileColor:(UIColor *)selColor {
    _font = font;
    _titileColor = color;
    _selTitileColor = selColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor selectedBackgroundColor:(UIColor *)selectedColor {
    _backgroundColor = backgroundColor;
    _selBackgroundColor = selectedColor;
}

- (void)buttonClick:(UIButton *)sender {
    
    if (self.multiSelect) {
        sender.selected = !sender.selected;
    } else {
        if (_tmpBtn == nil){
            sender.selected = YES;
            _tmpBtn = sender;
        } else if (_tmpBtn !=nil && _tmpBtn == sender){
            if (sender.selected) {
                sender.selected = NO;
            } else {
                sender.selected = YES;
            }
        } else if (_tmpBtn!= sender && _tmpBtn!=nil){
            _tmpBtn.selected = NO;
            sender.selected = YES;
            _tmpBtn = sender;
        }
    }
    
}

- (void)setUIButton:(UIButton *)button backgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    
    if (state == UIControlStateSelected) { //默认将高亮状态的背景和选中同色
        [button setBackgroundImage:[self imageWithColor:backgroundColor] forState:UIControlStateHighlighted];
    }
    
    [button setBackgroundImage:[self imageWithColor:backgroundColor] forState:state];
}

- (NSArray<NSString *> *)getSelectedDataSources {
    
    NSArray<UIView *> *views =  [self visibleSubviews];
    
    NSMutableArray<NSString *> *tempArrM = [NSMutableArray arrayWithCapacity:self.dataSources.count];
    
    for (UIView *view in views) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.selected) {
                [tempArrM addObject:[button titleForState:UIControlStateNormal]];
            }
        }
    }
    
    return [tempArrM copy];
}


//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setDataSources:(NSArray<NSString *> *)dataSources {
    _dataSources = dataSources;
    
    [self setupUIWithData:dataSources];
}

@end
