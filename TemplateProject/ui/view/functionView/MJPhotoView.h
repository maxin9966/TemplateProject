//
//  MJZoomingScrollView.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 图片全屏查看
 
 */

@interface MJPhotoView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,strong) UIImage *image;

+ (void)showWithImage:(UIImage*)img;

+ (void)dismiss;

@end