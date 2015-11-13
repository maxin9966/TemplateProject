//
//  IMViewController.m
//  TemplateProject
//
//  Created by admin on 15/8/11.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "IMViewController.h"
#import "IMManager.h"

@interface IMViewController ()
<IMManagerDelegate>
{
    IBOutlet UITextField *userTF;
    IBOutlet UITextField *pwdTF;
    IBOutlet UITextField *toUserTF;
    IBOutlet UITextField *toContentTF;
}

@end

@implementation IMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action

- (IBAction)connectAction:(id)sender
{
    NSString *user = userTF.text;
    NSString *pwd = pwdTF.text;
    if(!user.length || !pwd.length){
        return;
    }
    [IMManager sharedInstance].delegate = self;
    [[IMManager sharedInstance] connectWithUser:user Pwd:pwd];
}

- (IBAction)sendAction:(id)sender
{
    NSString *mesStr = toContentTF.text;
    NSString *toUser = toUserTF.text;
    if(!mesStr.length || !toUser.length){
        return;
    }
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:mesStr];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[toUser stringByAppendingString:[NSString stringWithFormat:@"@%@",XMPPServer]]];
    [message addChild:body];
    
    [[IMManager sharedInstance].xmppStream sendElement:message];
}

- (IBAction)closeKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - IMManagerDelegate
- (void)iMManagerDidConnect
{
    [MyCommon showTips:@"已连接"];
}

- (void)iMManagerDidDisconnect
{
    [MyCommon showTips:@"已断开连接"];
}

- (void)iMManagerDidReceiveNewMessage:(NSString*)msg
{
    [MyCommon showTips:msg];
}

@end
