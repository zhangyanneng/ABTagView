//
//  ViewController.m
//  ABTagView
//
//  Created by zyn on 2017/2/28.
//  Copyright © 2017年 张艳能. All rights reserved.
//

#import "ViewController.h"
#import "ABTagView.h"
#import "YNTagView.h"

@interface ViewController ()<ABTagViewDataSource,ABTagViewDelegate>


@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) ABTagView *tagView;

@property (nonatomic, weak) YNTagView *yntagView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *arr = @[@"职场",@"产品经理",@"JAVA开发工程师",@"iOS开发工程师",@"H5开发工程师",@"邦邦在线",@"架构师",@"Android工程师",@"职场",@"产品经理",@"JAVA开发工程师",@"职场",@"产品经理",@"职场",@"产品经理"];
    
    //第二种方式
    YNTagView *ynTagView = [[YNTagView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 300)];
    ynTagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    ynTagView.minimumItemSize = CGSizeMake(40, 24);
    ynTagView.itemMargins =  UIEdgeInsetsMake(0, 0, 10, 10);
    ynTagView.dataSources = arr;
    ynTagView.alignment = 0;
    ynTagView.multiSelect = YES;
    [self.view addSubview:ynTagView];
    self.yntagView = ynTagView;
    
    
//    for (NSString *title in arr) {
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [button setTitle:title forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor greenColor] forState:UIControlStateSelected];
//        button.titleLabel.font = [UIFont systemFontOfSize:12];
//        button.layer.cornerRadius = 5;
//        button.layer.masksToBounds = YES;
//        button.layer.borderWidth = 1;
//        button.layer.borderColor = [UIColor grayColor].CGColor;
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
//        [ynTagView addSubview:button];
//        
//        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //第一种方式
    self.array = [NSMutableArray arrayWithArray:arr];
    
    self.tagView = [[ABTagView alloc] init];
    self.tagView.frame = CGRectMake(0, 200, self.view.bounds.size.width, 500);
    self.tagView.multiSelect = NO; //支持多选
    self.tagView.dataSource = self;
    self.tagView.delegate = self;
    
    [self.view addSubview:self.tagView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 20, 40, 30);
    [button setTitle:@"查看" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (NSInteger)numberOfTagView:(ABTagView *)tagView {
    return self.array.count;
}
- (UIButton *)tagView:(ABTagView *)tagView tagForIndex:(NSInteger)index {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *string = [self.array objectAtIndex:index];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor greenColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    [button setAdjustsImageWhenHighlighted:NO]; //取消高亮状态

    return button;
}

- (void)tagView:(ABTagView *)tagView didSelectForIndex:(NSInteger)index {
    
//    if (index == 3) {
//        UIButton *button = [tagView allButtons][index];
//        
//        [button setBackgroundColor:[UIColor orangeColor] forState:UIControlStateSelected];
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClick:(id)sender {
    
//    [self.array removeLastObject];
//    [self.tagView reloadData];
    
    for (NSString *title in [self.yntagView getSelectedDataSources]) {
        NSLog(@"%@",title);
    }

    
}

- (void)btnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

@end
