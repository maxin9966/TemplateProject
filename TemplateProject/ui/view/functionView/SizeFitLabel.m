//
//  SizeFitLabel.m
//  LaneTrip
//
//  Created by antsmen on 15/5/19.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "SizeFitLabel.h"

@implementation SizeFitLabel
@synthesize alignment;
@synthesize widthLimit;

- (void)setAdjustsFontSizeToFitWidth:(BOOL)width
{
    [super setAdjustsFontSizeToFitWidth:width];
}

- (void)sizeToFit
{
    CGFloat selfHeight = self.frame.size.height;
    CGPoint center = self.center;
    CGFloat rightX = self.frame.size.width+self.frame.origin.x;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 99999, selfHeight);
    [super sizeToFit];
    CGFloat selfWidth = self.frame.size.width;
    if(widthLimit>0 && selfWidth>widthLimit){
        selfWidth = widthLimit;
    }
    switch (alignment) {
        case SizeFitLabelAlignmentLeft:
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, selfWidth, selfHeight);
        }
            break;
        case SizeFitLabelAlignmentCenter:
        {
            self.frame = CGRectMake(center.x-selfWidth/2, self.frame.origin.y, selfWidth, selfHeight);
        }
            break;
        case SizeFitLabelAlignmentRight:
        {
            self.frame = CGRectMake(rightX-selfWidth, self.frame.origin.y, selfWidth, selfHeight);
        }
            break;
        default:
            break;
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self sizeToFit];
}

@end
