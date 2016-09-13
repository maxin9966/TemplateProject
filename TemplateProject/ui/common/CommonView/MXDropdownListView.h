//
//  MXDropdownListView.h
//  YanMo-Artist
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXDropdownListView;

@protocol MXDropdownListDelegate <NSObject>

@optional
//title
- (NSString*)mxDropdownListView:(MXDropdownListView*)dropdownList titleForData:(id)object index:(NSInteger)index;
//icon
- (UIImage*)mxDropdownListView:(MXDropdownListView*)dropdownList iconForData:(id)object index:(NSInteger)index;
//点击事件
- (void)mxDropdownListView:(MXDropdownListView*)dropdownList didSelect:(id)object index:(NSInteger)index;

@end

@interface MXDropdownListView : UIControl

@property (nonatomic,weak) id<MXDropdownListDelegate>delegate;

@property(nonatomic,assign) BOOL visible;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,assign) NSInteger selectedIndex;           //负数代表未选中

@property (nonatomic,assign) CGFloat cellHeight;                //默认44
@property (nonatomic,assign) CGFloat maxListHeight;             //默认263.5
@property (nonatomic,strong) UIColor *normalTitleColor;         //默认黑色
@property (nonatomic,strong) UIColor *highlightTitleColor;      //默认MainColor

- (void)show;

- (void)dismiss;

@end
