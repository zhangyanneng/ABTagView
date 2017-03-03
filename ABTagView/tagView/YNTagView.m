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
    
    CGPoint itemViewOrigin = CGPointMake(self.padding.left, self.padding.top);
    CGFloat currentRowMaxY = itemViewOrigin.y;
    
    for (NSInteger i = 0, l = visibleItemViews.count; i < l; i ++) {
        UIView *itemView = visibleItemViews[i];
        
        CGSize itemViewSize = [itemView sizeThatFits:CGSizeMake(self.maximumItemSize.width, self.maximumItemSize.height)];
        itemViewSize.width = fmaxf(self.minimumItemSize.width, itemViewSize.width);
        itemViewSize.height = fmaxf(self.minimumItemSize.height, itemViewSize.height);
        
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
    
    //添加按钮
    for (NSString *title in array) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        
        [self setUIButton:button backgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setUIButton:button backgroundColor:[UIColor greenColor] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        [button setAdjustsImageWhenHighlighted:NO]; //取消高亮状态
        
        [button setTitleColor: [button titleColorForState:UIControlStateSelected] forState:UIControlStateHighlighted];
        
        [self addSubview:button];
    }
}

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
    
}

- (void)setTitileColor:(UIColor *)color selectedTitileColor:(UIColor *)selColor {
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor selectedBackgroundColor:(UIColor *)selectedColor {
    
}


- (void)buttonClick:(UIButton *)sender {
    
//    if (self.multiSelect) {
//        sender.selected = !sender.selected;
//    } else {
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
//    }
    
}

- (void)setUIButton:(UIButton *)button backgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    
    if (state == UIControlStateSelected) { //默认将高亮状态的背景和选中同色
        [button setBackgroundImage:[self imageWithColor:backgroundColor] forState:UIControlStateHighlighted];
    }
    
    [button setBackgroundImage:[self imageWithColor:backgroundColor] forState:state];
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
