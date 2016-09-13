//
//  MXStepper.m
//  gem
//
//  Created by admin on 15/11/5.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "MXStepper.h"

@interface MXStepper ()

@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, strong) UIButton *incrementButton;
@property(nonatomic, strong) UIButton *decrementButton;

@end

@implementation MXStepper

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    __weak typeof(self)wSelf = self;
    
    _decrementButton = [self newBtn];
    [_decrementButton setTitle:@"-" forState:UIControlStateNormal];
    [_decrementButton addTarget:self action:@selector(decrementAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_decrementButton];
    
    _incrementButton = [self newBtn];
    [_incrementButton setTitle:@"+" forState:UIControlStateNormal];
    [_incrementButton addTarget:self action:@selector(incrementAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_incrementButton];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont fontWithName:@"Avernir-Roman" size:14.0f];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = RGBA(120, 120, 120, 1);
    [self addSubview:_countLabel];
    
    CGFloat cornerRadius = 3.0f;
    UIColor *borderColor = RGBA(180, 180, 180, 1); // LT_Color_Main;
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = borderColor.CGColor;
    self.countLabel.layer.borderWidth = 0.5f;
    self.countLabel.layer.borderColor = borderColor.CGColor;
    
    _stepInterval = 1.0f;
    _minimum = 0.0f;
    _maximum = 100.0f;
    
    [RACObserve(self, value) subscribeNext:^(id object) {
        wSelf.decrementButton.selected = wSelf.value<=wSelf.minimum;
        wSelf.incrementButton.selected = wSelf.value>=wSelf.maximum;
    }];
    self.value = 0.0f;
    [self updateLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnWidth = 28.f;
    CGFloat width = self.frameWidth;
    CGFloat height = self.frameHeight;
    
    _decrementButton.frame = CGRectMake(0, 0, btnWidth, height);
    _incrementButton.frame = CGRectMake(width-btnWidth, 0, btnWidth, height);
    _countLabel.frame = CGRectMake(_decrementButton.rightX, 0, _incrementButton.leftX-_decrementButton.rightX, height);
}

- (void)updateLabel
{
    self.countLabel.text = [MyCommon notRounding:_value afterPoint:_afterPointPosition];
}

- (void)setAfterPointPosition:(NSInteger)afterPointPosition
{
    if(afterPointPosition<0){
        afterPointPosition = 0;
    }
    _afterPointPosition = afterPointPosition;
    [self updateLabel];
}

- (void)setValue:(float)value
{
    if(value<_minimum){
        value = _minimum;
    }
    if(value>_maximum){
        value = _maximum;
    }
    if(_value != value){
        _value = value;
        [self updateLabel];
        if(_valueChangedCallback){
            _valueChangedCallback(self,_value);
        }
    }
}

- (void)setMaximum:(float)maximum
{
    _maximum = maximum;
    self.value = self.value;
}

- (void)setMinimum:(float)minimum
{
    _minimum = minimum;
    self.value = self.value;
}

#pragma mark - uibutton

- (void)decrementAction
{
    if(_decrementButton.selected){
        return;
    }
    if(_decrementedCallback){
        CGFloat newValue = self.value-self.stepInterval;
        if(_decrementedCallback(self,newValue)){
            self.value = newValue;
        }
    }else{
        self.value -= self.stepInterval;
    }
}

- (void)incrementAction
{
    if(_incrementButton.selected){
        return;
    }
    if(_incrementedCallback){
        CGFloat newValue = self.value+self.stepInterval;
        if(_incrementedCallback(self,newValue)){
            self.value = newValue;
        }
    }else{
        self.value += self.stepInterval;
    }
}

- (UIButton*)newBtn
{
    UIColor *defaultNColor = RGBA(180, 180, 180, 1); //LT_Color_Main;
    UIColor *defalutHColor = [UIColor lightGrayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:defaultNColor forState:UIControlStateNormal];
    [btn setTitleColor:defalutHColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:24.0f];
    return btn;
}

@end
