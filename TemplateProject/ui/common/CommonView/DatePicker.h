//
//  DatePicker.h
//  MeiMei
//
//  Created by Admin on 14-4-15.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatePicker : NSObject{
    UIDatePicker     *_datePicker;
    UIView           *_maskView;   
}

+ (DatePicker *)sharedInstance;

//datePicker显示
- (void)show;
//datePicker隐藏
- (void)dissMiss;

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) UIDatePickerMode datePickerMode;
@property (nonatomic,assign) NSDate *minimumDate;
@property (nonatomic,strong) NSDate *date;

@end

@protocol DatePickerDelegate <NSObject>
@optional
- (void)chooseDateString:(NSString *)dateText;
- (void)chooseDate:(NSDate *)date;

@end