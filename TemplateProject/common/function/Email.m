//
//  Email.m
//  FansKit
//
//  Created by antsmen on 15-1-21.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "Email.h"

#define EmailRelayHost @"smtp.163.com"
#define EmailLoginEmail @"18817999163@163.com"
#define EmailLoginPwd @"mx10002000"

@interface Email()
<SKPSMTPMessageDelegate>
{
    NSMutableDictionary *completionDict;
    NSInteger index;
}

@end

@implementation Email

+ (instancetype)sharedInstance {
    static Email* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    if(self = [super init]){
        completionDict = [NSMutableDictionary new];
    }
    return self;
}

- (void)sendToEmail:(NSString*)toEmail subject:(NSString*)subject content:(NSString*)content completion:(BooleanBlock)block
{
    if(!subject.length || !toEmail.length){
        return;
    }
    SKPSMTPMessage *smtpMsg = [[SKPSMTPMessage alloc] init];
    //发送者
    smtpMsg.fromEmail = EmailLoginEmail;
    //发送给
    smtpMsg.toEmail = toEmail;
    //抄送联系人列表，如：@"664742641@qq.com;1@qq.com;2@q.com;3@qq.com"
    //smtpMsg.ccEmail = @"lanyuu@live.cn";
    //密送联系人列表，如：@"664742641@qq.com;1@qq.com;2@q.com;3@qq.com"
    //smtpMsg.bccEmail = @"664742641@qq.com";
    //发送服务器地址
    //smtpMsg.relayHost = @"smtp.exmail.sina.com";
    smtpMsg.relayHost = EmailRelayHost;
    //需要鉴权
    smtpMsg.requiresAuth = YES;
    //发送者的登录账号
    smtpMsg.login = EmailLoginEmail;
    //发送者的登录密码
    smtpMsg.pass = EmailLoginPwd;
    //邮件主题
    smtpMsg.subject = subject;
    
    smtpMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
    
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    smtpMsg.delegate = self;
    
    //主题
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               content,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
//    //附件
//    NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"video.jpg" ofType:@""];
//    NSData *vcfData = [NSData dataWithContentsOfFile:vcfPath];
//    
//    //附件图片文件
//    NSDictionary *vcfPart = [[NSDictionary alloc ]initWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"video.jpg\"",kSKPSMTPPartContentTypeKey,
//                             @"attachment;\r\n\tfilename=\"video.jpg\"",kSKPSMTPPartContentDispositionKey,[vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
//    //附件音频文件
//    NSString *wavPath = [[NSBundle mainBundle] pathForResource:@"push" ofType:@"wav"];
//    NSData *wavData = [NSData dataWithContentsOfFile:wavPath];
//    NSDictionary *wavPart = [[NSDictionary alloc ]initWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"push.wav\"",kSKPSMTPPartContentTypeKey,
//                             @"attachment;\r\n\tfilename=\"push.wav\"",kSKPSMTPPartContentDispositionKey,[wavData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
//    smtpMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,wavPart, nil];
    
    smtpMsg.parts = @[plainPart];
    
    //block
    NSString *tag = [MyCommon createUUID];
    smtpMsg.tag = tag;
    if(block){
        [completionDict setObject:block forKey:tag];
    }
    
    [smtpMsg send];
}

#pragma mark - SKPSMTPMessageDelegate
- (void)messageSent:(SKPSMTPMessage *)message
{
    NSString *tag = message.tag;
    BooleanBlock block = [completionDict objectForKey:tag];
    if(block){
        block(YES,nil);
        [completionDict removeObjectForKey:tag];
    }
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSString *tag = message.tag;
    BooleanBlock block = [completionDict objectForKey:tag];
    if(block){
        block(NO,error);
        [completionDict removeObjectForKey:tag];
    }
}

@end
