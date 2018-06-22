//
//  JFCustomPlayView.h
//  IJK
//
//  Created by huangpengfei on 2018/6/22.
//  Copyright © 2018年 huangpengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFCustomPlayView : UIView
@property(nonatomic, copy) void (^backBlock)();
@property(nonatomic, copy) void (^transBlock)();
@property(nonatomic, copy) void (^playPauseBlock)(UIButton *sender);
@property(nonatomic, copy) void (^showHiddenStatesBarBlock)();
@property (nonatomic, strong) UIButton *trans;
@end
