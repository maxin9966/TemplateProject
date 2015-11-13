//
//  MyCommon.m
//  FansKit
//
//  Created by MA on 14/12/1.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "MyCommon.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "lame.h"
#include <sys/sysctl.h>
#include <mach/mach.h>
#import <AVFoundation/AVFoundation.h>

@implementation MyCommon

+ (NSArray *)backBarButtonItemWithTarget:(id)target withSelector:(SEL)selector
{
    return [MyCommon customBarButtonItemWithTarget:target withSelector:selector withBtnImage:@"navigation_back" withBtnHighlightImage:@"navigation_back"];
}

+ (NSArray *)doneBarButtonItemWithTarget:(id)target withSelector:(SEL)selector
{
    return [MyCommon customBarButtonItemWithTarget:target withSelector:selector withBtnImage:@"navigation_confirm_white" withBtnHighlightImage:@"navigation_confirm_white"];
}

+ (NSArray *)customBarButtonItemWithTarget:(id)target withSelector:(SEL)selector withBtnImage:(NSString *)image withBtnHighlightImage:(NSString *)highlightImage
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if(highlightImage){
        [btn setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    }
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    return [NSArray arrayWithObjects:negativeSpacer,itemBtn,nil];
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString*)title target:(id)target withSelector:(SEL)selector
{
    NSMutableDictionary *normalDict = [[UINavigationBar appearance].titleTextAttributes mutableCopy];
    NSMutableDictionary *highlightedDict = [[UINavigationBar appearance].titleTextAttributes mutableCopy];
    [normalDict setObject:LT_NavigationBarTitleFont forKey:NSFontAttributeName];
    [highlightedDict setObject:LT_NavigationBarTitleFont forKey:NSFontAttributeName];
    [highlightedDict setObject:LT_NavigationBarTitleColor forKey:NSForegroundColorAttributeName];
    [normalDict removeObjectForKey:NSShadowAttributeName];
    [highlightedDict removeObjectForKey:NSShadowAttributeName];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    [btnItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [btnItem setTitleTextAttributes:highlightedDict forState:UIControlStateHighlighted];
    return btnItem;
}

//内存占用 字节
+ (int)availableMemory;
{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
    {
#if DEBUG
        NSLog(@"Failed to fetch vm statistics");
#endif
        return 0;
    }
    
    //	natural_t   mem_free = vm_stat.free_count * pagesize;
    //    return mem_free;
    natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    return mem_used;
    //	natural_t   mem_total = mem_used + mem_free;
    //	return mem_total;
}

//文件管理器
+ (PUFileManager*)fileManger
{
    static PUFileManager *puFileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        puFileManager = [[PUFileManager alloc] initWithNamespace:@"MXFileCache"];
    });
    return puFileManager;
}

//音频管理器
+ (PUFileManager*)audioManager
{
    static PUFileManager *puAudioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        puAudioManager = [[PUFileManager alloc] initWithNamespace:@"MXAudioCache"];
    });
    return puAudioManager;
}

//图片管理器
+ (PUImageManager*)imageManager
{
    static PUImageManager *puImageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        puImageManager = [[PUImageManager alloc] initWithNamespace:@"MXImageCache"];
    });
    return puImageManager;
}

//save userDefault
+ (BOOL)saveDataToUserDefault:(id)data WithKey:(NSString *)key
{
    if(!data || !key){
        return NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:key];
    return [defaults synchronize];
}

//get userDefault
+ (id)getDataFromUserDefaultWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id object = [defaults objectForKey:key];
    return object;
}

//remove userDefault
+ (BOOL)removeDataFromUserDefaultWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    return [defaults synchronize];
}

//电话正则
+ (BOOL)isMobile:(NSString *)mobileNumber
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9])\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL isPhone = [mobileTest evaluateWithObject:mobileNumber];
    if (isPhone) {
        return YES;
    }
    return NO;
}

//邮箱匹配
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex =  @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    NSPredicate *emailTest = [ NSPredicate predicateWithFormat : @"SELF MATCHES%@",emailRegex];
    BOOL isMail = [emailTest evaluateWithObject:email];
    if (isMail) {
        return YES;
    }
    return NO;
}

//获取uuid
+ (NSString *)createUUID{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result =[NSString stringWithFormat:@"%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}

//获取纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//关闭键盘
+ (void)closeKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

//获取normal level window
+ (UIWindow*)normalLevelWindow
{
    NSInteger windowCount = [UIApplication sharedApplication].windows.count;
    for(NSInteger i=windowCount-1;i>=0;i--){
        UIWindow *w = [[UIApplication sharedApplication].windows objectAtIndex:i];
        if(w.windowLevel==UIWindowLevelNormal){
            return w;
        }
    }
    return nil;
}

//动画类型
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}

//显示提示框
+(UIAlertView*)showTips:(NSString*)string
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    return alert;
}

//显示提示框 一定时间内不再提示 interval传0则表示永不重复
+ (UIAlertView*)showTips:(NSString *)string key:(NSString*)key noRepeatInterval:(NSTimeInterval)interval
{
    if(!key.length){
        return nil;
    }
    NSDate *date = [MyCommon getDataFromUserDefaultWithKey:key];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval elapsedTime = [nowDate timeIntervalSinceDate:date];
    if(interval){
        if(!date || elapsedTime>=interval){
            [MyCommon saveDataToUserDefault:nowDate WithKey:key];
            return [MyCommon showTips:string];
        }
    }else{
        //显示一次之后永不提示
        if(!date){
            [MyCommon saveDataToUserDefault:nowDate WithKey:key];
            return [MyCommon showTips:string];
        }
    }
    return nil;
}

//执行某些代码 一定时间内不重复 interval传0则表示永不重复
+ (void)executing:(dispatch_block_t)block key:(NSString*)key noRepeatInterval:(NSTimeInterval)interval
{
    if(!block || !key.length){
        return;
    }
    NSDate *date = [MyCommon getDataFromUserDefaultWithKey:key];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval elapsedTime = [nowDate timeIntervalSinceDate:date];
    if(interval){
        if(!date || elapsedTime>=interval){
            [MyCommon saveDataToUserDefault:nowDate WithKey:key];
            block();
        }
    }else{
        //显示一次之后永不重复
        if(!date){
            [MyCommon saveDataToUserDefault:nowDate WithKey:key];
            block();
        }
    }
}

//视频转MP4 (截取10秒 带声音)
+ (void)encodeVideoByUrl:(NSURL*)_videoURL ToUrl:(NSURL*)_mp4URL Quality:(NSString *const)quality Completion:(void (^)(BOOL isSuccess))completion
{
    if(!_videoURL){
        if(completion)
            completion(NO);
    }
    if([[NSFileManager defaultManager] removeItemAtPath:[_mp4URL absoluteString] error:nil])
        NSLog(@"Delete old MP4 Successful!");
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    CMTime assetTime = [avAsset duration];
    Float64 duration = CMTimeGetSeconds(assetTime);
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSString *mQuality;
    if(quality.length)
        mQuality = quality;
    else
        mQuality = AVAssetExportPresetMediumQuality;
    if ([compatiblePresets containsObject:mQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:mQuality];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString *_mp4Path = [_mp4URL absoluteString];
        
        exportSession.outputURL = [NSURL fileURLWithPath:_mp4Path];
        exportSession.shouldOptimizeForNetworkUse = YES;
        //格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        //截取时间
        float trimDuration = 10.0;
        if(trimDuration>duration){
            trimDuration = duration;
        }
        //开始时间
        CMTime start = CMTimeMakeWithSeconds(0.0, avAsset.duration.timescale);
        //结束时间
        CMTime cmDuration = CMTimeMakeWithSeconds(trimDuration, avAsset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, cmDuration);
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:{
                    NSLog(@"Convert to MP4 Failed!");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(completion)
                            completion(NO);
                    });
                }
                    break;
                case AVAssetExportSessionStatusCancelled:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(completion)
                            completion(NO);
                    });
                }
                    break;
                case AVAssetExportSessionStatusCompleted:{
                    NSLog(@"Convert to MP4 Successful!");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(completion)
                            completion(YES);
                    });
                }
                    break;
                default:
                    break;
            }
        }];
    }
    else
    {
        NSLog(@"AVAsset doesn't support mp4 quality");
    }
}

//PCM转MP3
+ (void)audio_PCMtoMP3_WavPath:(NSString*)pcmFilePath MP3Path:(NSString*)mp3FilePath
{
    [[NSFileManager defaultManager] removeItemAtPath:mp3FilePath error:nil];
    @try {
        int read, write;
        
        FILE *pcm = fopen([pcmFilePath cStringUsingEncoding:NSASCIIStringEncoding], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:NSASCIIStringEncoding], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"PCMtoMP3_exception:%@",[exception description]);
    }
    @finally {
        NSLog(@"PCMtoMP3_success");
    }
}

//检测网络通畅
+ (BOOL)isEnableNetwork
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

//检测网络类型
+ (NetworkStatus)getNetworkType
{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
}

//size to fit
+ (void)sizeToFitWithLabel:(UILabel*)label
{
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, 99999, 99999);
    [label sizeToFit];
}

+ (void)widthToFitWithLabel:(UILabel*)label
{
    CGFloat height = label.frame.size.height;
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, 99999, label.frame.size.height);
    [label sizeToFit];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
}

+ (void)widthToFitWithLabel:(UILabel*)label widthLimmit:(CGFloat)limmit
{
    if(limmit<0){
        return;
    }
    CGFloat height = label.frame.size.height;
    [label sizeToFit];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width>limmit ? limmit:label.frame.size.width, height);
}

//放大动画
+(void)zoomAnimation:(UIView*)view completion:(void (^)(BOOL finished))completion;
{
    NSTimeInterval duration = 0.15;
    //先放大
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished){
        if (finished){
            //缩小
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                if(completion){
                    completion(finished);
                }
            }];
        }}];
}

//头像图片压缩
+ (UIImage*)avatarCompression:(UIImage*)avatarImg
{
    if(avatarImg.size.width!=avatarImg.size.height){
        //居中裁剪
        avatarImg = [avatarImg centerOfCropToSquare];
    }
    float imageSide = avatarImg.size.width;
    if(imageSide>Avatar_MAX_SIDE_LENGTH){
        avatarImg = [avatarImg aspectFit:CGSizeMake(Avatar_MAX_SIDE_LENGTH, Avatar_MAX_SIDE_LENGTH)];
    }
    //压缩
    NSData  *imageData = UIImageJPEGRepresentation(avatarImg,PhotoCompressionRatio);
    if(imageData){
        avatarImg = [UIImage imageWithData:imageData];
    }
    return avatarImg;
}

//校爆图片降低分辨率
+ (UIImage*)reduceResolution:(UIImage*)image
{
    static NSLock *reduceResolutionLockInstance = nil;
    float width = image.size.width;
    float height = image.size.height;
    BOOL isLock = NO;
    if(width*height>600*600){
        if(!reduceResolutionLockInstance){
            reduceResolutionLockInstance = [[NSLock alloc] init];
        }
        //大图加锁 减少内存开销
        [reduceResolutionLockInstance lock];
        isLock = YES;
    }
    if(width>0 || height>0){
        //降低分辨率
        //规则1
        float scale = 1;
        if(width>height){
            if(height>SCREEN_HEIGHT*SCREEN_SCALE*1.8){
                scale = SCREEN_HEIGHT*SCREEN_SCALE*1.8/height;
            }
        }else{
            if(width>SCREEN_WIDTH*SCREEN_SCALE*1.8){
                scale = SCREEN_WIDTH*SCREEN_SCALE*1.8/width;
            }
        }
        //规则2
        if((width*scale)*(height*scale)>Photo_MAX_SIZE){
            scale = sqrt(Photo_MAX_SIZE/(width*height));
        }
        if(scale<1){
            image = [image scaledToWidth:width*scale];
            NSLog(@"压缩完之后的分辨率：%.1f %.1f",width*scale,height*scale);
        }
    }
    if(isLock){
        [reduceResolutionLockInstance unlock];
        isLock = NO;
    }
    return image;
}

//用户相片图片压缩
+ (UIImage*)photoCompress:(UIImage*)image
{
    image = [MyCommon reduceResolution:image];
    //压缩
    NSData  *imageData = UIImageJPEGRepresentation(image,PhotoCompressionRatio);
    if(imageData){
        image = [UIImage imageWithData:imageData];
    }
    NSLog(@"处理完后的图片大小：%d",(int)imageData.length);
    return image;
}

//随机获取的图片地址
+ (NSURL*)getRandomImageURL
{
    static NSArray *array = @[@"http://c.hiphotos.baidu.com/image/w%3D400/sign=b03ada3ee8c4b7453494b616fffd1e78/7af40ad162d9f2d3ed4378f8aaec8a136327cc53.jpg",
                              @"http://b.hiphotos.baidu.com/image/w%3D400/sign=f22ba6edf503918fd7d13cca613d264b/359b033b5bb5c9ea84c2f2eed739b6003af3b38e.jpg",
                              @"http://h.hiphotos.baidu.com/image/w%3D400/sign=c2815beea486c91708035339f93d70c6/d50735fae6cd7b89c91a85950c2442a7d9330eb5.jpg",
                              @"http://b.hiphotos.baidu.com/image/w%3D400/sign=35c6e6fb79cb0a4685228a395b63f63e/0dd7912397dda144940168b3b0b7d0a20cf486a2.jpg",
                              @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c30ffe5057fbb2fb342b59127f4b2043/3bf33a87e950352a5cbdd3055143fbf2b3118bdb.jpg",
                              @"http://e.hiphotos.baidu.com/image/w%3D400/sign=9a43780e8594a4c20a23e62b3ef51bac/f636afc379310a55ffd247f5b54543a982261038.jpg",
                              @"http://d.hiphotos.baidu.com/image/w%3D400/sign=2a3688356c061d957d4636384bf40a5d/6a63f6246b600c3304732fc5184c510fd9f9a1b1.jpg",];
    NSURL *url = [NSURL URLWithString:[array objectAtIndex:arc4random()%array.count]];
    return url;
}

+ (NSString *)readableValueWithBytes:(id)bytes
{
    NSString *readable = @"";
    //round bytes to one kilobyte, if less than 1024 bytes
    if (([bytes longLongValue] < 1024)){
        readable = [NSString stringWithFormat:@"1 KB"];
    }
    //kilobytes
    if (([bytes longLongValue]/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld KB", ([bytes longLongValue]/1024)];
    }
    //megabytes
    if (([bytes longLongValue]/1024/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld MB", ([bytes longLongValue]/1024/1024)];
    }
    //gigabytes
    if (([bytes longLongValue]/1024/1024/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld GB", ([bytes longLongValue]/1024/1024/1024)];
    }
    //terabytes
    if (([bytes longLongValue]/1024/1024/1024/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld TB", ([bytes longLongValue]/1024/1024/1024/1024)];
    }
    //petabytes
    if (([bytes longLongValue]/1024/1024/1024/1024/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld PB", ([bytes longLongValue]/1024/1024/1024/1024/1024)];
    }
    return readable;
}

+ (NSDictionary*)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = @"";
        if (kv.count > 1) {
            val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        if (kv.count > 0) {
            [params setObject:val forKey:kv[0]];
        }
    }
    return params;
}

//获取错误信息
+ (NSError*)getErrorWithResponse:(NSDictionary*)dict
{
    NSInteger errorCode = [[dict objectForKey:@"errCode"] integerValue];
    if(errorCode){
        NSString *errMsg = [dict objectForKey:@"errMsg"];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:[[self class] description] code:errorCode userInfo:userInfo];
        return error;
    }else{
        return nil;
    }
}

//获取请求失败的error
+ (NSError*)getFailureError:(NSError*)originError
{
    NSInteger errorCode = 0;
    NSString *domain = nil;
    NSString *tip = nil;
    NSDictionary *userInfo = nil;
    static NSString *errorTip = @"服务器繁忙 请稍后再试";
    if(originError){
        errorCode = originError.code;
        domain = originError.domain;
        //错误提示
        if([MyCommon isEnableNetwork]){
            switch (originError.code) {
                case NSURLErrorCancelled:
                    tip = @"请求已被取消";
                    break;
                case NSURLErrorTimedOut:
                    tip = @"服务器无响应 请稍后再试";
                    break;
                default:
                    tip = errorTip;
                    break;
            }
        }else{
            tip = @"网络无法连接";
        }
        //替换错误信息
        NSMutableDictionary *dict = [originError.userInfo mutableCopy];
        [dict setObject:tip forKey:NSLocalizedFailureReasonErrorKey];
        userInfo = [dict copy];
    }else{
        //默认
        errorCode = -99999;
        domain = [[self class] description];
        tip = errorTip;
        userInfo = [NSDictionary dictionaryWithObject:tip forKey:NSLocalizedFailureReasonErrorKey];
    }
    NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:userInfo];
    return error;
}

+ (NSDate*)dateWithTimeIntervalSince1970:(NSTimeInterval)interval
{
    return ([NSDate dateWithTimeIntervalSince1970:interval*TimeFactor]);
}

//根据date获取时间戳
+ (NSTimeInterval)timeIntervalWithDate:(NSDate*)date
{
    return [date timeIntervalSince1970]/TimeFactor;
}

+ (AppDelegate*)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

//屏幕截图
- (UIImage*)getScreenImageAfterScreenUpdates:(BOOL)afterScreenUpdates
{
    UIView * view = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:afterScreenUpdates];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
