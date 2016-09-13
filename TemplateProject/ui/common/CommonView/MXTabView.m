//
//  MXTabView.m
//  YanMo-Artist
//
//  Created by admin on 15/12/25.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "MXTabView.h"

@interface MXTabView ()

@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation MXTabView

- (id)init
{
    self = [super init];
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
    self.backgroundColor = [UIColor clearColor];
    _titleFont = [UIFont systemFontOfSize:16.f];
    _selectedTitleColor = LT_Color_Main;
    _normalTitleColor = [UIColor lightGrayColor];
    self.selectedIndex = 0;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    _btnArray = [NSMutableArray array];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(_selectedIndex == selectedIndex){
        return;
    }
    _selectedIndex = selectedIndex;
    NSInteger i = 0;
    for(UIButton *btn in _btnArray){
        btn.selected = i == selectedIndex;
        i++;
    }
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.15f animations:^{
        wSelf.lineView.frame = CGRectMake(wSelf.edgeWidth+wSelf.selectedIndex*(wSelf.lineView.frameWidth+wSelf.intervalWidth), wSelf.lineView.topY, wSelf.lineView.frameWidth, wSelf.lineView.frameHeight);
    }];
}

- (void)layout
{
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    NSInteger count = _titles.count;
    CGFloat itemWidth = (selfWidth-2*_edgeWidth-(count-1)*_intervalWidth)/count;
    
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        [self addSubview:_lineView];
    }
    _lineView.backgroundColor = _selectedTitleColor;
    _lineView.frame = CGRectMake(_edgeWidth+_selectedIndex*(itemWidth+_intervalWidth), selfHeight-2, itemWidth, 2);
    
    NSInteger i = 0;
    for(NSString *title in _titles){
        UIButton *btn = [_btnArray objectAtIndexSafely:i];
        if(!btn){
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnArray addObject:btn];
            btn.tag = i;
        }
        btn.titleLabel.font = _titleFont;
        [btn setTitleColor:_normalTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = CGRectMake(_edgeWidth+i*(itemWidth+_intervalWidth), 0, itemWidth, selfHeight);
        [btn setTitle:title forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.selected = i == _selectedIndex;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
}

- (void)buttonClick:(UIButton*)btn
{
    if(_tabButtonClickCallback){
        _tabButtonClickCallback(self,btn.tag);
    }
}

@end
