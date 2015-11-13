//
//  PlaceholderTextView.h
//  FansKit
//
//  Created by antsmen on 14-12-30.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UpliftView superview

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, assign) BOOL autoUplift;//如果被键盘遮挡 是否自动抬高 默认yes
@property (nonatomic, assign) NSInteger limmitNumber;//默认0为无限制

@end
