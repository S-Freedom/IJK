//
//  PlayViewController.m
//  IJK
//
//  Created by huangpengfei on 2018/6/22.
//  Copyright © 2018年 huangpengfei. All rights reserved.
//

#import "PlayViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "JFCustomPlayView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface PlayViewController ()
@property (nonatomic, strong) id <IJKMediaPlayback> player;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) JFCustomPlayView *playerView;
@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, strong) UIView *back1View;
@property (nonatomic, strong) UIView *back2View;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.urlStr){
        self.urlStr = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    }
    self.navigationController.navigationBarHidden = YES;
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
//    [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    
    self.url = [NSURL URLWithString:self.urlStr];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    self.view.autoresizesSubviews = YES;
    UIView *playerView = [self.player view];
//    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CGFloat width = kScreenWidth;
    self.playerView = [[JFCustomPlayView alloc] initWithFrame:CGRectMake(0, 0, width, width*9/16)];
    playerView.frame = self.playerView.bounds;
    [self.playerView insertSubview:playerView atIndex:0];
    
    __weak typeof(self) weakSelf = self;
    self.playerView.transBlock = ^{
        NSLog(@"trans block");
        [weakSelf makeFullScreen];
    };
    
    self.playerView.showHiddenStatesBarBlock = ^{
        NSLog(@"显示隐藏状态栏");
    };
    
    self.playerView.backBlock = ^{
        NSLog(@"back block");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.playerView.playPauseBlock = ^(UIButton *sender) {
        NSLog(@"play or pause");
        if(weakSelf.player.isPlaying){
            [weakSelf.player pause];
        }else{
            [weakSelf.player play];
        }
    };
    
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    [self installMovieNotificationObservers];
    
    // 判断是不是主线程
    //    if([NSThread isMainThread]){
    //        [self.view addSubview:self.PlayerView];
    //    }else{
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view addSubview:weakSelf.playerView];
    });
    //    }
    
    CGFloat y1 = CGRectGetMaxY(playerView.frame);
    UIView *back1View = [[UIView alloc] initWithFrame:CGRectMake(0, y1, kScreenWidth, 300)];
    CGFloat y2 = CGRectGetMaxY(back1View.frame);
    UIView *back2View = [[UIView alloc] initWithFrame:CGRectMake(0, y2, kScreenWidth, 300)];
    back1View.backgroundColor = [UIColor redColor];
    back2View.backgroundColor = [UIColor greenColor];
    self.back1View = back1View;
    self.back2View = back2View;
    [self.view addSubview:back1View];
    [self.view addSubview:back2View];
}

- (void)buttonClick{
    if (![self.player isPlaying]) {
        [self.player play];
    }else{
        [self.player pause];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}
#pragma Selector func
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}
- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma Install Notifiacation
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft:
                NSLog(@"left");
                [self landscape];
                break;
            case UIInterfaceOrientationLandscapeRight:
                NSLog(@"right");
                [self landscape];
                break;
            case UIInterfaceOrientationPortrait:
                NSLog(@"portrait");
                [self portrait];
                break;
            default:
                break;
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)portrait {
    self.isFullScreen = NO;
    [self originPlayFrame];
}
- (void)landscape {
    self.isFullScreen = YES;
    [self fullScreenFrame];
}

- (void)makeFullScreen {
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    if (self.isFullScreen) {
        value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    }
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)originPlayFrame{
    CGFloat width = kScreenWidth;
    self.playerView.frame = CGRectMake(0, 0, width, width*9/16);
    
}
- (void)fullScreenFrame{
    self.playerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

@end
