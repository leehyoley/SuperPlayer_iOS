#import "SuperPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "MoreContentView.h"
#import "DataReport.h"
#import "SuperPlayerFastView.h"
#import "PlayerSlider.h"
#import "UIView+MMLayout.h"
#import "SuperPlayerView+Private.h"
#import "StrUtils.h"
#import "SPDefaultControlView.h"
#import "UIView+Fade.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

#define MODEL_TAG_BEGIN 20

@interface SPDefaultControlView () <UIGestureRecognizerDelegate, PlayerSliderDelegate>


@end

@implementation SPDefaultControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.resolutionBtn];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        
        [self.topImageView addSubview:self.captureBtn];
        [self.topImageView addSubview:self.viewerCountLabel];
        [self.topImageView addSubview:self.danmakuBtn];
        [self.topImageView addSubview:self.moreBtn];
        [self.topImageView addSubview:self.shareBtn];
        [self.topImageView addSubview:self.collectBtn];
        [self.topImageView addSubview:self.followBtn];
//        self.shareBtn.hidden = YES;
        [self addSubview:self.lockBtn];
        [self.topImageView addSubview:self.backBtn];
        
        [self addSubview:self.playeBtn];
        
        [self.topImageView addSubview:self.titleLabel];
        
        
        [self addSubview:self.backLiveBtn];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        self.captureBtn.hidden = YES;
        self.danmakuBtn.hidden = YES;
        self.moreBtn.hidden     = YES;
        self.resolutionBtn.hidden   = YES;
        self.moreContentView.hidden = YES;
        self.verticalShareView.hidden = YES;
        // 初始化时重置controlView
        [self playerResetControlView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)makeSubViewsConstraints {
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading);
        make.top.equalTo(self.topImageView.mas_top);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.trailing.equalTo(self.topImageView.mas_trailing);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.moreBtn.mas_left);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.shareBtn.mas_left);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.collectBtn.mas_left);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.captureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.trailing.equalTo(self.moreBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.viewerCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.width.mas_equalTo(50);
        make.right.equalTo(self.shareBtn.mas_left);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.danmakuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.trailing.equalTo(self.captureBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backBtn.mas_trailing).offset(5);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.trailing.equalTo(self.viewerCountLabel.mas_leading).offset(-10);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.bottomImageView);
        make.width.mas_equalTo(50);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(45);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.trailing.equalTo(self.bottomImageView.mas_trailing);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(45);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-8);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(45);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
    }];
    
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(32);
    }];
    
    
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self);
    }];
    
    
    [self.backLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.startBtn.mas_top).mas_offset(-15);
        make.width.mas_equalTo(70);
        make.centerX.equalTo(self);
    }];
    
    [self.verticalShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(230);
        make.height.mas_equalTo(self.mas_height);
        make.trailing.equalTo(self.mas_trailing).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
    }];
    
    [self remakeVerticalShareViewConstraints];
}

- (void)remakeVerticalShareViewConstraints {
    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verticalShareView.mas_top).offset(33/375.0*[UIScreen mainScreen].bounds.size.height);
        make.centerX.equalTo(self.verticalShareView.mas_centerX);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareLabel.mas_centerY);
        make.left.equalTo(self.verticalShareView.mas_left).offset(15);
        make.right.equalTo(self.shareLabel.mas_left).offset(-10);
        make.height.equalTo(@1);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareLabel.mas_centerY);
        make.left.equalTo(self.shareLabel.mas_right).offset(10);
        make.right.equalTo(self.verticalShareView.mas_right).offset(-10);
        make.height.equalTo(@1);
    }];
    
    [self.QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareLabel.mas_bottom).offset(30/375.0*[UIScreen mainScreen].bounds.size.height);
        make.centerX.equalTo(self.verticalShareView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(53/375.0*[UIScreen mainScreen].bounds.size.height, 53/375.0*[UIScreen mainScreen].bounds.size.height));
    }];
    
    [self.QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.verticalShareView.mas_centerX);
        make.top.equalTo(self.QQBtn.mas_bottom).offset(10);
    }];
    
    [self.weichatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QQLabel.mas_bottom).offset(20/375.0*[UIScreen mainScreen].bounds.size.height);
        make.centerX.equalTo(self.verticalShareView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(53/375.0*[UIScreen mainScreen].bounds.size.height, 53/375.0*[UIScreen mainScreen].bounds.size.height));
    }];
    
    [self.weichatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.verticalShareView.mas_centerX);
        make.top.equalTo(self.weichatBtn.mas_bottom).offset(10);
    }];
    
    [self.weichatMomentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weichatLabel.mas_bottom).offset(20/375.0*[UIScreen mainScreen].bounds.size.height);
        make.centerX.equalTo(self.verticalShareView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(53/375.0*[UIScreen mainScreen].bounds.size.height, 53/375.0*[UIScreen mainScreen].bounds.size.height));
    }];
    
    [self.weichatMomentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.verticalShareView.mas_centerX);
        make.top.equalTo(self.weichatMomentBtn.mas_bottom).offset(10);
    }];
}


#pragma mark - Action

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender {
    self.resoultionCurrentBtn.selected = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
    self.resoultionCurrentBtn = sender;
    self.resoultionCurrentBtn.selected = YES;
    self.resoultionCurrentBtn.backgroundColor = RGBA(34, 30, 24, 1);
    
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [self.delegate controlViewSwitch:self withDefinition:sender.titleLabel.text];
}

- (void)backBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewBack:)]) {
        [self.delegate controlViewBack:self];
    }
}

- (void)exitFullScreen:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewChangeScreen:withFullScreen:)]) {
        [self.delegate controlViewChangeScreen:self withFullScreen:NO];
    }
}

- (void)lockScrrenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isLockScreen = sender.selected;
    self.topImageView.hidden    = self.isLockScreen;
    self.bottomImageView.hidden = self.isLockScreen;
    if (self.isLive) {
        self.backLiveBtn.hidden = self.isLockScreen;
    }
    [self.delegate controlViewLockScreen:self withLock:self.isLockScreen];
    [self fadeOut:3];
}

- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.delegate controlViewPlay:self];
    } else {
        [self.delegate controlViewPause:self];
    }
    [self cancelFadeOut];
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.delegate controlViewChangeScreen:self withFullScreen:YES];
    [self remakeVerticalShareViewConstraints];
    [self fadeOut:3];
}


- (void)captureBtnClick:(UIButton *)sender {
    [self.delegate controlViewSnapshot:self];
    [self fadeOut:3];
}

- (void)danmakuBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self fadeOut:3];
}

- (void)moreBtnClick:(UIButton *)sender {
    //    self.topImageView.hidden = YES;
    //    self.bottomImageView.hidden = YES;
    //    self.lockBtn.hidden = YES;
    
    self.moreContentView.playerConfig = self.playerConfig;
    [self.moreContentView update];
    self.moreContentView.hidden = NO;
    
    [self cancelFadeOut];
    self.isShowSecondView = YES;
}

- (void)shareBtnClick:(UIButton *)sender {
    //    self.topImageView.hidden = YES;
    //    self.bottomImageView.hidden = YES;
    //    self.lockBtn.hidden = YES;
    
    self.moreContentView.playerConfig = self.playerConfig;
    if (self.isFullScreen) {
        self.verticalShareView.hidden = NO;
        [self remakeVerticalShareViewConstraints];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KNotificationPopShareView" object:nil];
    }
}

- (UIView *)resolutionView {
    if (!_resolutionView) {
        // 添加分辨率按钮和分辨率下拉列表
        
        _resolutionView = [[UIView alloc] initWithFrame:CGRectZero];
        _resolutionView.hidden = YES;
        [self addSubview:_resolutionView];
        [_resolutionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(330);
            make.height.mas_equalTo(self.mas_height);
            make.trailing.equalTo(self.mas_trailing).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        
        _resolutionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _resolutionView;
}

- (void)resolutionBtnClick:(UIButton *)sender {
    self.topImageView.hidden = YES;
    self.bottomImageView.hidden = YES;
    self.lockBtn.hidden = YES;
    
    // 显示隐藏分辨率View
    self.resolutionView.hidden = NO;
    [DataReport report:@"change_resolution" param:nil];
    
    [self cancelFadeOut];
    self.isShowSecondView = YES;
}

- (void)progressSliderTouchBegan:(UISlider *)sender {
    self.isDragging = YES;
    [self cancelFadeOut];
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    [self.delegate controlViewPreview:self where:sender.value];
}

- (void)progressSliderTouchEnded:(UISlider *)sender {
    [self.delegate controlViewSeek:self where:sender.value];
    self.isDragging = NO;
    [self fadeOut:5];
}

- (void)backLiveClick:(UIButton *)sender {
    [self.delegate controlViewReload:self];
}

- (void)pointJumpClick:(UIButton *)sender {
    self.pointJumpBtn.hidden = YES;
    PlayerPoint *point = [self.videoSlider.pointArray objectAtIndex:self.pointJumpBtn.tag];
    [self.delegate controlViewSeek:self where:point.where];
    [self fadeOut:0.1];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)setOrientationLandscapeConstraint {
    self.fullScreen             = YES;
    self.lockBtn.hidden         = NO;
    self.fullScreenBtn.selected = self.isLockScreen;
    self.fullScreenBtn.hidden   = YES;
    self.resolutionBtn.hidden   = NO;
    self.moreBtn.hidden         = NO;
    self.captureBtn.hidden      = YES;
    self.danmakuBtn.hidden      = YES;
    
    [self.backBtn setImage:SuperPlayerImage(@"back_full") forState:UIControlStateNormal];
    
    
    [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.resolutionArray.count > 0) {
            make.trailing.equalTo(self.resolutionBtn.mas_leading);
        } else {
            make.trailing.equalTo(self.bottomImageView.mas_trailing);
        }
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(self.isLive?10:50);
    }];
    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.trailing.equalTo(self.topImageView.mas_trailing);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    //    if (IsIPhoneX) {
    //        [self.startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
    //            make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-25);
    //            make.width.height.mas_equalTo(30);
    //        }];
    //    }
    
    self.videoSlider.hiddenPoints = NO;
}
/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    self.fullScreen             = NO;
    self.lockBtn.hidden         = YES;
    self.fullScreenBtn.selected = NO;
    self.fullScreenBtn.hidden   = NO;
    self.resolutionBtn.hidden   = YES;
    self.moreBtn.hidden         = YES;
    self.captureBtn.hidden      = YES;
    self.danmakuBtn.hidden      = YES;
    self.moreContentView.hidden = YES;
    self.verticalShareView.hidden=YES;
    self.resolutionView.hidden  = YES;
    
    [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(self.isLive?10:50);
    }];
    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.trailing.equalTo(self.topImageView.mas_trailing);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    //    if (IsIPhoneX) {
    //        [self.startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
    //            make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
    //            make.width.height.mas_equalTo(30);
    //        }];
    //    }
    
    self.videoSlider.hiddenPoints = YES;
    self.pointJumpBtn.hidden = YES;
}

- (void)shareToQQ {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"verticalShareToQQ" object:nil];
}

- (void)shareToWeichat {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"verticalShareToWeiChat" object:nil];
}

- (void)shareToWeichatMoment {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"verticalShareToWeiChatMoment" object:nil];
}

#pragma mark - Private Method

#pragma mark - setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:SuperPlayerImage(@"back_full") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image                  = SuperPlayerImage(@"top_shadow");
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = SuperPlayerImage(@"bottom_shadow");
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:SuperPlayerImage(@"unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:SuperPlayerImage(@"lock-nor") forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockScrrenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lockBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:SuperPlayerImage(@"play") forState:UIControlStateNormal];
        [_startBtn setImage:SuperPlayerImage(@"pause") forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (PlayerSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[PlayerSlider alloc] init];
        [_videoSlider setThumbImage:SuperPlayerImage(@"slider_thumb") forState:UIControlStateNormal];
        _videoSlider.minimumTrackTintColor = TintColor;
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        _videoSlider.delegate = self;
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:SuperPlayerImage(@"fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UIButton *)captureBtn {
    if (!_captureBtn) {
        _captureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_captureBtn setImage:SuperPlayerImage(@"capture") forState:UIControlStateNormal];
        [_captureBtn setImage:SuperPlayerImage(@"capture_pressed") forState:UIControlStateSelected];
        [_captureBtn addTarget:self action:@selector(captureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureBtn;
}

- (UILabel *)viewerCountLabel{
    if (!_viewerCountLabel) {
        _viewerCountLabel = [[UILabel alloc]init];
        [_viewerCountLabel setTextColor:UIColor.whiteColor];
        _viewerCountLabel.font = [UIFont systemFontOfSize:15];
        _viewerCountLabel.text = @"";
    }
    return _viewerCountLabel;
}

- (UIButton *)danmakuBtn {
    if (!_danmakuBtn) {
        _danmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_danmakuBtn setImage:SuperPlayerImage(@"danmu") forState:UIControlStateNormal];
        [_danmakuBtn setImage:SuperPlayerImage(@"danmu_pressed") forState:UIControlStateSelected];
        [_danmakuBtn addTarget:self action:@selector(danmakuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danmakuBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:SuperPlayerImage(@"more") forState:UIControlStateNormal];
        [_moreBtn setImage:SuperPlayerImage(@"more_pressed") forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
-(UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateSelected];
        [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

-(UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setImage:[UIImage imageNamed:@"2-收藏"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"2-收藏1"] forState:UIControlStateSelected];
    }
    return _collectBtn;
}

-(UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followBtn setImage:[UIImage imageNamed:@"2-关注"] forState:UIControlStateNormal];
        [_followBtn setImage:[UIImage imageNamed:@"2-已关注"] forState:UIControlStateSelected];
    }
    return _followBtn;
}

- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _resolutionBtn.backgroundColor = [UIColor clearColor];
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionBtn;
}

- (UIButton *)backLiveBtn {
    if (!_backLiveBtn) {
        _backLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backLiveBtn setTitle:@"返回直播" forState:UIControlStateNormal];
        _backLiveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        UIImage *image = SuperPlayerImage(@"qg_online_bg");
        
        UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(33 * 0.5, 33 * 0.5, 33 * 0.5, 33 * 0.5)];
        [_backLiveBtn setBackgroundImage:resizableImage forState:UIControlStateNormal];
        
        [_backLiveBtn addTarget:self action:@selector(backLiveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backLiveBtn;
}

- (UIButton *)pointJumpBtn {
    if (!_pointJumpBtn) {
        _pointJumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = SuperPlayerImage(@"copywright_bg");
        UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
        [_pointJumpBtn setBackgroundImage:resizableImage forState:UIControlStateNormal];
        _pointJumpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_pointJumpBtn addTarget:self action:@selector(pointJumpClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pointJumpBtn];
    }
    return _pointJumpBtn;
}

- (MoreContentView *)moreContentView {
    if (!_moreContentView) {
        _moreContentView = [[MoreContentView alloc] initWithFrame:CGRectZero];
        _moreContentView.controlView = self;
        _moreContentView.hidden = YES;
        [self addSubview:_moreContentView];
        [_moreContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(330);
            make.height.mas_equalTo(self.mas_height);
            make.trailing.equalTo(self.mas_trailing).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        _moreContentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _moreContentView;
}

- (UIView *)verticalShareView {
    if (!_verticalShareView) {
        _verticalShareView = [[UIView alloc] initWithFrame:CGRectZero];
        _verticalShareView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _verticalShareView.hidden = YES;
        [self addSubview:_verticalShareView];
    }
    return _verticalShareView;
}

- (UILabel *)shareLabel {
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.text = @"分享到";
        _shareLabel.font = [UIFont systemFontOfSize:20];
        _shareLabel.textColor = [UIColor whiteColor];
        [self.verticalShareView addSubview:_shareLabel];
    }
    return _shareLabel;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = [UIColor whiteColor];
        [self.verticalShareView addSubview:_leftLineView];
    }
    return _leftLineView;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = [UIColor whiteColor];
        [self.verticalShareView addSubview:_rightLineView];
    }
    return _rightLineView;
}

- (UIButton *)QQBtn {
    if (!_QQBtn) {
        _QQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_QQBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [_QQBtn addTarget:self action:@selector(shareToQQ) forControlEvents:UIControlEventTouchUpInside];
        [self.verticalShareView addSubview:_QQBtn];
    }
    return _QQBtn;
}

- (UIButton *)weichatBtn {
    if (!_weichatBtn) {
        _weichatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weichatBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        [_weichatBtn addTarget:self action:@selector(shareToWeichat) forControlEvents:UIControlEventTouchUpInside];
        [self.verticalShareView addSubview:_weichatBtn];
    }
    return _weichatBtn;
}

- (UIButton *)weichatMomentBtn {
    if (!_weichatMomentBtn) {
        _weichatMomentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weichatMomentBtn setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        [_weichatMomentBtn addTarget:self action:@selector(shareToWeichatMoment) forControlEvents:UIControlEventTouchUpInside];
        [self.verticalShareView addSubview:_weichatMomentBtn];
    }
    return _weichatMomentBtn;
}

- (UILabel *)QQLabel {
    if (!_QQLabel) {
        _QQLabel = [[UILabel alloc] init];
        _QQLabel.text = @"QQ";
        _QQLabel.textColor = [UIColor whiteColor];
        _QQLabel.font = [UIFont systemFontOfSize:15];
        [self.verticalShareView addSubview:_QQLabel];
    }
    return _QQLabel;
}

- (UILabel *)weichatLabel {
    if (!_weichatLabel) {
        _weichatLabel = [[UILabel alloc] init];
        _weichatLabel.text = @"微信";
        _weichatLabel.textColor = [UIColor whiteColor];
        _weichatLabel.font = [UIFont systemFontOfSize:15];
        [self.verticalShareView addSubview:_weichatLabel];
    }
    return _weichatLabel;
}

- (UILabel *)weichatMomentLabel {
    if (!_weichatMomentLabel) {
        _weichatMomentLabel = [[UILabel alloc] init];
        _weichatMomentLabel.text = @"朋友圈";
        _weichatMomentLabel.textColor = [UIColor whiteColor];
        _weichatMomentLabel.font = [UIFont systemFontOfSize:15];
        [self.verticalShareView addSubview:_weichatMomentLabel];
    }
    return _weichatMomentLabel;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (self.isLive) return NO;
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        return NO;
    }
    return YES;
}

#pragma mark - Public method

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden) {
        self.resolutionView.hidden = YES;
        self.moreContentView.hidden = YES;
        self.verticalShareView.hidden = YES;
        if (!self.isLockScreen) {
            self.topImageView.hidden = NO;
            self.bottomImageView.hidden = NO;
        }
    }
    
    self.lockBtn.hidden = !self.isFullScreen;
    self.isShowSecondView = NO;
    self.pointJumpBtn.hidden = YES;
}

/** 重置ControlView */
- (void)playerResetControlView {
    self.videoSlider.value           = 0;
    self.videoSlider.progressView.progress = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.playeBtn.hidden             = YES;
    self.resolutionView.hidden       = YES;
    self.backgroundColor             = [UIColor clearColor];
    self.moreBtn.enabled         = YES;
    self.lockBtn.hidden              = !self.isFullScreen;
    
    self.danmakuBtn.enabled = YES;
    self.captureBtn.enabled = YES;
    self.moreBtn.enabled = YES;
    self.backLiveBtn.hidden              = YES;
}

- (void)setPointArray:(NSArray *)pointArray
{
    [super setPointArray:pointArray];
    
    for (PlayerPoint *holder in self.videoSlider.pointArray) {
        [holder.holder removeFromSuperview];
    }
    [self.videoSlider.pointArray removeAllObjects];
    
    for (SuperPlayerVideoPoint *p in pointArray) {
        PlayerPoint *point = [self.videoSlider addPoint:p.where];
        point.content = p.text;
        point.timeOffset = p.time;
    }
}



- (void)onPlayerPointSelected:(PlayerPoint *)point {
    NSString *text = [NSString stringWithFormat:@"  %@ %@  ", [StrUtils timeFormat:point.timeOffset],
                      point.content];
    
    [self.pointJumpBtn setTitle:text forState:UIControlStateNormal];
    [self.pointJumpBtn sizeToFit];
    CGFloat x = self.videoSlider.mm_x + self.videoSlider.mm_w * point.where - self.pointJumpBtn.mm_halfW;
    if (x < 0)
        x = 0;
    if (x + self.pointJumpBtn.mm_halfW > ScreenWidth)
        x = ScreenWidth - self.pointJumpBtn.mm_halfW;
    self.pointJumpBtn.tag = [self.videoSlider.pointArray indexOfObject:point];
    self.pointJumpBtn.m_left(x).m_bottom(60);
    self.pointJumpBtn.hidden = NO;
    
    [DataReport report:@"player_point" param:nil];
}

- (void)setProgressTime:(NSInteger)currentTime
              totalTime:(NSInteger)totalTime
          progressValue:(CGFloat)progress
          playableValue:(CGFloat)playable {
    if (!self.isDragging) {
        // 更新slider
        self.videoSlider.value           = progress;
    }
    // 更新当前播放时间
    self.currentTimeLabel.text = [StrUtils timeFormat:currentTime];
    // 更新总时间
    self.totalTimeLabel.text = [StrUtils timeFormat:totalTime];
    [self.videoSlider.progressView setProgress:playable animated:NO];
}

- (void)playerBegin:(SuperPlayerModel *)model
             isLive:(BOOL)isLive
     isTimeShifting:(BOOL)isTimeShifting
         isAutoPlay:(BOOL)isAutoPlay
{
    [self setPlayState:isAutoPlay];
    self.backLiveBtn.hidden = !isTimeShifting;
    self.moreContentView.isLive = isLive;
    
    for (UIView *subview in self.resolutionView.subviews)
        [subview removeFromSuperview];
    
    _resolutionArray = model.playDefinitions;
    [self.resolutionBtn setTitle:model.playingDefinition forState:UIControlStateNormal];
    
    UILabel *lable = [UILabel new];
    lable.text = @"清晰度";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [self.resolutionView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.resolutionView.mas_width);
        make.height.mas_equalTo(30);
        make.left.equalTo(self.resolutionView.mas_left);
        make.top.equalTo(self.resolutionView.mas_top).mas_offset(20);
    }];
    
    // 分辨率View上边的Btn
    for (NSInteger i = 0 ; i < _resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_resolutionArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(252, 89, 81, 1) forState:UIControlStateSelected];
        [self.resolutionView addSubview:btn];
        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.resolutionView.mas_width);
            make.height.mas_equalTo(45);
            make.left.equalTo(self.resolutionView.mas_left);
            make.centerY.equalTo(self.resolutionView.mas_centerY).offset((i-self.resolutionArray.count/2.0+0.5)*45);
        }];
        btn.tag = MODEL_TAG_BEGIN+i;
        
        if ([_resolutionArray[i] isEqualToString:model.playingDefinition]) {
            btn.selected = YES;
            btn.backgroundColor = RGBA(34, 30, 24, 1);
            self.resoultionCurrentBtn = btn;
        }
    }
    if (self.isLive != isLive) {
        self.isLive = isLive;
        [self setNeedsLayout];
    }
    // 时移的时候不能切清晰度
    self.resolutionBtn.userInteractionEnabled = !isTimeShifting;
}

/** 播放按钮状态 */
- (void)setPlayState:(BOOL)state {
    self.startBtn.selected = state;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleLabel.text = title;
}

#pragma clang diagnostic pop

@end
