//
//  MediaView.m
//  LaneTrip
//
//  Created by antsmen on 15-4-10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MediaView.h"
#import "MediaCell.h"
#import "ImageScrollView.h"

@interface MediaView()
<ImageScrollViewDataSource>
{
    BOOL isInit;
    ImageScrollView *imageScrollView;
    UIPageControl *control;
    UILabel *pageLabel;
    NSUInteger totalNumber;
}

@end

@implementation MediaView
@synthesize dataList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView
{
    if(!isInit){
        imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.cellResetWhenRemove = YES;
        imageScrollView.dataSource = self;
        imageScrollView.scrollEnabled = YES;
        [self addSubview:imageScrollView];
        control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 10)];
        [self addSubview:control];
        control.hidden = YES;
        CGFloat labelHeight = 25;
        pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-labelHeight, self.frame.size.width, labelHeight)];
        pageLabel.textColor = [UIColor whiteColor];
        pageLabel.font = [UIFont systemFontOfSize:12];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.backgroundColor = RGBA(0, 0, 0, 0.35);
        [self addSubview:pageLabel];
        self.clipsToBounds = YES;
        if(dataList){
            [imageScrollView reload];
        }
        isInit = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    imageScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    control.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 10);
}

- (void)setDataList:(NSArray *)aList
{
    dataList = aList;
    control.numberOfPages = dataList.count;
    totalNumber = dataList.count;
    pageLabel.hidden = dataList.count<=0;
    [imageScrollView reload];
}

- (void)stopVideoPlay
{
    for(id key in imageScrollView.displayCells.allKeys){
        MediaCell *mCell = [imageScrollView.displayCells objectForKey:key];
        [mCell stopVideo];
    }
}

#pragma mark - ImageScrollViewDataSource
- (NSUInteger)totalNumber
{
    return dataList.count;
}

- (ImageCell*)imageCellAtIndex:(NSInteger)index
{
    static NSString *identifier = @"MediaCell";
    MediaCell *cell = [imageScrollView dequeueReusableCellWithReuseIdentifier:identifier];
    if(!cell){
        cell = [[MediaCell alloc] initWithFrame:imageScrollView.bounds];
        cell.identifier = identifier;
    }
    cell.media = [dataList objectAtIndex:index];
    return cell;
}

- (void)scrollViewDidShowNewCell:(ImageCell*)cell index:(NSInteger)index
{
    control.currentPage = index;
    pageLabel.text = [NSString stringWithFormat:@"%d/%d",(int)(index+1),(int)totalNumber];
    //stop video
    for(id key in imageScrollView.displayCells.allKeys){
        MediaCell *mCell = [imageScrollView.displayCells objectForKey:key];
        if(mCell != cell){
            [mCell stopVideo];
        }
    }
}

@end
