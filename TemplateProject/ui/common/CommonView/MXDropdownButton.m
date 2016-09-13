//
//  MXDropdownButton.m
//  YanMo-Artist
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "MXDropdownButton.h"

@interface MXDropdownButton ()

@property (nonatomic,strong) UIImageView *arrowImgView;

@end

@implementation MXDropdownButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    MXDropdownButton *btn = [super buttonWithType:buttonType];
    [btn initialize];
    return btn;
}

- (id)init
{
    self = [super init];
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    __weak typeof(self)wSelf = self;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.clipsToBounds = YES;
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_arrowImgView];
    [RACObserve(self, selected) subscribeNext:^(id object) {
        [UIView animateWithDuration:0.15f animations:^{
            [wSelf updateArrow];
        }];
    }];
}

- (void)setNormalArrow:(UIImage *)normalArrow
{
    _normalArrow = normalArrow;
    [self updateArrow];
}

- (void)setHighlightArrow:(UIImage *)highlightArrow
{
    _highlightArrow = highlightArrow;
    [self updateArrow];
}

- (void)updateArrow
{
    if(self.selected){
        if(self.highlightArrow){
            self.arrowImgView.image = self.highlightArrow;
        }else{
            self.arrowImgView.image = self.normalArrow;
        }
        self.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        self.arrowImgView.image = self.normalArrow;
        self.arrowImgView.transform = CGAffineTransformIdentity;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat edgeY = 0.34*self.frameHeight;
    CGFloat edgeX = 0.14*self.frameHeight;
    CGFloat buttonSideLength = self.frameHeight-edgeY*2;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, edgeX, 0, buttonSideLength+edgeX*2);
    CGFloat contentWidth = (self.frameWidth-self.contentEdgeInsets.left-self.contentEdgeInsets.right);
    NSString *title = [self titleForState:self.state];
    UIFont *font = self.titleLabel.font;
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    if(size.width>contentWidth){
        size.width = contentWidth;
    }
    _arrowImgView.frame = CGRectMake(self.contentEdgeInsets.left+contentWidth/2+size.width/2+edgeX, edgeY, buttonSideLength, buttonSideLength);
}

@end
