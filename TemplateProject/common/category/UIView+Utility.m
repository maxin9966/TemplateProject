//
//  UIView+Utility.m
//  FansKit
//
//  Created by MA on 14/12/19.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import "UIView+Utility.h"
#import "objc/runtime.h"

static char zoomRatio;
static char MXLineArray;

@implementation UIView (Utility)

- (CGFloat)zoomRatio
{
    NSNumber *number = objc_getAssociatedObject(self, &zoomRatio);
    if(number){
        return [number floatValue];
    }else{
        return 1;
    }
}

//等比缩放
- (void)zoomWithRatio:(CGFloat)ratio
{
    CGFloat currentRatio = [self zoomRatio];
    if(ratio == currentRatio || ratio<0){
        return;
    }
    CGFloat deltaRatio = ratio/currentRatio;
    self.frame = CGRectMake(self.frame.origin.x*deltaRatio, self.frame.origin.y*deltaRatio, self.frame.size.width*deltaRatio, self.frame.size.height*deltaRatio);
    if([self isKindOfClass:[UIScrollView class]]){
        UIScrollView *sv = (UIScrollView*)self;
        sv.contentSize = CGSizeMake(sv.contentSize.width*deltaRatio, sv.contentSize.height*deltaRatio);
        sv.contentOffset = CGPointMake(sv.contentOffset.x*deltaRatio, sv.contentOffset.y*deltaRatio);
    }
    if([self isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel*)self;
        label.font = [UIFont fontWithName:label.font.fontName size:label.font.pointSize*deltaRatio];
    }
    if([self isKindOfClass:[UITextField class]]){
        UITextField *tf = (UITextField*)self;
        tf.font = [UIFont fontWithName:tf.font.fontName size:tf.font.pointSize*deltaRatio];
    }
    if([self isKindOfClass:[UITextView class]]){
        UITextView *tv = (UITextView*)self;
        tv.font = [UIFont fontWithName:tv.font.fontName size:tv.font.pointSize*deltaRatio];
    }
    if([self isKindOfClass:[UIButton class]]){
        UIButton *btn = (UIButton*)self;
        btn.titleLabel.font = [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize*deltaRatio];
    }
    self.layer.borderWidth *= ratio;
    self.layer.cornerRadius *= ratio;
    objc_setAssociatedObject(self, &zoomRatio, @(ratio), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zoomSubviewsWithRatio:(CGFloat)ratio except:(NSArray*)exceptList
{
    if(exceptList && ![exceptList isKindOfClass:[NSArray class]]){
        exceptList = @[exceptList];
    }
    for(UIView *view in self.subviews){
        if(exceptList.count){
            if(![exceptList containsObject:view]){
                [view zoomWithRatio:ratio];
            }
        }else{
            [view zoomWithRatio:ratio];
        }
    }
}

- (void)zoomSubviewsWithRatio:(CGFloat)ratio
{
    [self zoomSubviewsWithRatio:ratio except:nil];
}

//坐标
- (CGFloat)bottomY
{
    return self.frame.origin.y+self.frame.size.height;
}

- (CGFloat)topY
{
    return self.frame.origin.y;
}

- (CGFloat)leftX
{
    return self.frame.origin.x;
}

- (CGFloat)rightX
{
    return self.frame.origin.x+self.frame.size.width;
}

- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

- (void)setFrameWidth:(CGFloat)newWidth {
    CGRect f = self.frame;
    f.size.width = newWidth;
    self.frame = f;
}

- (void)setFrameHeight:(CGFloat)newHeight {
    CGRect f = self.frame;
    f.size.height = newHeight;
    self.frame = f;
}

- (void)setFrameOriginX:(CGFloat)newX {
    CGRect f = self.frame;
    f.origin.x = newX;
    self.frame = f;
}

- (void)setFrameOriginY:(CGFloat)newY {
    CGRect f = self.frame;
    f.origin.y = newY;
    self.frame = f;
}

#pragma mark - draw

- (UIView*)drawLineInRect:(CGRect)rect color:(UIColor *)color
{
    UIView *line = [[UIView alloc] initWithFrame:rect];
    line.backgroundColor = color;
    [self addSubview:line];
    NSMutableArray *lineArr = objc_getAssociatedObject(self, &MXLineArray);
    if(!lineArr){
        lineArr = [NSMutableArray array];
        objc_setAssociatedObject(self, &MXLineArray, lineArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [lineArr addObject:line];
    return line;
}

- (void)removeAllLine
{
    NSMutableArray *lineArr = objc_getAssociatedObject(self, &MXLineArray);
    for(UIView *view in lineArr){
        [view removeFromSuperview];
    }
    [lineArr removeAllObjects];
}

@end
