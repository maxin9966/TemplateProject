
 //
//  MusicPlayer.m
//  MagicMusicPlayer
//
//  Created by antsmen on 15-1-23.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MXMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface MXMusicPlayer()
<AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSOperation *operation;
@property (nonatomic,strong) NSData *audioData;

@end

@implementation MXMusicPlayer
@synthesize delegate;
@synthesize currentTime,duration;
@synthesize player,timer,operation,audioData;

+ (id)sharedInstance {
    static MXMusicPlayer *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    if(self = [super init]){

    }
    return self;
}

- (NSTimeInterval)duration
{
    return player.duration;
}

- (NSTimeInterval)currentTime
{
    return player.currentTime;
}

- (void)setCurrentTime:(NSTimeInterval)time
{
    currentTime = time;
    if(player.duration){
        player.currentTime = time;
    }
}

- (void)setState:(MusicPlayerState)aState
{
    if(aState == _state){
        return;
    }
    _state = aState;
}

- (void)setUrl:(NSURL *)url
{
    if([_url isEqual:url]){
        return;
    }
    [self reset];
    _url = url;
}

//播放音频
- (void)playMusic
{
    if(!audioData){
        return;
    }
    //播放本地音乐
    if(!player || player.data != audioData){
        player = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
        player.delegate = self;
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    BOOL success = [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    if(success){
        [session setActive:YES error:nil];
    }
    if([player play]){
        self.state = MusicPlayerStatePlaying;
        //开始播放通知
        if(delegate && [delegate respondsToSelector:@selector(musicPlayerDelegateBeginPlay)]){
            [delegate musicPlayerDelegateBeginPlay];
        }
        //刷新进度条
        timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                 target:self
                                               selector:@selector(refreshProgress:)
                                               userInfo:nil
                                                repeats:YES];
    }else{
        //播放失败
        [self errorCallBack];
    }
}

//播放失败
- (void)errorCallBack
{
    self.state = MusicPlayerStateIdle;
    if([delegate respondsToSelector:@selector(musicPlayerDelegateErrorDidOccur)]){
        [delegate musicPlayerDelegateErrorDidOccur];
    }
}

//刷新进度
- (void)refreshProgress:(NSTimer *)aTimer
{
    if([player isPlaying]){
        float progress = player.currentTime/player.duration;//当前时间、总时间
        //正在播放委托
        if([delegate respondsToSelector:@selector(musicPlayerDelegatePlaying:)])
        {
            [delegate musicPlayerDelegatePlaying:progress];
        }
    }
}

#pragma mark - public method
//播放音乐
- (void)play
{
    if(!_url){
        return;
    }
    if(_state==MusicPlayerStateDownloading || _state==MusicPlayerStatePlaying){
        return;
    }
    if(audioData){
        //播放
        [self playMusic];
        return;
    }
    //加载数据
    if([_url isFileURL]){
        //播放本地音频
        audioData = [NSData dataWithContentsOfURL:_url];
        if(audioData){
            //播放
            [self playMusic];
        }else{
            //失败
            [self errorCallBack];
        }
    }else{
        //获取缓存数据
        audioData = [[MyCommon audioManager] getFileWithUrl:_url];
        if(audioData){
            //播放缓存音频
            [self playMusic];
        }else{
            //开始下载音频
            self.state = MusicPlayerStateDownloading;
            if(delegate && [delegate respondsToSelector:@selector(musicPlayerDelegateBeginDownload)]){
                [delegate musicPlayerDelegateBeginDownload];
            }
            __weak typeof(self)weakSelf = self;
            operation = [[MyCommon audioManager] downloadFileWithUrl:_url progress:nil completed:^(NSString *filePath, NSError *error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    weakSelf.audioData = [NSData dataWithContentsOfFile:filePath];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(!weakSelf.operation.isCancelled){
                            if(weakSelf.audioData){
                                //播放
                                [weakSelf playMusic];
                            }else{
                                //失败
                                [weakSelf errorCallBack];
                            }
                        }
                    });
                });
            }];
        }
    }
}

//暂停
- (void)pause
{
    switch (_state) {
        case MusicPlayerStateIdle:
        case MusicPlayerStatePaused:
            return;
            break;
        case MusicPlayerStateDownloading:
            [operation cancel];
            self.state = MusicPlayerStateIdle;
            return;
            break;
        default:
            break;
    }
    [player pause];
    self.state = MusicPlayerStatePaused;
    [timer invalidate];
    //结束播放委托
    if([delegate respondsToSelector:@selector(musicPlayerDelegatePaused)]){
        [delegate musicPlayerDelegatePaused];
    }
}

//停止播放
- (void)stop
{
    switch (_state) {
        case MusicPlayerStateIdle:
            return;
            break;
        case MusicPlayerStateDownloading:
            [operation cancel];
            break;
        default:
            break;
    }
    [player stop];
    player.currentTime = 0;
    self.state = MusicPlayerStateIdle;
    [timer invalidate];
    //结束播放委托
    if([delegate respondsToSelector:@selector(musicPlayerDelegateStopped)]){
        [delegate musicPlayerDelegateStopped];
    }
}

//重置播放器
- (void)reset
{
    [self stop];
    audioData = nil;
    player = nil;
    _url = nil;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(flag){
        self.state = MusicPlayerStateIdle;
        //结束播放
        [timer invalidate];
        //结束播放委托
        if([delegate respondsToSelector:@selector(musicPlayerDelegateFinished)]){
            [delegate musicPlayerDelegateFinished];
        }
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self errorCallBack];
}

@end
