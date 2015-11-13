//
//  PlaceholderImageView.m
//  MeiMei
//
//  Created by 马鑫 on 14-7-4.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import "PlaceholderImageView.h"

@interface PlaceholderImageView()
{
    UIImageView *imageView;
    UILabel *titleLabel;
}

@end

@implementation PlaceholderImageView

- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /* icon */
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
        imageView.center = CGPointMake(self.frame.size.width/2, imageView.frame.size.height/2);
        [self addSubview:imageView];
        /* title */
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height, self.frame.size.width, 200)];
        titleLabel.font = [UIFont fontWithName:LT_Light_FontName size:18];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = LT_Color_Main;//RGBA(221, 221, 221, 1);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(self.frame.size.width/2, titleLabel.center.y);
        [self addSubview:titleLabel];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, titleLabel.frame.origin.y+titleLabel.frame.size.height);
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    titleLabel.text = title;
}

+ (PlaceholderImageView *) getPlaceholderImageByTitle:(NSString*)title
{
    PlaceholderImageView *placeholder = [[PlaceholderImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) title:title];
    return placeholder;
}

@end
