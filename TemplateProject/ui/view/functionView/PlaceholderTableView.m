//
//  PlaceholderTableView.m
//  LaneTrip
//
//  Created by antsmen on 15-5-11.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "PlaceholderTableView.h"
#import "PlaceholderImageView.h"

@interface PlaceholderTableView()
{
    PlaceholderImageView *placeholder;
}

@end

@implementation PlaceholderTableView
@synthesize placeholderString;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView
{
    placeholderString = @"空空如也";
}

//占位图
- (void)showPlaceholder:(BOOL)isShow
{
    if(isShow && !placeholder){
        placeholder = [PlaceholderImageView getPlaceholderImageByTitle:placeholderString];
        placeholder.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-30);
        [self addSubview:placeholder];
    }
    placeholder.title = placeholderString;
    placeholder.hidden = !isShow;
}

- (void)reloadData
{
    [super reloadData];
    if(!self.dataSource || (![self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] && ![self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])){
        return;
    }
    NSInteger sectionCount = [self.dataSource numberOfSectionsInTableView:self];
    NSUInteger count = 0;
    for(int i=0;i<sectionCount;i++){
        count += [self.dataSource tableView:self numberOfRowsInSection:i];
    }
    [self showPlaceholder:count==0?YES:NO];
}

@end
