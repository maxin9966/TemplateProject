//
//  SimpleSelectView.h
//  LaneTrip
//
//  Created by antsmen on 15-5-4.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimpleSelectView;

@protocol SimpleSelectViewDelegate <NSObject>
@optional
- (void)simpleSelectView:(SimpleSelectView*)selectView didCommitWithText:(NSString*)text index:(NSInteger)index;

- (void)simpleSelectViewDidCancel:(SimpleSelectView*)selectView;

@end

@interface SimpleSelectView : UIControl

@property (nonatomic,assign) id<SimpleSelectViewDelegate>delegate;
@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,assign) NSInteger selectedIndex;

- (void)show;

- (void)dismiss;

@end
