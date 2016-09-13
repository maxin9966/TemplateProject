//
//  CustomTextField.m
//  YanMo-Artist
//
//  Created by admin on 15/12/29.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    if(self = [super init]){
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)initialize
{
    //观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self];
}

#pragma mark Notifications

- (void)textDidChange:(NSNotification*)notification
{
    if([notification object] != self){
        return;
    }
    if(_textLimit<=0){
        return;
    }
    NSString *toBeString = self.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    //en-US 英文
    //zh-Hans 简体中文输入，包括简体拼音，健体五笔，简体手写
    //判断中文检测是否为zh或-zh开头
    if (![lang isEqualToString:@"en-US"]) {
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > _textLimit) {
                self.text = [toBeString substringToIndex:_textLimit];
            }
        }else{
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        }
    }else{
        if (toBeString.length > _textLimit) {
            self.text = [toBeString substringToIndex:_textLimit];
        }
    }
}

@end
