//
//  BannerScrollView.h
//  TemplateProject
//
//  Created by admin on 15/7/28.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerScrollView : UIView

@property (nonatomic,strong) NSArray *images;

@property (nonatomic,assign) CGFloat speed;//取值范围0-1 默认0.5

@property (nonatomic,assign) CGFloat minOffset;//默认0

- (void)start;

- (void)stop;

@end
