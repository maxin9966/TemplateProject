//
//  MXPhotoView.h
//  FansKit
//
//  Created by MA on 14/12/18.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 图片全屏查看
 
 */

@class MXPhotoView;

@protocol MXPhotoViewDelegate <NSObject>

- (void)didTapMXPhotoView:(MXPhotoView*)photoView;

@end

@interface MXPhotoView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,weak) id<MXPhotoViewDelegate>aDelegate;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NSURL *url;

+ (void)showWithImage:(UIImage*)img;

+ (void)dismiss;

- (void)reset;

//恢复初始到缩放值
- (void)turnOffZoomAnimated:(BOOL)yesOrNo;

@end