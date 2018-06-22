//
//  JFCustomPlayView.m
//  IJK
//
//  Created by huangpengfei on 2018/6/22.
//  Copyright © 2018年 huangpengfei. All rights reserved.
//

#import "JFCustomPlayView.h"

@interface JFCustomPlayView()

@property (nonatomic, strong) UIButton *playbtn;

@end

@implementation JFCustomPlayView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        CGFloat btnW = 80;
        CGFloat btnH = 50;
        UIButton *trans = [[UIButton alloc] initWithFrame:CGRectMake(width - btnW - 10, height - btnH - 10, btnW, btnH)];
        [trans setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [trans setTitle:@"旋转" forState:UIControlStateNormal];
        [trans addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.trans = trans;
        [self addSubview:trans];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, btnH)];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        UIButton *playbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, btnH)];
        playbtn.center = self.center;
        [playbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [playbtn setTitle:@"play" forState:UIControlStateNormal];
        [playbtn setTitle:@"pause" forState:UIControlStateSelected];
        [playbtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
        self.playbtn = playbtn;
        [self addSubview:playbtn];
    }
    return self;
}

- (void)playClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(self.playPauseBlock){
        self.playPauseBlock(sender);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    
    if(self.showHiddenStatesBarBlock){
        self.showHiddenStatesBarBlock();
    }
}

- (void)backClick:(UIButton *)sender{
    if(self.backBlock){
        self.backBlock();
    }
}

- (void)btnClick:(UIButton *)sender{
    // 旋转
    if(self.transBlock){
        self.transBlock();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat btnW = 80;
    CGFloat btnH = 50;
    self.trans.frame = CGRectMake(width - btnW - 10, height - btnH - 10, btnW, btnH);
}

@end
