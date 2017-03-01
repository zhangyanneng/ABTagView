//
//  ABTagView.m
//  anbang_ios
//
//  Created by zyn on 2017/2/28.
//  Copyright © 2017年 ch. All rights reserved.
//

#import "ABTagView.h"

@interface ABTagView()
{
    CGFloat _lastWidth; //记录最新宽作为x
    CGFloat _lastHeight; //记录最新高作为y
    UIButton *_tmpBtn;
    UIEdgeInsets _insets; //记录button的内边距
    
}

@property (nonatomic, assign) CGFloat hMargin; //水平间距

@property (nonatomic, assign) CGFloat vMargin; //竖直间距

@property (nonatomic,strong) NSMutableArray *buttonArray; //保存创建的按钮

@property (nonatomic, assign) CGFloat maxWidth;

@property (nonatomic, assign) CGFloat maxHeight;


@end

@implementation ABTagView

- (void)setupUIForDataSource {
    
    //进行默认设置
    [self setDefualtConfig];
    
    NSInteger numbers = [self.dataSource numberOfTagView:self];
    
    for (NSUInteger i = 0; i < numbers; i++) {
        
        UIButton *button = [self.dataSource tagView:self tagForIndex:i];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [button setAdjustsImageWhenHighlighted:NO]; //取消高亮状态
        
        [button titleColorForState:UIControlStateSelected];
        
        [button setTitleColor: [button titleColorForState:UIControlStateSelected] forState:UIControlStateHighlighted];
        
        [self addSubview:button];
        [self.buttonArray addObject:button];

        if (button.titleEdgeInsets.top || button.titleEdgeInsets.left
            || button.titleEdgeInsets.bottom || button.titleEdgeInsets.right) {
            _insets = button.titleEdgeInsets;
        } else {
            _insets = UIEdgeInsetsMake(5, 10, 5, 10);
        }
        
        //设置frame
        CGFloat x = _lastWidth;
        CGFloat y = _lastHeight;
        
        CGSize size = [self stringSizeFrom:button.titleLabel.text withFont:button.titleLabel.font maxWidth:self.maxWidth];
        
        CGFloat width = size.width + _insets.left + _insets.right;
        CGFloat height = size.height + _insets.top + _insets.bottom;

        
        if (self.alignment == TAG_ALIGNMENT_LEFT) {
            
            if (i == 0) {
                _lastWidth  = 0 + _hMargin;
                _lastHeight = 0 + _vMargin;
                x = _lastWidth;
                y = _lastHeight;
            }
            
            if ((x + width + _hMargin) < self.maxWidth) {
                
                _lastWidth = x + width + _hMargin;
                _lastHeight = y;
            } else if((x + width + _hMargin) > self.maxWidth) {
                x = _hMargin;
                y += height + _vMargin;
                
                _lastWidth = _hMargin + width + _hMargin;
                _lastHeight = y;
            } else {
                
                _lastWidth = _hMargin;
                _lastHeight = y + height + _vMargin;
            }
        } else {
            //右对齐方式
            if (i == 0) {
                _lastWidth  = self.maxWidth;
                _lastHeight = 0 + _vMargin;
                x = _lastWidth;
                y = _lastHeight;
            }
            
            if ((x - width - _hMargin) > 0) {
                x = x - width - _hMargin;
                
                _lastWidth = x;
                _lastHeight = y;
            } else if((x - width - _hMargin) < 0) {
                x = self.maxWidth - width - _hMargin;
                y += height + _vMargin;
                
                _lastWidth = x;
                _lastHeight = y;
            } else {
                
                _lastWidth = _hMargin;
                _lastHeight = y + height + _vMargin;
            }
        }
        //赋值frame
        button.frame = CGRectMake(x, y, width, height);
        
    }
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

    if([self.delegate respondsToSelector:@selector(tagView:didSelectForIndex:)]) {
        [self.delegate tagView:self didSelectForIndex:sender.tag];
    }
    
}

#pragma mark - 外界调用的方法
- (void)setHorizontalMargin:(CGFloat)hMargin verticalityMargin:(CGFloat)vMargin {
    
    [self setEdgeInsets:UIEdgeInsetsMake(vMargin, hMargin, vMargin, hMargin) horizontalMargin:hMargin verticalityMargin:vMargin];
}

- (void)setEdgeInsets:(UIEdgeInsets)insets horizontalMargin:(CGFloat)hMargin verticalityMargin:(CGFloat)vMargin {
    self.hMargin = hMargin;
    self.vMargin = vMargin;
    
}

- (NSArray *)selectedTagDatas {
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (UIButton *button in self.buttonArray) {
        
        if (button.selected) {
            [tempArr addObject:@(button.tag)];
        }
    }
    return [tempArr copy];
}

- (void)reloadData {
    //移出子控件
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.buttonArray removeAllObjects];
    //设置新数据
    [self setupUIForDataSource];
}

- (NSArray *)allButtons {
    return [self.buttonArray copy];
}

#pragma mark - 私有方法
- (void)setDefualtConfig {
    //进行默认设置
    self.maxWidth  = self.bounds.size.width;
    self.maxHeight = self.bounds.size.height;
    
    self.hMargin  = self.hMargin ? self.hMargin : 10;
    self.vMargin  = self.vMargin ? self.vMargin : 10;
    
}

- (CGSize)stringSizeFrom:(NSString *)string withFont:(UIFont *)font maxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    CGSize maxSize = CGSizeMake(width, height);
    attr[NSFontAttributeName] = font;
    return [string boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
}

- (CGSize)stringSizeFrom:(NSString *)string withFont:(UIFont *)font maxWidth:(CGFloat)width {
    
    return [self stringSizeFrom:string withFont:font maxWidth:width maxHeight:MAXFLOAT];
}
#pragma mark - 懒加载数据模型

- (void)setDataSource:(id<ABTagViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self setupUIForDataSource];
}

- (NSMutableArray *)buttonArray {
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end


@implementation UIButton (ABTagButton)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    
    if (state == UIControlStateSelected) { //默认将高亮状态的背景和选中同色
         [self setBackgroundImage:[self imageWithColor:backgroundColor] forState:UIControlStateHighlighted];
    }
    
    [self setBackgroundImage:[self imageWithColor:backgroundColor] forState:state];
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

@end

