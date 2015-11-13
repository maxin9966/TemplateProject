//
//  ImageScrollView.h
//  ScrollView
//
//  Created by MA on 14/11/17.
//  Copyright (c) 2014年 ma. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    循环控件
 */

@class ImageScrollView;
@class ImageCell;

typedef NS_ENUM(NSInteger, ScrollOrientation) {
    ScrollOrientationLandscape = 0,
    ScrollOrientationPortrait
};

@protocol ImageScrollViewDataSource <NSObject>
@required
- (NSUInteger)totalNumber;
- (ImageCell*)imageCellAtIndex:(NSInteger)index;
@optional
- (void)scrollViewDidShowNewCell:(ImageCell*)cell index:(NSInteger)index;
- (void)scrollViewWillRemoveCell:(ImageCell*)cell index:(NSInteger)index;

@end

@interface ImageScrollView : UIView

@property (nonatomic,weak) id<ImageScrollViewDataSource> dataSource;
@property (nonatomic,assign) BOOL scrollEnabled;
@property (nonatomic,strong,readonly) NSMutableDictionary *displayCells;//当前显示的cell队列
@property (nonatomic,assign) ScrollOrientation orientation;//默认Landscape

@property (nonatomic,assign) BOOL cellResetWhenRemove;//默认NO

//下一页
- (void)nextPageAnimated:(BOOL)animated;

//上一页
- (void)prePageAnimated:(BOOL)animated;

//重载
- (void)reload;

//重置
- (void)reset;

//取出回收站里的cell
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier;

//根据index获取cell 没有返回nil
- (ImageCell*)getCellWithIndex:(NSInteger)index;

@end

/*
    cell
 */

@interface ImageCell : UIView

@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,assign) NSInteger index;

- (void)reset;

@end
