//
//  MXMoviePlayerController.m
//  LaneTrip
//
//  Created by antsmen on 15-4-13.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MoviePlayerController.h"
#import <AVFoundation/AVFoundation.h>

#define degreesToRadians(x) (M_PI * x / 180.0f)

@interface MoviePlayerController()
<VKScrubberDelegate>
{
    UIActivityIndicatorView *loading;
    NSTimer *timer;
        
    //窗口切换
    CGRect originFrame;
    UIView *originSuperView;
}

@end

@implementation MoviePlayerController
@synthesize delegate;
@synthesize state;

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    if ( (self = [super init]) ) {
        
        self.thumbImageView = [[UIImageView alloc] init];
        self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:self.thumbImageView];
        
        //controls
        [self initControls];
        
        [self setFrame:frame];
        self.view.backgroundColor = [UIColor blackColor];
        [self setControlStyle:MPMovieControlStyleNone];
        
        //loading
        loading = [[UIActivityIndicatorView alloc] init];
        loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        loading.hidesWhenStopped = YES;
        [self.view addSubview:loading];
        
        self.controlsEnabled = YES;
        
        [self addNotifications];
    }
    return self;
}

- (void)setControlsOffsetY:(CGFloat)controlsOffsetY
{
    _controlsOffsetY = controlsOffsetY;
    [self setFrame:self.view.frame];
}

- (void)setControlsEnabled:(BOOL)controlsEnabled
{
    _controlsEnabled = controlsEnabled;
    self.controls.hidden = !controlsEnabled;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    if(self.controls.fullScreenBtn.selected){
        [self.controls setFrame:CGRectMake(0, frame.size.height-44, frame.size.width, 44)];
    }else{
        [self.controls setFrame:CGRectMake(0, frame.size.height-44+self.controlsOffsetY, frame.size.width, 44)];
    }
    self.thumbImageView.frame = self.view.bounds;
    
    CGFloat loadingSideLength = 30;
    loading.frame = CGRectMake(frame.size.width/2-loadingSideLength/2, frame.size.height/2-loadingSideLength/2, loadingSideLength, loadingSideLength);
}

- (void)setContentURL:(NSURL *)url
{
    if(url == self.contentURL){
        return;
    }
    [super setContentURL:url];
    self.state = [self.contentURL.scheme isEqualToString:@"file"] ? MXMoviePlayerControlsStateReady : MXMoviePlayerControlsStateIdle;
    self.thumbImageView.image = nil;
    
}

- (void)play
{
    if(!self.contentURL){
        [MyCommon showTips:@"数据异常"];
        return;
    }
    if(![self isLocalURL:self.contentURL]){
        static BOOL isNeedToWarnWWAN = NO;
        NetworkStatus networkType = [MyCommon getNetworkType];
        if (networkType==NotReachable){
            [MyCommon showTips:@"您当前的网络不通畅"];
            return;
        }else if (networkType==ReachableViaWiFi){
            isNeedToWarnWWAN = NO;
        }else if(!isNeedToWarnWWAN){
            if(networkType==ReachableViaWWAN){
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"您现在使用的是运营商网络，继续观看可能产生超额流量费" actionBlock:^(NSInteger buttonIndex) {
                    if(buttonIndex==1){
                        isNeedToWarnWWAN = YES;
                        [self play];
                    }
                } cancelButtonTitle:@"取消播放" otherButtonTitles:@"继续播放", nil];
                [alert show];
                return;
            }
        }
    }
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    self.state = MXMoviePlayerControlsStateLoading;
    [super play];
    self.controls.playBtn.selected = YES;
    self.thumbImageView.hidden = YES;
    NSLog(@"video play");
}

- (void)pause
{
    if(self.playbackState == MPMoviePlaybackStatePaused){
        return;
    }
    [super pause];
    self.controls.playBtn.selected = NO;
    NSLog(@"video pause");
}

- (void)stop
{
    if(self.playbackState == MPMoviePlaybackStateStopped){
        return;
    }
    [super stop];
    self.controls.playBtn.selected = NO;
    NSLog(@"video stop");
}

- (void)reset
{
    [self stop];
    [self finish];
}

- (void)finish
{
    self.state = MXMoviePlayerControlsStateIdle;
    [self resetProgress];
    self.controls.playBtn.selected = NO;
    self.thumbImageView.hidden = NO;
    [self hideLoadingIndicators];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:self];
}

- (void)setState:(MXMoviePlayerControlsState)aState {
    if (state != aState) {
        state = aState;
        
        switch (aState) {
            case MXMoviePlayerControlsStateLoading:
                [self showLoadingIndicators];
                break;
            case MXMoviePlayerControlsStateReady:
            {
                [self hideLoadingIndicators];
                [self startUpdateProgress];
            }
                break;
            case MXMoviePlayerControlsStateIdle:
            {
                [self hideLoadingIndicators];
                [self stopUpdateProgress];
            }
                break;
            default:
                break;
        }
    }
}

- (void)movieLoadStateDidChange:(NSNotification *)note
{
    if([note object] != self){
        return;
    }
    switch (self.loadState) {
        case MPMovieLoadStatePlayable:
        case MPMovieLoadStatePlaythroughOK:
            //进度更新
            [self startUpdateProgress];
            self.state = MXMoviePlayerControlsStateReady;
            break;
        case MPMovieLoadStateStalled:
        case MPMovieLoadStateUnknown:
            break;
        default:
            break;
    }
}

- (void)moviePlaybackStateDidChange:(NSNotification *)note
{
    if([note object] != self){
        return;
    }
    switch (self.playbackState) {
        case MPMoviePlaybackStatePlaying:
        case MPMoviePlaybackStateSeekingBackward:
        case MPMoviePlaybackStateSeekingForward:
            self.state = MXMoviePlayerControlsStateReady;
            break;
        case MPMoviePlaybackStateInterrupted:
            self.state = MXMoviePlayerControlsStateLoading;
            break;
        case MPMoviePlaybackStatePaused:
            [self hideLoadingIndicators];
            self.state = MXMoviePlayerControlsStateIdle;
            break;
        case MPMoviePlaybackStateStopped:
            [self finish];
            self.state = MXMoviePlayerControlsStateIdle;
            break;
        default:
            break;
    }
}

- (void)movieFinished:(NSNotification *)note
{
    if([note object] != self){
        return;
    }
    if(delegate && [delegate respondsToSelector:@selector(moviePlayerControllerMovieFinished)]){
        [delegate moviePlayerControllerMovieFinished];
    }
}

#pragma mark - 
- (void)showLoadingIndicators
{
    if(loading && !loading.isAnimating){
        [loading startAnimating];
    }
}

- (void)hideLoadingIndicators
{
    if(loading && loading.isAnimating){
        [loading stopAnimating];
    }
}

#pragma mark - controls

- (void)initControls
{
    if(self.controls){
        return;
    }
    self.controls = [[MXControls alloc] init];
    [self.view addSubview:self.controls];
    
    self.controls.scrubber.delegate = self;
    self.controls.scrubber.enabled = NO;
    self.controls.scrubber.value = 0;
    [self.controls.scrubber addTarget:self action:@selector(updateTimeLabels) forControlEvents:UIControlEventValueChanged];
    
    //action
    [self.controls.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.controls.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
}

//播放按钮
- (void)playBtnAction:(id)sender
{
    if(self.controls.playBtn.selected){
        [self pause];
    }else{
        [self play];
    }
}

//全屏按钮
- (void)fullScreenAction:(id)sender
{
    self.controls.fullScreenBtn.selected = !self.controls.fullScreenBtn.selected;
    UIWindow *window = [MyCommon normalLevelWindow];
    if(self.controls.fullScreenBtn.selected){
        //全屏
        originFrame = self.view.frame;
        originSuperView = self.view.superview;
        
        CGRect desFrame = [self.view.superview convertRect:self.view.frame toView:window];
        [self setFrame:desFrame];
        [window addSubview:self.view];
        
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat degrees = [self degreesForOrientation:UIInterfaceOrientationLandscapeRight];
            CGFloat width = window.bounds.size.width;
            CGFloat height = window.bounds.size.height;
            [self setFrame:CGRectMake(width/2-height/2, height/2-width/2, height, width)];
            self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        } completion:^(BOOL finished) {
            
        }];
    }else{
        //小窗口
        CGRect desFrame = [originSuperView convertRect:originFrame toView:window];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat degrees = [self degreesForOrientation:UIInterfaceOrientationPortrait];
            self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(degrees));
            [self setFrame:desFrame];
        } completion:^(BOOL finished) {
            [originSuperView addSubview:self.view];
            [self setFrame:originFrame];
        }];
    }
}

- (void)startUpdateProgress
{
    self.controls.scrubber.enabled = YES;
    self.controls.scrubber.maximumValue = self.duration;
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [self updateProgress];
}

- (void)stopUpdateProgress
{
    [timer invalidate];
}

- (void)resetProgress
{
    [timer invalidate];
    self.controls.scrubber.value = 0;
    self.controls.scrubber.maximumValue = 0;
    self.controls.scrubber.enabled = NO;
    [self updateTimeLabels];
}

- (void)updateProgress
{
    [self.controls.scrubber setValue:self.currentPlaybackTime animated:YES];
    [self updateTimeLabels];
}

//更新时间
- (void)updateTimeLabels
{
    NSString *currentString = [self timeStringFromSecondsValue:(int)self.controls.scrubber.value];
    NSString *totalString = [self timeStringFromSecondsValue:(int)self.controls.scrubber.maximumValue];
    self.controls.currentTimeLabel.text = currentString;
    self.controls.totalTimeLabel.text = totalString;
}

#pragma mark - VKScrubberDelegate
- (void)scrubbingBegin
{
    //[self stopUpdateProgress];
    [self pause];
}

- (void)scrubbingEnd
{
    self.currentPlaybackTime = self.controls.scrubber.value;
    //[self startUpdateProgress];
    [self play];
}

#pragma mark - method
- (CGFloat)degreesForOrientation:(UIInterfaceOrientation)deviceOrientation
{
    switch (deviceOrientation) {
        case UIInterfaceOrientationPortrait:
            return 0;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return -90;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return 180;
            break;
        default:
            return 0;
            break;
    }
}

//获取序列化时间
- (NSString *)timeStringFromSecondsValue:(int)seconds
{
    NSString *retVal;
    int hours = seconds / 3600;
    int minutes = (seconds / 60) % 60;
    int secs = seconds % 60;
    if (hours > 0) {
        retVal = [NSString stringWithFormat:@"%01d:%02d:%02d", hours, minutes, secs];
    } else {
        retVal = [NSString stringWithFormat:@"%02d:%02d", minutes, secs];
    }
    return retVal;
}

- (BOOL)isLocalURL:(NSURL*)url
{
    if(url){
        return [url.scheme isEqualToString:@"file"];
    }
    return NO;
}

@end
