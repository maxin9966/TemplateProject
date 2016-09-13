//
//  MoneyLabel.m
//  ASP
//
//  Created by admin on 15/9/16.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MoneyLabel.h"

@interface MoneyLabel()

@property (nonatomic,strong) UILabel *iconLabel;

@end

@implementation MoneyLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _iconLabel = [[UILabel alloc] init];
    _iconLabel.text = @"￥";
    _iconLabel.textAlignment = NSTextAlignmentRight;
    _iconLabel.font = self.font;
    _iconLabel.textColor = self.textColor;
    [self addSubview:_iconLabel];
    self.font = self.font;
    self.textColor = self.textColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    [_iconLabel setTextColor:textColor];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [_iconLabel setFont:[UIFont fontWithName:font.fontName size:font.pointSize*0.65]];
}

- (void)setIcon:(NSString *)icon
{
    _icon = icon;
    _iconLabel.text = _icon;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _iconLabel.frame = CGRectMake(-200, -height*(0.06), 200, height);
}

@end
