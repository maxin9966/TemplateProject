//
//  UIScrollView+Category.m
//  FansKit
//
//  Created by antsmen on 15-3-6.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "UIScrollView+Category.h"

@implementation UIScrollView (Category)

- (void)scrollToTopAnimated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(self.contentOffset.x, 0) animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    CGFloat contentSizeHeight = self.contentSize.height;
    CGFloat boundsHeight = self.bounds.size.height;
    if(contentSizeHeight<=boundsHeight){
        [self setContentOffset:CGPointMake(self.contentOffset.x, 0) animated:animated];
    }else{
        [self setContentOffset:CGPointMake(self.contentOffset.x, contentSizeHeight-boundsHeight) animated:animated];
    }
}

- (void)scrollToLeftAnimated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(0, self.contentOffset.y) animated:animated];
}

- (void)scrollToRightAnimated:(BOOL)animated
{
    CGFloat contentSizeWidth = self.contentSize.width;
    CGFloat boundsWidth = self.bounds.size.width;
    if(contentSizeWidth<=boundsWidth){
        [self setContentOffset:CGPointMake(0, self.contentOffset.y) animated:animated];
    }else{
        [self setContentOffset:CGPointMake(contentSizeWidth-boundsWidth, self.contentOffset.y) animated:animated];
    }
}

@end
