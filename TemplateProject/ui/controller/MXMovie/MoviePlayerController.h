//
//  MXMoviePlayerController.h
//  LaneTrip
//
//  Created by antsmen on 15-4-13.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "MXControls.h"

/**
 
 视频播放器
 
 */

typedef enum {
    /** Controls are not doing anything */
    MXMoviePlayerControlsStateIdle,
    
    /** Controls are waiting for movie to finish loading */
    MXMoviePlayerControlsStateLoading,
    
    /** Controls are ready to play and/or playing */
    MXMoviePlayerControlsStateReady,
    
} MXMoviePlayerControlsState;

@protocol MoviePlayerControllerDelegate <NSObject>
@optional

- (void)moviePlayerControllerMovieFinished;

@end

@interface MoviePlayerController : MPMoviePlayerController

@property (nonatomic,strong) MXControls *controls;

@property (nonatomic,assign) CGFloat controlsOffsetY;

@property (nonatomic,strong) UIImageView *thumbImageView;

@property (nonatomic,assign) id<MoviePlayerControllerDelegate>delegate;

@property (nonatomic,assign) MXMoviePlayerControlsState state;

@property (nonatomic,assign) BOOL controlsEnabled; //默认YES

- (id)initWithFrame:(CGRect)frame;

- (void)setFrame:(CGRect)frame;

- (void)reset;

@end
