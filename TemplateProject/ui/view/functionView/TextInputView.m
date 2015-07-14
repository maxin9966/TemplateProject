//
//  TextInputView.m
//  FansKit
//
//  Created by antsmen on 15-1-7.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "TextInputView.h"

@interface TextInputView()
<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UITextField *textField;
    
    UIView *bgView;
    
    BOOL isKeyboardShow;
    CGFloat superOriginY;
}

@end

@implementation TextInputView
@synthesize delegate;
@synthesize title,placeholder,limmitNumber,text;

- (id)init
{
    if((self = [[[NSBundle mainBundle] loadNibNamed:@"TextInputView" owner:self options:nil] firstObject])){
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 3;
        self.layer.borderColor = RGBA(255, 255, 255, 0.7).CGColor;
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.clipsToBounds = YES;
        textField.delegate = self;
    }
    return self;
}

- (void)setTitle:(NSString *)mTitle
{
    title = mTitle;
    titleLabel.text = title;
}

- (NSString*)title
{
    return titleLabel.text;
}

- (void)setPlaceholder:(NSString *)mPlaceholder
{
    placeholder = mPlaceholder;
    textField.placeholder = placeholder;
}

- (NSString*)placeholder
{
    return textField.placeholder;
}

- (void)setText:(NSString *)aText
{
    text = aText;
    textField.text = text;
}

- (NSString*)text
{
    return textField.text;
}

- (IBAction)commit:(id)sender
{
    if(self.text.length==0){
        return;
    }
    [self dismiss];
    if(delegate && [delegate respondsToSelector:@selector(textInputViewAffirm:)]){
        [delegate textInputViewAffirm:self];
    }
}

- (IBAction)cancel:(id)sender
{
    [self dismiss];
    if(delegate && [delegate respondsToSelector:@selector(textInputViewCancel:)]){
        [delegate textInputViewCancel:self];
    }
}

- (BOOL)becomeFirstResponder
{
    return [textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [textField resignFirstResponder];
}

- (void)didMoveToWindow
{
    if(!self.window){
        //移除观察者
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }else{
        //注册观察者
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:textField];
    }
}

#pragma mark -
- (void)show
{
    UIWindow *window = [MyCommon normalLevelWindow];
    if(!bgView){
        bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [bgView addGestureRecognizer:tap];
    }
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [window addSubview:bgView];
    [window addSubview:self];
    [self becomeFirstResponder];
}

- (void)dismiss
{
    [bgView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(touch.view != bgView){
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return NO;
}

- (void)textFieldDidChanged
{
    if(limmitNumber<=0){
        return;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (position) {
            if (toBeString.length > limmitNumber) {
                self.text = [toBeString substringToIndex:limmitNumber];
            }
        }else{
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        }
    }else{
        if (toBeString.length > limmitNumber) {
            self.text = [toBeString substringToIndex:limmitNumber];
        }
    }
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    if(!textField.isFirstResponder){
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
        superOriginY = self.frame.origin.y;
    }
    CGFloat offsetY = (rect.origin.y+rect.size.height)-(window.frame.size.height-kbHeight);
    if(offsetY>0){
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-offsetY-8, self.frame.size.width, self.frame.size.height);
    }
    isKeyboardShow = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if(isKeyboardShow){
        self.frame = CGRectMake(self.frame.origin.x, superOriginY, self.frame.size.width, self.frame.size.height);
        isKeyboardShow = NO;
    }
}

@end
