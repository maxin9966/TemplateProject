//
//  SimpleSelectView.m
//  LaneTrip
//
//  Created by antsmen on 15-5-4.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "SimpleSelectView.h"

@interface SimpleSelectView()
<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *contentView;
    UIButton *cancelBtn;
    UIButton *commitBtn;
    UIPickerView *pickerView;
    BOOL isShow;
    
    NSString *selectedString;
}

@end

@implementation SimpleSelectView
@synthesize delegate;
@synthesize dataList;
@synthesize selectedIndex;

#define ContentHeight (220.f * (SCREEN_WIDTH/320.f))

- (id)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        self.backgroundColor = RGBA(0, 0, 0, 0);
        [self addTarget:self action:@selector(bgTap) forControlEvents:UIControlEventTouchUpInside];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ContentHeight)];
        contentView.userInteractionEnabled = YES;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        [contentView drawLineInRect:CGRectMake(0, 0, contentView.frame.size.width, 1) color:LT_Color_Main];
        
        CGFloat btnWidth = 60;
        CGFloat btnHeight = 40;
        UIFont *btnTitleFont = [UIFont fontWithName:LT_Light_FontName size:15.f];
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = btnTitleFont;
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancelBtn];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);

        commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        commitBtn.titleLabel.font = btnTitleFont;
        [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:commitBtn];
        commitBtn.frame = CGRectMake(contentView.frame.size.width-btnWidth, 0, btnWidth, btnHeight);
        
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, commitBtn.bottomY, contentView.frame.size.width, contentView.frame.size.height-commitBtn.bottomY)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [contentView addSubview:pickerView];
    }
    return self;
}

- (void)commit
{
    if(!selectedString.length){
        return;
    }
    [self dismiss];
    if(delegate && [delegate respondsToSelector:@selector(simpleSelectView:didCommitWithText:index:)]){
        [delegate simpleSelectView:self didCommitWithText:selectedString index:selectedIndex];
    }
}

- (void)cancel
{
    [self dismiss];
    if(delegate && [delegate respondsToSelector:@selector(simpleSelectViewDidCancel:)]){
        [delegate simpleSelectViewDidCancel:self];
    }
}

- (void)setSelectedIndex:(NSInteger)index
{
    selectedIndex = index;
    if(dataList.count>index){
        [pickerView selectRow:index inComponent:0 animated:NO];
        [self pickerView:pickerView didSelectRow:index inComponent:0];
    }
}

- (void)bgTap
{
    [self dismiss];
}

- (void)setDataList:(NSArray*)list
{
    [self reset];
    dataList = list;
    [pickerView reloadAllComponents];
    if(dataList.count){
        [pickerView selectRow:0 inComponent:0 animated:NO];
        [self pickerView:pickerView didSelectRow:0 inComponent:0];
    }
}

- (void)show
{
    if(isShow){
        return;
    }
    UIWindow *window = [MyCommon normalLevelWindow];
    [window addSubview:self];
    
    self.backgroundColor = RGBA(0, 0, 0, 0);
    contentView.frame = CGRectMake(0, SCREEN_HEIGHT, contentView.frame.size.width, contentView.frame.size.height);
    
    [UIView animateKeyframesWithDuration:0.23 delay:0 options:0 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        contentView.frame = CGRectMake(0, SCREEN_HEIGHT-contentView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    isShow = YES;
}

- (void)dismiss
{
    if(!isShow){
        return;
    }
    self.backgroundColor = RGBA(0, 0, 0, 0.4);
    contentView.frame = CGRectMake(0, SCREEN_HEIGHT-contentView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
    
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:0 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        contentView.frame = CGRectMake(0, SCREEN_HEIGHT, contentView.frame.size.width, contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    isShow = NO;
}

- (void)reset
{
    selectedString = nil;
    dataList = nil;
    selectedIndex = 0;
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dataList.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dataList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
    selectedString = [dataList objectAtIndex:row];
}

@end
