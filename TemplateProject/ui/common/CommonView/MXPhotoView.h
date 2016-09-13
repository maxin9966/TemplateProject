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

@interface MXPhotoView : UIScrollView

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NSURL *url;

@property (nonatomic,strong) CommonBlock singleTap;

+ (void)showInWindowWithImage:(UIImage*)img;

+ (void)showInWindowWithUrl:(NSURL*)aUrl;

- (void)turnOffZoomAnimated:(BOOL)yesOrNo;

@end