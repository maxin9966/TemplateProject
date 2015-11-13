//
//  MyAudioRecorder.h
//  MeiMei
//
//  Created by 马鑫 on 14-1-21.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 
 录音
 
 */

@protocol AudioRecorderDelegate <NSObject>

- (void)audioRecorderDidRecordedByPath:(NSString*)audioPath duration:(int)duration;

- (void)audioRecorderDidFailedWithError:(NSError*)error;

- (void)audioRecorderVolumeProgressChanged:(CGFloat)volumeProgress;

@end

@interface AudioRecorder : NSObject

@property (nonatomic,weak) id<AudioRecorderDelegate> delegate;
@property (nonatomic,assign) float maxDuration;//默认60秒

//开始录音
- (void)startRecord;

//暂停
- (void)pauseRecord;

//录音结束
- (void)stopRecord;

//取消录音
- (void)cancelRecord;

@end
