//
//  VideoPlayerView.m
//  MeiMei
//
//  Created by 马鑫 on 14-4-22.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import "VideoPlayerView.h"
//#import <MediaPlayer/MediaPlayer.h>
//#import "ALMoviePlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "BlockAlertView.h"
#import "XLoader.h"
#import "MoviePlayerController.h"

static NSString *operationKey = @"videoThumbnailOperationKey";

@interface VideoPlayerView()
<UIAlertViewDelegate,MoviePlayerControllerDelegate>
{
    MoviePlayerController *player;
    
    XLoader *loader;
}

@end

@implementation VideoPlayerView
@synthesize url;
@synthesize delegate;
@synthesize thumbnail;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        loader = [[XLoader alloc] init];
        
        //player
        player = [[MoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        player.delegate = self;
        [self addSubview:player.view];
        player.controlsOffsetY = ControlsOffsetY;
        player.controls.backgroundColor = RGBA(0, 0, 0, 0.35);
        
//        bigThumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        bigThumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [player.view insertSubview:bigThumbnailImageView belowSubview:(UIView*)player.controls];

//        //播放按钮
//        playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGFloat playSideLength = 64;
//        playVideoButton.frame = CGRectMake(frame.size.width/2-playSideLength/2, frame.size.height/2-playSideLength/2, playSideLength, playSideLength);
//        [playVideoButton setBackgroundImage:[UIImage imageNamed:@"video_play_blue"] forState:UIControlStateNormal];
//        [playVideoButton setBackgroundImage:[UIImage imageNamed:@"video_stop_blue"] forState:UIControlStateSelected];
//        [playVideoButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [player.view addSubview:playVideoButton];
//        
//        tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        tapBtn.frame = player.view.frame;
//        [tapBtn addTarget:self action:@selector(tapGes:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (UIImage*)thumbnail
{
    return player.thumbImageView.image;
}

- (void)setUrl:(NSURL *)mUrl
{
    [self setUrl:mUrl Thumbnail:nil];
}

- (void)setUrl:(NSURL *)mUrl Thumbnail:(NSURL*)thumbnailURL
{
    [self clear];
    url = mUrl;
    [[XLoader defaultLoader] cancelByKey:operationKey];
    [player.thumbImageView mx_cancelCurrentImageLoad];
    if(url){
        [player setContentURL:url];
        if(![self isLocalURL:url]){
            //远程
            [player.thumbImageView mx_setImageWithURL:[thumbnailURL absoluteString] placeholderImage:nil];
        }else{
            //本地
            [loader loadForKey:operationKey loadBlock:^id{
                return [self getThumbnailImage:url];
            } finishedBlock:^(id key, id object) {
                player.thumbImageView.image = (UIImage*)object;
            }];
        }
    }
}

- (void)play
{
    [player play];
}

- (void)stop
{
    [player stop];
}

- (void)clear
{
    player.thumbImageView.image = nil;
    url = nil;
    [[XLoader defaultLoader] cancelByKey:operationKey];
    [player reset];
}

#pragma mark - Method
//获取第一帧
- (UIImage *)getThumbnailImage:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 60);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

- (BOOL)isLocalURL:(NSURL*)mUrl
{
    if(mUrl){
        return [mUrl.scheme isEqualToString:@"file"];
    }
    return NO;
}

#pragma mark - MXMoviePlayerControllerDelegate
- (void)moviePlayerControllerMovieFinished
{
    [self stop];
    if(delegate && [delegate respondsToSelector:@selector(videoPlayerViewDelegatePlaybackDidFinish)]){
        [delegate videoPlayerViewDelegatePlaybackDidFinish];
    }
}

@end
