//
//  PlaceholderTextView.h
//  FansKit
//
//  Created by antsmen on 14-12-30.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, assign) NSInteger textLimit;//默认0为无限制

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@end
