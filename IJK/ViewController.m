//
//  ViewController.m
//  IJK
//
//  Created by huangpengfei on 2018/6/21.
//  Copyright © 2018年 huangpengfei. All rights reserved.
//

#import "ViewController.h"
#import "PlayViewController.h"
@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,copy) NSString *urlStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arr = [NSMutableArray arrayWithCapacity:10];
    [self.arr addObject:@"rtmp://192.168.1.122:1935/mylive/room"];
    [self.arr addObject: @"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
    [self.arr addObject:@"rtmp://58.200.131.2:1935/livetv/cctv16"];
    [self.arr addObject:@"rtmp://jyg.live.cdvcloud.com/zhtv/live"];
    [self.arr addObject:@"http://live2.hljtv.com/channels/hljtv/yspd/flv:sd/live"];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button setTitle:@"播放" forState:UIControlStateNormal];
//    button.frame = CGRectMake(100, 100, 200, 50);
//    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    CGFloat y = 80;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    for(int i = 0 ;i<self.arr.count;i++){
        NSString *str = self.arr[i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, y,width , 40)];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        y += 50;
    }
}

- (void)buttonClick:(UIButton *)sender{
    PlayViewController *playVC = [[PlayViewController alloc] init];
    NSString *str = sender.titleLabel.text;
    if(str){
        self.urlStr = str;
    }
    NSLog(@"str = %@",str);
    playVC.urlStr = self.urlStr;
    [self.navigationController pushViewController:playVC animated:YES];
}

@end
