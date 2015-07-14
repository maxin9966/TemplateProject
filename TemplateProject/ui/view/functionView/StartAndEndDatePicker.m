//
//  StartAndEndDatePicker.m
//  MeiYue
//
//  Created by antsmen on 15/6/10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "StartAndEndDatePicker.h"

@interface StartAndEndDatePicker()
{
    UIView *baseView;
    UIView *contentView;
    UIDatePicker *startPicker;
    UIDatePicker *endPicker;
    
    UIView *maskView;
    
    UIWindow *window;
    
    BOOL isShowing;
}

@end

@implementation StartAndEndDatePicker
@synthesize delegate;

- (id)init
{
    self = [super init];
    if(self){
        baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        maskView = [[UIView alloc] initWithFrame:baseView.bounds];
        [baseView addSubview:maskView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
        [maskView addGestureRecognizer:tap];
        
        CGFloat lineHeight = 1;
        CGFloat labelHeight = 32;
        CGFloat pickerHeight = 0;
        CGFloat interval = 8;
        CGFloat commitBtnHeight = 50;
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        [baseView addSubview:contentView];
        
        [contentView drawLineInRect:CGRectMake(0, 0, contentView.frame.size.width, lineHeight) color:LT_Color_Main];
        
        UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lineHeight, contentView.frame.size.width, labelHeight)];
        startLabel.text = @"起始时间";
        startLabel.font = [UIFont systemFontOfSize:16.f];
        [contentView addSubview:startLabel];
        startLabel.backgroundColor = [UIColor whiteColor];
        startLabel.textAlignment = NSTextAlignmentCenter;
        
        startPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, startLabel.bottomY, contentView.frame.size.width, pickerHeight)];
        startPicker.datePickerMode = UIDatePickerModeDate;
        [contentView addSubview:startPicker];
        startPicker.backgroundColor = [UIColor whiteColor];
        
        UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startPicker.bottomY, contentView.frame.size.width, labelHeight)];
        endLabel.text = @"结束时间";
        endLabel.font = [UIFont systemFontOfSize:16.f];
        [contentView addSubview:endLabel];
        endLabel.backgroundColor = [UIColor whiteColor];
        endLabel.textAlignment = NSTextAlignmentCenter;
        
        endPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, endLabel.bottomY, contentView.frame.size.width/2, pickerHeight)];
        endPicker.datePickerMode = UIDatePickerModeDate;
        [contentView addSubview:endPicker];
        endPicker.backgroundColor = [UIColor whiteColor];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        sureBtn.backgroundColor = [UIColor whiteColor];
        sureBtn.frame = CGRectMake(0, endPicker.bottomY+interval, contentView.frame.size.width, commitBtnHeight);
        [sureBtn setTitleColor:LT_Color_Main forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:sureBtn];
        
        contentView.frame = CGRectMake(0, SCREEN_HEIGHT-sureBtn.bottomY, SCREEN_WIDTH, sureBtn.bottomY);
    }
    return self;
}

- (void)commitAction:(UIButton*)btn
{
    if([startPicker.date timeIntervalSinceDate:endPicker.date]>0){
        [MyCommon showTips:@"起始时间不能晚于结束时间"];
        return;
    }
    if(delegate && [delegate respondsToSelector:@selector(startAndEndDatePicker:didPickerStartDate:endDate:)]){
        [delegate startAndEndDatePicker:self didPickerStartDate:startPicker.date endDate:endPicker.date];
    }
    [self hidePicker];
}

- (void)showPicker
{
    if(isShowing){
        return;
    }
    window = [MyCommon normalLevelWindow];
    maskView.backgroundColor = RGBA(0, 0, 0, 0);
    contentView.frame = CGRectMake(contentView.leftX, SCREEN_HEIGHT, contentView.frame.size.width, contentView.frame.size.height);
    [window addSubview:baseView];
    
    [UIView animateWithDuration:0.2f animations:^{
        maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        contentView.frame = CGRectMake(contentView.leftX, SCREEN_HEIGHT-contentView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
    } completion:^(BOOL finished) {

    }];
    
    isShowing = YES;
}

- (void)hidePicker
{
    if(!isShowing){
        return;
    }
    [UIView animateWithDuration:0.2f animations:^{
        maskView.backgroundColor = RGBA(0, 0, 0, 0);
        contentView.frame = CGRectMake(contentView.leftX, SCREEN_HEIGHT, contentView.frame.size.width, contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [baseView removeFromSuperview];
    }];
    isShowing = NO;
}

@end
