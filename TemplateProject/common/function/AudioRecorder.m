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
    NSURL *fileURL;
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
//#define AudioRecoderAMRFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/AudioRecoderFile.amr"]
//#define AudioRecoderMP3FilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/AudioRecoderFile.mp3"]

- (id)init
{
    self = [super init];
    if(self){
        maxDuration = 60.f;
        //voiceHud_ = [[LCVoiceHud alloc] init];
        //fileURL = [NSURL fileURLWithPath:[[MyCommon audioManager].cacheManager cachePathForKey:[MyCommon createUUID]]];  //文件名的设置
        fileURL = [NSURL fileURLWithPath:AudioRecoderFilePath];
        NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithFloat: 12000.0],AVSampleRateKey, //采样率
                                       [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                       [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数  默认 16
                                       [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,//通道的数目
                                       [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                       [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                       [NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,nil];//采样信号是整数还是浮点数
        
        NSError *error = nil;
        audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:recordSetting error:&error];
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

//请求允许录音
+ (void)askForRecord
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        AVAudioSessionRecordPermission state = [audioSession recordPermission];
        if(state<AVAudioSessionRecordPermissionGranted){
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    NSLog(@"用户允许录音");
                } else {
                    NSLog(@"用户不允许录音");
                    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置-隐私-麦克风”选项中，允许我们使用你的麦克风。" actionBlock:^(NSInteger buttonIndex) {
                        if(buttonIndex==1){
                            [[UIApplication sharedApplication] openURL:
                             [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }
                    } cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即开启", nil];
                    [alert show];
                }
            }];
        }
    }
}

//开始录音
- (void)startRecord
{
    NSLog(@"录音即将开始");
    if(!audioRecorder || [audioRecorder isRecording])
        return;
    [[NSFileManager defaultManager] removeItemAtPath:[audioRecorder.url path] error:nil];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//iPod无法录音 错误提示：Microphone input permission refused - will record only silence
    if(session){
        [session setActive:YES error:nil];
    }
    [audioRecorder prepareToRecord];
    if([audioRecorder recordForDuration:maxDuration]){
        NSLog(@"录音开始");
        [self timerStart:YES];
    }else{
        [self resetSession];
    }
}

//暂停
- (void)pauseRecord
{
    if(!audioRecorder || ![audioRecorder isRecording])
        return;
    [self timerStart:NO];
    [audioRecorder pause];
}

//录音结束
- (void)stopRecord
{
    [self timerStart:NO];
    if(audioRecorder && audioRecorder.isRecording){
        [audioRecorder stop];
    }
}

//取消录音
- (void)cancelRecord
{
    [self timerStart:NO];
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
    [self timerStart:NO];
    if(flag){
        AVAudioPlayer *avPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:recorder.url error:nil];
        NSTimeInterval duration = avPlayer.duration;
        if(duration>=1.0){
            NSLog(@"录音成功");
            //转MP3
            NSString *desMp3Path = [[MyCommon audioManager].cacheManager cachePathForKey:[MyCommon createUUID]];
            [MyCommon audio_PCMtoMP3_WavPath:[recorder.url path] MP3Path:desMp3Path];
            //转amr
            //[VoiceConverter wavToAmr:AudioRecoderFilePath amrSavePath:AudioRecoderAMRFilePath];
            //录音成功通知
            if([[NSFileManager defaultManager] fileExistsAtPath:desMp3Path]){
                if(delegate && [delegate respondsToSelector:@selector(audioRecorderDidRecordedByPath:duration:)]){
                    [delegate audioRecorderDidRecordedByPath:desMp3Path duration:(int)duration];
                }
            }else{
                NSLog(@"音频格式转换失败");
                [self recordFailedWithError:[MyCommon getErrorWithFailureReason:@"音频格式转换失败"]];
            }
        }else{
            NSLog(@"录音时间过短");
            [self recordFailedWithError:[MyCommon getErrorWithFailureReason:@"录音时间过短"]];
        }
    }
    [self resetSession];
}

- (void)recordFailedWithError:(NSError*)error
{
    if(delegate && [delegate respondsToSelector:@selector(audioRecorderDidFailedWithError:)]){
        [delegate audioRecorderDidFailedWithError:error];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    [self recordFailedWithError:error];
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{

}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{

}

#pragma mark - Timer Update

- (void)updateMeters {
    
    /*  发送updateMeters消息来刷新平均和峰值功率。
     *  此计数是以对数刻度计量的，-160表示完全安静，
     *  0表示最大输入值
     */
    
    if (audioRecorder) {
        [audioRecorder updateMeters];
    }
    
    float peakPower = [audioRecorder averagePowerForChannel:0];
    double ALPHA = 0.04;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    if(delegate && [delegate respondsToSelector:@selector(audioRecorderVolumeProgressChanged:)]){
        [delegate audioRecorderVolumeProgressChanged:peakPowerForChannel];
    }
    //[voiceHud_ setProgress:peakPowerForChannel];
}

- (void)timerStart:(BOOL)yesOrNo
{
    [timer invalidate];
    if(yesOrNo){
        timer = [MyTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    }
}

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
