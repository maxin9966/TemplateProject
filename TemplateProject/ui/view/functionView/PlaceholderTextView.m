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
    BOOL isKeyboardShow;
    CGFloat superOriginY;
    UITextView *placeholderTextView;
}

@end

@implementation PlaceholderTextView

#pragma mark -
#pragma mark Life Cycle method

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
    self.autoUplift = YES;
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
    self.autoUplift = self.autoUplift;
}

#pragma mark -
#pragma mark Notifications

- (void)textDidChange:(NSNotification *)notification
{
    placeholderTextView.hidden = self.text.length;
    if(_limmitNumber>0){
        if(self.text.length>_limmitNumber){
            self.text = [self.text substringToIndex:_limmitNumber];
        }
    }
}

#pragma mark - Getters and Setters

- (void)setText:(NSString *)aText
{
    [super setText:aText];
    placeholderTextView.hidden = self.text.length;
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

- (void)setAutoUplift:(BOOL)b
{
    _autoUplift = b;
    if(b && self.window){
        //键盘事件
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:placeholderTextView];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:placeholderTextView];
    }
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    if(!self.isFirstResponder){
        return;
    }
    NSDictionary *info = [notification userInfo];
    //当前键盘尺寸
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    //部分第三方输入法适配
    if(!keyboardSize.height){
        return;
    }
    CGFloat kbHeight = keyboardSize.height;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self.superview convertRect:self.frame toView:window];
    
    if(!isKeyboardShow){
        superOriginY = self.UpliftView.frame.origin.y;
    }
    CGFloat offsetY = (rect.origin.y+rect.size.height)-(window.frame.size.height-kbHeight);
    if(offsetY>0){
        self.UpliftView.frame = CGRectMake(self.UpliftView.frame.origin.x, self.UpliftView.frame.origin.y-offsetY-8, self.UpliftView.frame.size.width, self.UpliftView.frame.size.height);
    }
    isKeyboardShow = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if(!self.isFirstResponder){
        return;
    }
    if(isKeyboardShow){
        self.UpliftView.frame = CGRectMake(self.UpliftView.frame.origin.x, superOriginY, self.UpliftView.frame.size.width, self.UpliftView.frame.size.height);
        isKeyboardShow = NO;
    }
}

@end
