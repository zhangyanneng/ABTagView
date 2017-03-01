//
//  ViewController.m
//  ABTagView
//
//  Created by zyn on 2017/2/28.
//  Copyright © 2017年 张艳能. All rights reserved.
//

#import "ViewController.h"
#import "ABTagView.h"

@interface ViewController ()<ABTagViewDataSource,ABTagViewDelegate>


@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) ABTagView *tagView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *arr = @[@"职场",@"产品经理",@"JAVA开发工程师",@"iOS开发工程师",@"H5开发工程师",@"邦邦在线",@"架构师",@"Android工程师"];
    
    self.array = [NSMutableArray arrayWithArray:arr];
    
    self.tagView = [[ABTagView alloc] init];
    self.tagView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 500);
    self.tagView.multiSelect = NO; //支持多选
    self.tagView.dataSource = self;
    self.tagView.delegate = self;
    
    [self.view addSubview:self.tagView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 50, 40, 30);
    [button setTitle:@"移除" forState:UIControlStateNormal];
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

    return button;
}

- (void)tagView:(ABTagView *)tagView didSelectForIndex:(NSInteger)index {
    
    if (index == 3) {
        UIButton *button = [tagView allButtons][index];
        
        [button setBackgroundColor:[UIColor orangeColor] forState:UIControlStateSelected];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClick:(id)sender {
    
    [self.array removeLastObject];
    [self.tagView reloadData];
    NSLog(@"执行了");
}

@end
