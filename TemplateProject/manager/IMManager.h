//
//  IMManager.h
//  TemplateProject
//
//  Created by admin on 15/8/10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

#define XMPPServer @"218.244.150.107"
#define XMPPServerHostPort 5222

@protocol IMManagerDelegate <NSObject>

- (void)iMManagerDidConnect;

- (void)iMManagerDidDisconnect;

- (void)iMManagerDidReceiveNewMessage:(NSString*)msg;

@end

@interface IMManager : NSObject

@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,weak) id<IMManagerDelegate>delegate;

+ (instancetype)sharedInstance;

- (BOOL)connectWithUser:(NSString*)user Pwd:(NSString*)pwd;

- (void)disconnect;

@end
