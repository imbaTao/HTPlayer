//
//  PlayerVC.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/6/4.
//  Copyright © 2017年 Great. All rights reserved.

#import "PlayerVC.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MediaPlayCell.h"
#import "MediaTool.h"
#import "HZYBubbleCell.h"
#import "UIImage+extension.h"
@interface PlayerVC ()<AVPlayerViewControllerDelegate,VLCMediaPlayerDelegate>
/** exitIsPlaying */
@property(nonatomic,assign)BOOL exitIsPlaying;

/** lockBtn */
@property(nonatomic,strong)UIButton *lockBtn;

/** canRotate */
@property(nonatomic,assign)BOOL canRotate;

/** playListArr */
@property(nonatomic,strong)NSMutableArray *mediaDataArray;

@end

@implementation PlayerVC{
    /** 设备方向 */
    UIDeviceOrientation _orientaiton;

    /** 起始x轴坐标 */
   CGFloat startPosionX;
    
    /** 当前x轴坐标 */
   CGFloat currentPosionX;

    /** 起始Y轴坐标 */
    CGFloat startPosionY;
    
    /** 当前Y轴坐标 */
    CGFloat currentPosionY;
    
    /** 音量值 */
    CGFloat volumeValue ;
}


- (instancetype)initWithMediaDataArray:(NSMutableArray *)mediaDataArray{
    self = [super init];
    if (self) {
        self.mediaDataArray = mediaDataArray;
    }
    return self;
}

#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];
    NSNotificationCenter *ncenter = [NSNotificationCenter defaultCenter];
    [ncenter addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:device];
    //监听是否重新进入程序程序.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    //监听是否触发home键挂起程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    //监听是否退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [UIApplication sharedApplication].statusBarHidden = true;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = false;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [DBHelper updateMediaDataWithMediaName:MEDIATOOL.mediaArr];
    if (PLAYER.isPlaying) {
        _exitIsPlaying = true;
        [PLAYER pause];
        [_controllView.playOrPauseBtn setImage:[UIImage imageNamed:@"PlayPic_play"] forState:UIControlStateNormal];
    }
    _canRotate = false;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    _canRotate = true;
}

// 退出
- (void)applicationWillTerminate:(UIApplication *)application {
    if (self.mediaDataArray) {
         [DBHelper updateMediaDataWithMediaName:self.mediaDataArray];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.mediaView];
    [self.view addSubview:self.topInfoView];
    [self.view addSubview:self.controllView];
    [self.view addSubview:self.lockBtn];
    [self layoutPageViews];
    [self racConfig];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.controllView.fullScreenBtn.userInteractionEnabled) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.controllView.fullScreenBtn.userInteractionEnabled = true;
        });
    }
}

- (void)layoutPageViews{
    [_mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            if (KIsiPhoneX) {
                   make.edges.mas_equalTo(UIEdgeInsetsMake(SAFE.top, SAFE.left, SAFE.bottom, SAFE.right));
            }else{
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }
    }];

    [_topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            if (KIsiPhoneX) {
                   make.top.offset(SAFE.top);
            }else{
                make.top.offset(0);
            }
        } else {
             make.top.offset(0);
        }
        make.left.offset(0);
        make.right.offset(0);
        make.height.mas_equalTo(49);
    }];

    [_controllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.offset(-SAFE.bottom);
        } else {
            make.bottom.offset(0);
        }
        make.height.mas_equalTo(44);
    }];

    [_lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mediaView);
        make.right.offset(-30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}


- (void)needUpdateLayout{
    [_mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(SAFE.top, SAFE.left,0, SAFE.right));
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }
    }];
    
    [_topInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.offset(SAFE.top);
        } else {
            make.top.offset(0);
        }
        make.left.offset(0);
        make.right.offset(0);
        make.height.mas_equalTo(49);
    }];
    
    [_controllView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        if (@available(iOS 11.0, *)) {
            if (_orientaiton == UIDeviceOrientationPortrait) {
                  make.bottom.offset(-SAFE.bottom);
            }else{
                make.bottom.offset(0);
            }
        } else {
             make.bottom.offset(0);
        }
        make.height.mas_equalTo(44);
    }];
}

- (void)racConfig {
    __weak typeof(self)weakSelf = self;
    // 顶部视图返回事件
    [[_topInfoView rac_signalForSelector:@selector(buttonClick)] subscribeNext:^(RACTuple * _Nullable x) {
           [PlayerTool orientationTo:UIInterfaceOrientationPortrait];
//        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        if (PLAYER.isPlaying) {
            NSString *pathStr  = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Library/"],Playing.mediaName];
            NSArray *trackInfoArr = Playing.media.tracksInformation;
            CGFloat width = 0;
            CGFloat height = 0;
            if (trackInfoArr.count) {
                width = [[trackInfoArr[0] objectForKey:@"width"] floatValue];
                height = [[trackInfoArr[0] objectForKey:@"height"] floatValue];
                [PLAYER saveVideoSnapshotAt:pathStr withWidth:width andHeight: height];
                Playing.thumbnail = [UIImage imageWithContentsOfFile:pathStr];
                Playing.thumbnail =  [UIImage clipImage:Playing.thumbnail toRect:CGSizeMake(CellWidth, CellWidth * 1.3333)];
            }
        }
        [PLAYER pause];
        [weakSelf dismissViewControllerAnimated:true completion:^{
            [weakSelf.delegate backActionRefreshThumbnail];
            [PLAYER stop];
        }];
    }];
    
    // 列表点击事件
    [[_mediaView.playListTBV rac_signalForSelector:@selector(playInlistWithIndex:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSIndexPath *indexPath = [x allObjects][0];
        if (indexPath.row == weakSelf.currentUrlIndex) {
            return;
        }
        weakSelf.currentUrlIndex = indexPath.row;
        [weakSelf orientationChanged];
        [weakSelf beginPlay];
    }];

    // 弹幕设置
    [[weakSelf.mediaView.configView rac_signalForSelector:@selector(openSubTitles:)] subscribeNext:^(RACTuple * _Nullable x) {
        [PLAYER openVideoSubTitlesFromFile:[x allObjects][0]];
    }];

    // 比例
    [[weakSelf.mediaView.configView rac_signalForSelector:@selector(changeRatio:)] subscribeNext:^(RACTuple * _Nullable x) {
        PLAYER.videoAspectRatio = (char *)[[x allObjects][0] UTF8String];
        if ([[NSString stringWithFormat:@"%s",PLAYER.videoAspectRatio] isEqualToString:@"0"]) {
            [weakSelf beginPlay];
        }
    }];

    // 速率
    [[weakSelf.mediaView.configView rac_signalForSelector:@selector(changeRate:)] subscribeNext:^(RACTuple * _Nullable x) {
        [PLAYER fastForwardAtRate:[[x allObjects][0] floatValue]];
    }];


    // 暂停
    [[weakSelf.controllView rac_signalForSelector:@selector(playOrPauseAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        UIButton *sender = [x allObjects][0];
        if (!sender.isSelected) {
            [PLAYER pause];
            [weakSelf.controllView.playOrPauseBtn setImage:[UIImage imageNamed:@"PlayPic_play"] forState:UIControlStateNormal];
        }else{
            [PLAYER play];
            [weakSelf.controllView.playOrPauseBtn setImage:[UIImage imageNamed:@"PlayPic_pause"] forState:UIControlStateNormal];
        }
        sender.selected = !sender.selected;
    }];

    // 下一个
    [[weakSelf.controllView rac_signalForSelector:@selector(playNextAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf nextMediaMethod];
    }];

    // 双击暂停
    [[weakSelf.mediaView rac_signalForSelector:@selector(doubleTapAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        [weakSelf doubleClickAction];
    }];


    // 播放列表
    [[weakSelf.controllView rac_signalForSelector:@selector(playListAction:)] subscribeNext:^(RACTuple * _Nullable x) {
         UIButton *sender = [x allObjects][0];
        if (!sender.isSelected) {
            weakSelf.controllView.playListBtn.layer.borderColor = RGB(98, 98, 98, 1).CGColor;
            [weakSelf.mediaView p_unfoldListTBV];
        }
        sender.selected = !sender.selected;
    }];

    // 单击改变透明度
    [[weakSelf.mediaView rac_signalForSelector:@selector(changeAlpha)] subscribeNext:^(RACTuple * _Nullable x) {
        weakSelf.controllView.mediaConfigBtn.selected = false;
        [weakSelf.controllView.mediaConfigBtn setImage:[UIImage imageNamed:@"PlayPic_setting"] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.controllView.alpha = !weakSelf.controllView.alpha;
            weakSelf.topInfoView.alpha = !weakSelf.topInfoView.alpha;
            weakSelf.lockBtn.alpha = !weakSelf.lockBtn.alpha;
            weakSelf.mediaView.configView.alpha  = 0;
        }];

        if (weakSelf.mediaView.configView.alpha == 1) {
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.mediaView.configView.alpha = 0;
            }];
        }
    }];

}



#pragma mark - VlcDelegate
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    if (!self.canRotate){
         self.canRotate = true;
    }
    MediaModel *model = self.mediaDataArray[_currentUrlIndex];
    model.recordLength = PLAYER.time.intValue / 1000;
    if (PLAYER.time.intValue / 1000 -  model.mediaLength >= - 0.1) {
        model.recordLength = 0;
        [self nextMediaMethod];
    }

    [_controllView refreshTime];
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
//    if (PLAYER.state == VLCMediaPlayerStateStopped && MEDIA.recordLength != 0) {
//
//    }
}

#pragma mark - setter&getter
- (NSMutableArray *)mediaDataArray{
    if (!_mediaDataArray) {
        _mediaDataArray = [NSMutableArray array];
    }
    return _mediaDataArray;
}

- (MediaTopInfoView *)topInfoView{
    if (!_topInfoView) {
        _topInfoView = [[MediaTopInfoView alloc] init];
    }
    return _topInfoView;
}

- (MediaControllView *)controllView{
    if (!_controllView) {
        _controllView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MediaControllView class]) owner:self options:nil].lastObject;
        _controllView.mediaView = self.mediaView;
    }
    return _controllView;
}

- (MediaView *)mediaView{
    if (!_mediaView) {
        _mediaView = [[MediaView alloc] init];
        _mediaView.backgroundColor = [UIColor blackColor];
        _mediaView.controllView = self.controllView;
    }
    return _mediaView;
}

- (UIButton *)lockBtn{
    if (!_lockBtn) {
        _lockBtn = [UIButton creatBtnMethodWithColor:nil Image:@"PlayPic_Unlock" title:nil VC:self selecter:@selector(lockScreen:)];
    }
    return _lockBtn;
}

- (void)lockScreen:(UIButton *)sender {
    if (!sender.isSelected) {
        [UIView animateWithDuration:0.4 animations:^{
            _controllView.alpha = 0;
            _topInfoView.alpha = 0;
            _lockBtn.alpha = 0;
            _mediaView.configView.alpha = 0;
        }];
        self.mediaView.userInteractionEnabled = false;
        [sender setBackgroundImage:[UIImage imageNamed:@"PlayPic_Lock"] forState:UIControlStateNormal];
        self.controllView.mediaConfigBtn.selected = false;
        [self.controllView.mediaConfigBtn setImage:[UIImage imageNamed:@"PlayPic_setting"] forState:UIControlStateNormal];
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeLockBtnAlpha) object:nil];
        self.mediaView.userInteractionEnabled = true;
        [UIView animateWithDuration:0.4 animations:^{
            _controllView.alpha = 1;
            _topInfoView.alpha = 1;
            _lockBtn.alpha = 1;
        }];
        [sender setBackgroundImage:[UIImage imageNamed:@"PlayPic_Unlock"] forState:UIControlStateNormal];
    }
      sender.selected = !sender.selected;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_mediaView.userInteractionEnabled) {
        [UIView animateWithDuration:0.4 animations:^{
              _lockBtn.alpha = 1;
        }];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeLockBtnAlpha) object:nil];
        [self performSelector:@selector(changeLockBtnAlpha) withObject:nil afterDelay:2];
    }
}

- (void)changeLockBtnAlpha{
    [UIView animateWithDuration:0.4 animations:^{
        _lockBtn.alpha = 0;
    }];
}

- (void)setCurrentUrlIndex:(NSInteger)currentUrlIndex{
    if (_currentUrlIndex != currentUrlIndex) {
        _currentUrlIndex = currentUrlIndex;
        if (_currentUrlIndex == self.mediaDataArray.count) {
            _currentUrlIndex = 0;
        }
    }

}

#pragma mark - private
/** 开始播放方法 */
- (void)startPlayWithIndex:(NSInteger)index{
    _currentUrlIndex = index;
    PLAYER.delegate = self;
    PLAYER.drawable = self.mediaView.playView;
    self.mediaView.playListTBV.dataArray = self.mediaDataArray;
    [self orientationChanged];
    [self beginPlay];
}


/** 下一个视频 */
- (void)nextMediaMethod{
    if (_currentUrlIndex <self.mediaDataArray.count - 1) {
        ++_currentUrlIndex;
    }else{
        _currentUrlIndex = 0;
    }
    [self beginPlay];
}




/** 设备方向监听转变 */
-(void)orientationChanged{
    if (!self.canRotate) {
        return;
    }
    _orientaiton = [[UIDevice currentDevice] orientation];
    switch (_orientaiton) {
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationPortraitUpsideDown:{
                [_controllView.fullScreenBtn setImage:[UIImage imageNamed:@"PlayPic_row"] forState:UIControlStateNormal];
                _controllView.playListBtn.hidden = _controllView.mediaConfigBtn.hidden = true;
            }break;
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:{
                [_controllView.fullScreenBtn setImage:[UIImage imageNamed:@"PlayPic_clo"] forState:UIControlStateNormal];
                _controllView.playListBtn.hidden = _controllView.mediaConfigBtn.hidden =  false;
            }break;
        default: break;
    }
    [PlayerTool share].mutiple = Playing.mediaLength / SCREEN_W ;
    [self needUpdateLayout];
}


- (void)changeAlpha{
    if (_controllView.alpha == 1) {
        [UIView animateWithDuration:0.4 animations:^{
            _controllView.alpha = 0;
            _topInfoView.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            _controllView.alpha = 1;
            _topInfoView.alpha = 1;
        }];
    }
}

/** hiddenStatusbar */
-(BOOL)prefersStatusBarHidden{
    return YES;
}


//图片倒圆角
- (UIImage *)takeThumbnailWithNeedSize:(CGSize)size image:(UIImage *)image{
    CGRect rect = CGRectMake(0,0,size.width,size.width);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRect:rect].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [image drawInRect:rect];
    UIImage *new = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return new;
}

/** 开始播放 */
- (void)beginPlay{
    [PLAYER pause];
    if (Playing) {
      [DBHelper updateMediaDataWithMediaName:[NSMutableArray arrayWithObject:Playing]];
    }
    MediaModel *model = self.mediaDataArray[self.currentUrlIndex];
    Playing = model;
    PLAYER.media = [[VLCMedia alloc] initWithURL:model.mediaURL];
    self.topInfoView.mediaNameLB.text = model.mediaName;
    self.controllView.allPlayTimeLb.text  =  [PlayerTool takeTimeStrTimeValue:model.mediaLength];
    self.controllView.playedTimeLb.text = [PlayerTool takeTimeStrTimeValue:model.recordLength];
    [self.controllView.playOrPauseBtn setImage:[UIImage imageNamed:@"PlayPic_pause"] forState:UIControlStateNormal];
    [self.mediaView.playListTBV reloadData];
    if (!PLAYER.playing) {
        [PLAYER play];
    }
    
    if (model.recordLength) {
        [PLAYER pause];
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PLAYER.position = model.recordLength / model.mediaLength;
        [PLAYER play];
       });
    }
}

- (BOOL)shouldAutorotate{
    return self.canRotate && self.mediaView.userInteractionEnabled;
}

- (void)doubleClickAction{
    
}


- (void)dealloc{
#ifdef DEBUG
     NSLog(@"播放控制器释放了");
#endif
}

@end
