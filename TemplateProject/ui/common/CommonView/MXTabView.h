//
//  MXTabView.h
//  YanMo-Artist
//
//  Created by admin on 15/12/25.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXTabView;

typedef void (^MXTabViewTabButtonClickCallback)(MXTabView *tabView, NSInteger index);

@interface MXTabView : UIView

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) MXTabViewTabButtonClickCallback tabButtonClickCallback;

@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,assign) CGFloat intervalWidth;
@property (nonatomic,assign) CGFloat edgeWidth;

@property (nonatomic,strong) UIColor *selectedTitleColor;
@property (nonatomic,strong) UIColor *normalTitleColor;
@property (nonatomic,strong) UIFont *titleFont;

- (void)layout;

@end
