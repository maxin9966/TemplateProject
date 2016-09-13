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
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, selfWidth+0.5, selfHeight);
        }
            break;
        case SizeFitLabelAlignmentCenter:
        {
            self.frame = CGRectMake(center.x-selfWidth/2-0.5, self.frame.origin.y, selfWidth+1, selfHeight);
        }
            break;
        case SizeFitLabelAlignmentRight:
        {
            self.frame = CGRectMake(rightX-selfWidth-0.5, self.frame.origin.y, selfWidth+0.5, selfHeight);
        }
            break;
        default:
            break;
    }
    [self setFrameWidth:self.frameWidth+1.f];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self sizeToFit];
}

@end
