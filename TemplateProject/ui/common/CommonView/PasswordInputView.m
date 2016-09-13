//
//  NumberInputView.m
//  YanMo-Artist
//
//  Created by admin on 15/12/30.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "PasswordInputView.h"

#define minEdgeX 25.f

@interface PasswordInputView ()
<UITextFieldDelegate>

@property (nonatomic,assign) NSUInteger passwordNumber;

@property (nonatomic,strong) NoCoverView *baseView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;

@property (nonatomic,strong) UIView *pwdView;
@property (nonatomic,strong) NSMutableArray *pwdLabels;

@end

@implementation PasswordInputView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithPasswordNumber:(NSUInteger)number title:(NSString*)title description:(NSString*)des
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(self){
        _passwordNumber = number;
        [self addTarget:self action:@selector(bgTap) forControlEvents:UIControlEventTouchUpInside];
        
        _baseView = [[NoCoverView alloc] initWithFrame:CGRectMake(40, SCREEN_HEIGHT/2-120, SCREEN_WIDTH-80, 240)];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_baseView];
        _baseView.clipsToBounds = YES;
        _baseView.layer.cornerRadius = 8.f;
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, _baseView.frameWidth, _baseView.frameHeight)];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        _textField.alpha = 0;
        [_baseView addSubview:_textField];
        //观察text变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:_textField];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _baseView.frameWidth-40, 50)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_baseView addSubview:_titleLabel];
        _titleLabel.text = title;
        
        [_baseView drawLineInRect:CGRectMake(0, _titleLabel.bottomY, _baseView.frameWidth, 0.5) color:[UIColor lightGrayColor]];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _titleLabel.bottomY+30, _baseView.frameWidth-40, 50)];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font = [UIFont systemFontOfSize:16.f];
        [_baseView addSubview:_desLabel];
        _desLabel.text = des;
        _desLabel.numberOfLines = 0;
        
        CGFloat sideLength = 0;
        if(_passwordNumber>4){
            sideLength = (_baseView.frameWidth-minEdgeX*2)/_passwordNumber;
        }else{
            sideLength = (_baseView.frameWidth-minEdgeX*2)/4;
        }
        _pwdLabels = [NSMutableArray array];
        CGFloat pwdWidth = sideLength*_passwordNumber;
        CGFloat pwdHeight = sideLength;
        
        _pwdView = [[UIView alloc] initWithFrame:CGRectMake(_baseView.frameWidth/2-pwdWidth/2, (_baseView.frameHeight-_desLabel.bottomY)*0.45+_desLabel.bottomY-pwdHeight/2, pwdWidth, pwdHeight)];
        _pwdView.layer.cornerRadius = 2.f;
        _pwdView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _pwdView.layer.borderWidth = 0.5f;
        [_baseView addSubview:_pwdView];
        for(NSUInteger i=0;i<_passwordNumber;i++){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(sideLength*i, 0, sideLength, sideLength)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:21.f];
            [_pwdView addSubview:label];
            [_pwdLabels addObject:label];
            if(i<_passwordNumber-1){
                [_pwdView drawLineInRect:CGRectMake(label.rightX, 0, 0.5, _pwdView.frameHeight) color:[UIColor lightGrayColor]];
            }
        }
    }
    return self;
}

- (void)bgTap
{
    if(!_visible){
        return;
    }
    if(_cancelBlock){
        _cancelBlock(self);
    }
    [self dismiss];
}

- (void)textDidChange:(NSNotification*)notification
{
    if([notification object] != _textField){
        return;
    }
    NSUInteger length = _textField.text.length;
    if(length>_passwordNumber){
        _textField.text = [_textField.text substringToIndex:_passwordNumber];
    }
    for(NSUInteger i = 0;i<_passwordNumber;i++){
        NSString *str = nil;
        if(i<length)
            str = [_textField.text substringWithRange:NSMakeRange(i, 1)];
        UILabel *label = [_pwdLabels objectAtIndexSafely:i];
        label.text = str;
    }
    if(_textField.text.length==_passwordNumber){
        if(_completeBlock){
            _completeBlock(self,_textField.text);
        }
        [self dismiss];
    }
}

- (void)show
{
    if(_visible){
        return;
    }
    [[MyCommon normalLevelWindow] addSubview:self];
    __weak typeof(self)wSelf = self;
    self.backgroundColor = RGBA(0, 0, 0, 0);
    self.baseView.alpha = 0;
    [UIView animateWithDuration:0.22 animations:^{
        wSelf.backgroundColor = RGBA(0, 0, 0, 0.6f);
        wSelf.baseView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    [self.textField becomeFirstResponder];
    self.visible = YES;
}

- (void)dismiss
{
    if(!_visible){
        return;
    }
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        wSelf.backgroundColor = RGBA(0, 0, 0, 0);
        wSelf.baseView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    self.visible = NO;
}

@end
