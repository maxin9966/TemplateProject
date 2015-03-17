//
//  UIView+Utility.m
//  FansKit
//
//  Created by MA on 14/12/19.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)

//等比缩放
- (void)zoomWithRatio:(CGFloat)ratio
{
    if(ratio==1 || ratio<0){
        return;
    }
    self.frame = CGRectMake(self.frame.origin.x*ratio, self.frame.origin.y*ratio, self.frame.size.width*ratio, self.frame.size.height*ratio);
    if([self isKindOfClass:[UIScrollView class]]){
        UIScrollView *sv = (UIScrollView*)self;
        sv.contentSize = CGSizeMake(sv.contentSize.width*ratio, sv.contentSize.height*ratio);
        sv.contentOffset = CGPointMake(sv.contentOffset.x*ratio, sv.contentOffset.y*ratio);
    }
    if([self isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel*)self;
        label.font = [UIFont fontWithName:label.font.fontName size:label.font.pointSize*ratio];
    }
    if([self isKindOfClass:[UITextField class]]){
        UITextField *tf = (UITextField*)self;
        tf.font = [UIFont fontWithName:tf.font.fontName size:tf.font.pointSize*ratio];
    }
    if([self isKindOfClass:[UITextView class]]){
        UITextView *tv = (UITextView*)self;
        tv.font = [UIFont fontWithName:tv.font.fontName size:tv.font.pointSize*ratio];
    }
    if([self isKindOfClass:[UIButton class]]){
        UIButton *btn = (UIButton*)self;
        btn.titleLabel.font = [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize*ratio];
    }
}

- (void)zoomSubviewsWithRatio:(CGFloat)ratio
{
    for(UIView *view in self.subviews){
        [view zoomWithRatio:ratio];
    }
}

@end
