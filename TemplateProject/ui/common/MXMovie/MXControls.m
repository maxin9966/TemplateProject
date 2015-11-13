//
//  MXControls.m
//  FullScreenVideoPlayerDemo
//
//  Created by antsmen on 15/5/26.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MXControls.h"

@implementation MXControls

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MXControls" owner:nil options:nil] firstObject];
    self.frame = frame;
    if(self){
        [self initialize];
    }
    return self;
}

- (void)initialize{}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    self.playBtn.frame = CGRectMake(2, 0, self.playBtn.frame.size.width, selfHeight);
    self.currentTimeLabel.frame = CGRectMake(self.playBtn.frame.size.width+self.playBtn.frame.origin.x, 0, self.currentTimeLabel.frame.size.width, selfHeight);
    self.fullScreenBtn.frame = CGRectMake(selfWidth-self.fullScreenBtn.frame.size.width-6, 0, self.fullScreenBtn.frame.size.width, selfHeight);
    self.totalTimeLabel.frame = CGRectMake(selfWidth-38-self.totalTimeLabel.frame.size.width, 0, self.totalTimeLabel.frame.size.width, selfHeight);
    
    CGFloat leftX = self.currentTimeLabel.frame.origin.x+self.currentTimeLabel.frame.size.width+6;
    CGFloat rightX = self.totalTimeLabel.frame.origin.x-6;
    self.scrubber.frame = CGRectMake(leftX, selfHeight/2-self.scrubber.frame.size.height/2, rightX-leftX, self.scrubber.frame.size.height);
}

@end
