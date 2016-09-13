//
//  FitImageView.h
//  YanMo
//
//  Created by admin on 15/12/15.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitImageView : UIImageView

@property (nonatomic,assign) CGFloat imageSizeWidth;
@property (nonatomic,assign) CGFloat imageSizeHeight;

@property (nonatomic,assign) CGFloat maxWidth;
@property (nonatomic,assign) CGFloat maxHeight;

@property (nonatomic,assign) CGFloat minWidth;
@property (nonatomic,assign) CGFloat minHeight;

- (void)frameToFit;

+ (CGSize)sizeWithImageSizeWidth:(CGFloat)imageSizeWidth imageSizeHeight:(CGFloat)imageSizeHeight maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight minWidth:(CGFloat)minWidth minHeight:(CGFloat)minHeight;

@end
