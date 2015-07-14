//
//  MyAudioRecorder.m
//  MeiMei
//
//  Created by 马鑫 on 14-1-21.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import "AudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
//#import "VoiceConverter.h"
//#import "LCVoiceHud.h"

@interface AudioRecorder()
<AVAudioRecorderDelegate>
{
    AVAudioRecorder *audioRecorder;//录音
    AVAudioPlayer *player;
    NSURL *filePath;
    AVAudioSession *session;
    
    MyTimer *timer;
    //动画
    //LCVoiceHud *voiceHud_;
}

@end

@implementation AudioRecorder
@synthesize delegate;
@synthesize maxDuration;

#define AudioRecoderFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/AudioRecoderFile.wav"]
#define AudioRecoderAMRFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/AudioRecoderFile.amr"]
#define AudioRecoderMP3FilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/AudioRecoderFile.mp3"]

-(id)init
{
    self = [super init];
    if(self){
        maxDuration = 60.f;
        //voiceHud_ = [[LCVoiceHud alloc] init];
        filePath = [NSURL fileURLWithPath:AudioRecoderFilePath];  //文件名的设置
        NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithFloat: 12000.0],AVSampleRateKey, //采样率
                                       [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                       [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数  默认 16
                                       [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,//通道的数目
                                       [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                       [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                       [NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,nil];//采样信号是整数还是浮点数
        NSError *error = nil;
        audioRecorder = [[AVAudioRecorder alloc] initWithURL:filePath settings:recordSetting error:&error];
        if(error){
            NSLog(@"AVAudioInit Error:%@",error.description);
        }
        audioRecorder.meteringEnabled = YES;
        audioRecorder.delegate = self;
        //session
        session = [AVAudioSession sharedInstance];
    }
    return self;
}

//开始录音
-(void)startRecord
{
    if(!audioRecorder || [audioRecorder isRecording])
        return;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//iPod无法录音 错误提示：Microphone input permission refused - will record only silence
    if(session){
        [session setActive:YES error:nil];
    }
    if([audioRecorder recordForDuration:maxDuration]){
        NSLog(@"录音开始");
        //动画
        //[self showVoiceHudOrHide:YES];
    }else{
        [self resetSession];
    }
}

//暂停
-(void)pauseRecord
{
    if(!audioRecorder || ![audioRecorder isRecording])
        return;
    //[self showVoiceHudOrHide:NO];
    [audioRecorder pause];
}

//录音结束
-(void)stopRecord
{
    //[self showVoiceHudOrHide:NO];
    if(audioRecorder && audioRecorder.isRecording){
        [audioRecorder stop];
    }
}

//取消录音
-(void)cancelRecord
{
    //[self showVoiceHudOrHide:NO];
    if(audioRecorder && audioRecorder.isRecording){
        [audioRecorder stop];
        NSLog(@"录音取消");
        [self resetSession];
    }
}

- (void)resetSession
{
    if(session){
        [session setActive:NO error:nil];
        [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //[self showVoiceHudOrHide:NO];
    if(flag){
        AVAudioPlayer *avPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:AudioRecoderFilePath] error:nil];
        NSTimeInterval duration = avPlayer.duration;
        if(duration>=1.0){
            NSLog(@"录音成功");
            //转MP3
            [MyCommon audio_PCMtoMP3_WavPath:AudioRecoderFilePath MP3Path:AudioRecoderMP3FilePath];
            //转amr
            //[VoiceConverter wavToAmr:AudioRecoderFilePath amrSavePath:AudioRecoderAMRFilePath];
            //录音成功通知
            if(delegate && [delegate respondsToSelector:@selector(audioRecorderDidRecordedByPath:duration:)]){
                [delegate audioRecorderDidRecordedByPath:AudioRecoderMP3FilePath duration:(int)duration];
            }
        }else{
            NSLog(@"录音时间过短");
        }
    }
    [self resetSession];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{

}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{

}

//#pragma mark - Timer Update
//
//- (void)updateMeters {
//    
//    if (voiceHud_)
//    {
//        /*  发送updateMeters消息来刷新平均和峰值功率。
//         *  此计数是以对数刻度计量的，-160表示完全安静，
//         *  0表示最大输入值
//         */
//        
//        if (audioRecorder) {
//            [audioRecorder updateMeters];
//        }
//        
//        float peakPower = [audioRecorder averagePowerForChannel:0];
//        double ALPHA = 0.04;
//        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
//        [voiceHud_ setProgress:peakPowerForChannel];
//    }
//}
//#pragma mark - Helper Function
//
//-(void) showVoiceHudOrHide:(BOOL)yesOrNo{
//    [voiceHud_ removeFromSuperview];
//    [timer invalidate];
//    if (yesOrNo) {
//        [voiceHud_ show];
//        [timer invalidate];
//        timer = [MyTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
//    }
//}

@end
