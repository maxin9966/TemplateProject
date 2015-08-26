//
//  IMManager.m
//  TemplateProject
//
//  Created by admin on 15/8/10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "IMManager.h"

/**
 
 即时通讯
 
 */

@interface IMManager()
<XMPPStreamDelegate>
{
//    NSString *user;
//    NSString *pwd;
    NSString *imUser;
    NSString *imPwd;
}

@end

@implementation IMManager

+ (instancetype)sharedInstance {
    static IMManager* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[IMManager alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if(self){
//        user = @"fly";
//        pwd = @"123456";
    }
    return self;
}

- (void)setupStream {
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
    if(self.delegate && [self.delegate respondsToSelector:@selector(iMManagerDidConnect)]){
        [self.delegate iMManagerDidConnect];
    }
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    if(self.delegate && [self.delegate respondsToSelector:@selector(iMManagerDidDisconnect)]){
        [self.delegate iMManagerDidDisconnect];
    }
}

- (BOOL)connectWithUser:(NSString*)user Pwd:(NSString*)pwd
{
    if (!self.xmppStream) {
        [self setupStream];
    }
    
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    
    if (user == nil || pwd == nil) {
        return NO;
    }
    
    imUser = user;
    imPwd = pwd;
    
    NSString *jid = [user stringByAppendingString:[NSString stringWithFormat:@"@%@/%@",XMPPServer,@"iOS"]];
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    [self.xmppStream setHostName:XMPPServer];
    [self.xmppStream setHostPort:XMPPServerHostPort];
    
    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    }
    
    return YES;
}

- (void)disconnect
{
    [self.xmppStream disconnect];
}

#pragma mark - XMPP Delegate

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%@",[error description]);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    NSError *error = nil;
    [self.xmppStream authenticateWithPassword:imPwd error:&error];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    [self goOnline];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    [self goOffline];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:myUsername]) {
        //好友上下线
        if ([presenceType isEqualToString:@"available"]) {
            
            //[self.delegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, kDomain]];
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            
            //[self.delegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, kDomain]];
            
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    if ([message isChatMessageWithBody]) {
        NSString *msg = [[message elementForName:@"body"] stringValue];
        NSString *from = [[message attributeForName:@"from"] stringValue];
        from = [[from componentsSeparatedByString:@"/"] objectAtIndex:0];
        NSString *msgStr = [NSString stringWithFormat:@"%@:%@",from,msg];
        
        NSLog(@"new msg:%@",msgStr);
        if(self.delegate && [self.delegate respondsToSelector:@selector(iMManagerDidReceiveNewMessage:)]){
            [self.delegate iMManagerDidReceiveNewMessage:msgStr];
        }
    }
}


@end
