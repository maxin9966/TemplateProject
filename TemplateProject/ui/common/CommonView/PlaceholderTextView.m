//
//  PlaceholderTextView.m
//  FansKit
//
//  Created by antsmen on 14-12-30.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView()
{
    UITextView *placeholderTextView;
}

@end

@implementation PlaceholderTextView

#pragma mark Life Cycle method

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
    placeholderTextView.frame = self.bounds;
}

- (void)initialize
{
    self.placeholderColor = [UIColor lightGrayColor];
    placeholderTextView = [[UITextView alloc] init];
    placeholderTextView.backgroundColor = [UIColor clearColor];
    if(!_placeholderColor){
        _placeholderColor = [UIColor lightGrayColor];
    }
    placeholderTextView.textColor = _placeholderColor;
    placeholderTextView.font = self.font;
    placeholderTextView.userInteractionEnabled = NO;
    [self addSubview:placeholderTextView];
}

- (void)didMoveToWindow
{
    if(self.window){
        //观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark Notifications

- (void)textDidChange:(NSNotification*)notification
{
    if([notification object] != self){
        return;
    }
    placeholderTextView.hidden = self.text.length;
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

#pragma mark - Getters and Setters

- (void)setText:(NSString *)aText
{
    [super setText:aText];
    placeholderTextView.hidden = self.text.length;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    placeholderTextView.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    placeholderTextView.textAlignment = textAlignment;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    placeholderTextView.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)color
{
    _placeholderColor = color;
    placeholderTextView.textColor = color;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:contentInset];
    placeholderTextView.contentInset = contentInset;
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [super setTextContainerInset:textContainerInset];
    placeholderTextView.textContainerInset = textContainerInset;
}

@end
