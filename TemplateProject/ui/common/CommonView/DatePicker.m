//
//  DatePicker.m
//  MeiMei
//
//  Created by Admin on 14-4-15.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import "DatePicker.h"

@interface DatePicker()
{
    UIView *baseView;
    UIWindow *window;
}

@end

static DatePicker *picker = nil;
@implementation DatePicker
@synthesize delegate;
@synthesize minimumDate;
@synthesize datePickerMode;
@synthesize date;

+ (DatePicker *)sharedInstance
{
    @synchronized(self)
    {
        if (!picker)
        {
            picker = [[self alloc]init];
        }
        return picker;
    }
}

+ (id)alloc
{
    @synchronized(self)
    {
        if (!picker)
        {
            picker = [super alloc];
        }
        
        return picker;
    }
}

//创建所有的UIview
- (id)init
{
    if (self = [super init]) {
        window = [MyCommon normalLevelWindow];
        
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
        [window addSubview:_maskView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMiss)];
        [_maskView addGestureRecognizer:tap];
        
        float baseHeight = 1+216+8+50;
        baseView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, baseHeight)];
        
        [window addSubview:baseView];
        //线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, baseView.frame.size.width, 1)];
        lineView.backgroundColor = LT_Color_Main;
        [baseView addSubview:lineView];
        //datePicker
        if (!_datePicker) {
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 1, baseView.frame.size.width, 216)];
        }
        
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        NSTimeInterval nowTime=[[NSDate date] timeIntervalSince1970];
        long long int dateTime=(long long int) nowTime;
        NSDate *time = [NSDate dateWithTimeIntervalSince1970:dateTime];
        _datePicker.minimumDate = time;
        
        [baseView addSubview:_datePicker];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        sureBtn.backgroundColor = [UIColor whiteColor];
        sureBtn.frame = CGRectMake(0, baseView.frame.size.height-50, baseView.frame.size.width, 50);
        [sureBtn setTitleColor:LT_Color_Main forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:sureBtn];
    }
    return self;
}

//确定按钮
- (void)userClick:(id)sender
{
    //[self dissMiss];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *dateText = [dateFormatter stringFromDate:_datePicker.date];
    if ([self.delegate respondsToSelector:@selector(chooseDateString:)]) {
        [self.delegate chooseDateString:dateText];
    }
    if(delegate && [delegate respondsToSelector:@selector(chooseDate:)]){
        [delegate chooseDate:_datePicker.date];
    }
}

//显示
- (void)show
{
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.5;
    [window addSubview:_maskView];
    [window addSubview:baseView];
    [UIView animateWithDuration:0.3 animations:^
     {
         [baseView setFrame:CGRectMake(0, SCREEN_HEIGHT-baseView.frame.size.height, SCREEN_WIDTH, baseView.frame.size.height)];
     }];
}

//隐藏
- (void)dissMiss
{
    _maskView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^
     {
         [baseView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, baseView.frame.size.height)];
     }];
}

#pragma mark - get set
- (void)setDatePickerMode:(UIDatePickerMode)mode
{
    datePickerMode = mode;
    _datePicker.datePickerMode = mode;
}

- (UIDatePickerMode)datePickerMode
{
    return _datePicker.datePickerMode;
}

- (void)setMinimumDate:(NSDate *)aDate
{
    minimumDate = aDate;
    _datePicker.minimumDate = minimumDate;
}

- (NSDate*)minimumDate
{
    return _datePicker.minimumDate;
}

- (NSDate*)date
{
    return _datePicker.date;
}

- (void)setDate:(NSDate *)aDate
{
    date = aDate;
    _datePicker.date = date;
}

@end
