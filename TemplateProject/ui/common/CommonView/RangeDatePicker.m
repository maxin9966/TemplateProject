//
//  RangeDatePicker.m
//  MeiYue
//
//  Created by antsmen on 15/6/10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "RangeDatePicker.h"
#import "DatePicker.h"

@interface RangeDatePicker()
<DatePickerDelegate>
{
    UIView *baseView;
    
    UIButton *startBtn;
    UIButton *endBtn;
    
    UIButton *focusBtn;
    
    NSDate *startDate;
    NSDate *endDate;
    
    BOOL isShowing;
    
    DatePicker *datePicker;
}

@end

@implementation RangeDatePicker
@synthesize delegate;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(self){
        CGFloat width = 280.f;
        
        CGFloat labelHeight = 35.f;
        CGFloat btnHeight = 35.f;
        CGFloat interval = 6.f;
        CGFloat bottomBtnHeight = 35.f;
        
        UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, interval, width, labelHeight)];
        startLabel.font = [UIFont boldSystemFontOfSize:15.f];
        startLabel.textAlignment = NSTextAlignmentCenter;
        startLabel.text = @"起始时间";
        startLabel.textColor = [UIColor whiteColor];
        
        startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setTitle:@"请选择起始时间" forState:UIControlStateNormal];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        startBtn.frame = CGRectMake(0, startLabel.bottomY+interval, width, btnHeight);
        [startBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [startBtn setTitleColor:LT_Color_Main forState:UIControlStateNormal];
        
        UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startBtn.bottomY+interval, width, labelHeight)];
        endLabel.font = [UIFont boldSystemFontOfSize:15.f];
        endLabel.textAlignment = NSTextAlignmentCenter;
        endLabel.text = @"结束时间";
        endLabel.textColor = [UIColor whiteColor];
        
        endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [endBtn setTitle:@"请选择结束时间" forState:UIControlStateNormal];
        endBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        endBtn.frame = CGRectMake(0, endLabel.bottomY+interval, width, btnHeight);
        [endBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [endBtn setTitleColor:LT_Color_Main forState:UIControlStateNormal];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        cancelBtn.frame = CGRectMake(0, endBtn.bottomY+interval, width/2, bottomBtnHeight);
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        commitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        commitBtn.frame = CGRectMake(width/2, endBtn.bottomY+interval, width/2, bottomBtnHeight);
        [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        CGFloat height = commitBtn.bottomY+interval;
        
        baseView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-width/2, SCREEN_HEIGHT/2-height/2, width, height)];
        [self addSubview:baseView];
        
        baseView.layer.cornerRadius = 5.f;
        baseView.layer.borderColor = [UIColor whiteColor].CGColor;
        baseView.layer.borderWidth = 2.f;
        
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        
        baseView.backgroundColor = RGBA(0, 0, 0, 0.7);
        
        [self addTarget:self action:@selector(bgTap) forControlEvents:UIControlEventTouchUpInside];
        
        [baseView addSubview:startLabel];
        [baseView addSubview:startBtn];
        [baseView addSubview:endLabel];
        [baseView addSubview:endBtn];
        [baseView addSubview:cancelBtn];
        [baseView addSubview:commitBtn];
    }
    return self;
}

- (void)bgTap
{
    [self hidePicker];
}

- (void)btnAction:(UIButton*)btn
{
    if(!datePicker){
        datePicker = [[DatePicker alloc] init];
        datePicker.delegate = self;
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.minimumDate = nil;
    }
    if(btn == startBtn){
        if(startDate){
            datePicker.date = startDate;
        }
    }else{
        if(endDate){
            datePicker.date = endDate;
        }
    }
    [datePicker show];
    
    focusBtn = btn;
}

- (void)cancelAction:(UIButton*)btn
{
    [self hidePicker];
}

- (void)commitAction:(UIButton*)btn
{
    if(!startDate){
        [MyCommon showTips:@"请选择起始时间"];
        return;
    }
    if(!endDate){
        [MyCommon showTips:@"请选择结束时间"];
        return;
    }
    if([startDate timeIntervalSinceDate:endDate]>0){
        [MyCommon showTips:@"起始时间不能晚于结束时间"];
        return;
    }
    if(delegate && [delegate respondsToSelector:@selector(rangeDatePicker:didPickerStartDate:endDate:)]){
        [delegate rangeDatePicker:self didPickerStartDate:startDate endDate:endDate];
    }
    [self hidePicker];
}

- (void)showPicker
{
    if(isShowing){
        return;
    }
    UIWindow *window = [MyCommon normalLevelWindow];
    [window addSubview:self];
    
    self.alpha = 0;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1;
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
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    isShowing = NO;
}

#pragma mark - DatePickerDelegate
- (void)chooseDate:(NSDate *)date
{
    [datePicker dissMiss];
    if(!date){
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    if(focusBtn == startBtn){
        startDate = date;
        [startBtn setTitle:dateString forState:UIControlStateNormal];
    }else{
        endDate = date;
        [endBtn setTitle:dateString forState:UIControlStateNormal];
    }
}

@end
