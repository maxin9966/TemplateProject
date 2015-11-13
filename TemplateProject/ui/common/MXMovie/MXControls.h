//
//  MXControls.h
//  FullScreenVideoPlayerDemo
//
//  Created by antsmen on 15/5/26.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKScrubber.h"

@interface MXControls : UIView

@property (nonatomic,strong) IBOutlet UIButton *playBtn;
@property (nonatomic,strong) IBOutlet VKScrubber *scrubber;
@property (nonatomic,strong) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic,strong) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic,strong) IBOutlet UIButton *fullScreenBtn;

@end
