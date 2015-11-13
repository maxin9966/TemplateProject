//
//  ImageScrollView.m
//  ScrollView
//
//  Created by MA on 14/11/17.
//  Copyright (c) 2014年 ma. All rights reserved.
//

#import "ImageScrollView.h"

#define PreLoadPage 1   //预加载页数

#define BasePage 999

@interface ImageScrollView()
<UIScrollViewDelegate>
{
    NSInteger nowIndex;
    NSInteger totalCount;
    
    NSMutableDictionary *recycleCells;//垃圾回收的cell
    
    NSInteger preStartIndex;
    NSInteger preEndIndex;
    
    UIScrollView *scrollView;
}

@end

@implementation ImageScrollView
@synthesize displayCells;
@synthesize dataSource;
@synthesize scrollEnabled;
@synthesize orientation;
@synthesize cellResetWhenRemove;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        displayCells = [NSMutableDictionary dictionary];
        recycleCells = [NSMutableDictionary dictionary];
        orientation = ScrollOrientationLandscape;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGFloat width = scrollView.frame.size.width;
//    CGFloat height = scrollView.frame.size.height;
//    scrollView.frame = self.bounds;
//    if(orientation == ScrollOrientationLandscape){
//        scrollView.contentSize = CGSizeMake(999999*self.frame.size.width, 0);
//        [scrollView setContentOffset:CGPointMake((nowIndex/totalCount)*totalCount*scrollView.frame.size.width, 0)];
//    }else{
//        scrollView.contentSize = CGSizeMake(0, 999999*self.frame.size.height);
//        [scrollView setContentOffset:CGPointMake(0, (nowIndex/totalCount)*totalCount*scrollView.frame.size.height)];
//    }
//    for(id key in displayCells.allKeys){
//        ImageCell *cell = [displayCells objectForKey:key];
//        if(orientation == ScrollOrientationLandscape){
//            cell.frame = CGRectMake(width*[key integerValue], 0, width, height);
//        }else{
//            cell.frame = CGRectMake(0, height*[key integerValue], width, height);
//        }
//    }
}

- (void)setScrollEnabled:(BOOL)enabled
{
    scrollEnabled = enabled;
    scrollView.scrollEnabled = enabled;
}

//下一页
- (void)nextPageAnimated:(BOOL)animated
{
    if(orientation == ScrollOrientationLandscape){
        CGFloat selfWidth = self.frame.size.width;
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        
        NSInteger nextIndex = (contentOffsetX+selfWidth)/selfWidth;
        if(animated){
            [UIView animateWithDuration:0.22 animations:^{
                [scrollView setContentOffset:CGPointMake(nextIndex*selfWidth, 0)];
            }];
        }else{
            [scrollView setContentOffset:CGPointMake(nextIndex*selfWidth, 0)];
        }
    }else{
        CGFloat selfHeight = self.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        
        NSInteger nextIndex = (contentOffsetY+selfHeight)/selfHeight;
        
        if(animated){
            [UIView animateWithDuration:0.22 animations:^{
                [scrollView setContentOffset:CGPointMake(0, nextIndex*selfHeight)];
            }];
        }else{
            [scrollView setContentOffset:CGPointMake(0, nextIndex*selfHeight)];
        }
    }
}

//上一页
- (void)prePageAnimated:(BOOL)animated
{
    if(orientation == ScrollOrientationLandscape){
        CGFloat selfWidth = self.frame.size.width;
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        
        NSInteger preIndex = (contentOffsetX-selfWidth)/selfWidth;
        
        if(animated){
            [UIView animateWithDuration:0.22 animations:^{
                [scrollView setContentOffset:CGPointMake(preIndex*selfWidth, 0) animated:animated];
            }];
        }else{
            [scrollView setContentOffset:CGPointMake(preIndex*selfWidth, 0) animated:animated];
        }
    }else{
        CGFloat selfHeight = self.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        
        NSInteger preIndex = (contentOffsetY-selfHeight)/selfHeight;
        
        [scrollView setContentOffset:CGPointMake(0, preIndex*selfHeight) animated:animated];
        if(animated){
            [UIView animateWithDuration:0.22 animations:^{
                [scrollView setContentOffset:CGPointMake(0, preIndex*selfHeight) animated:animated];
            }];
        }else{
            [scrollView setContentOffset:CGPointMake(0, preIndex*selfHeight) animated:animated];
        }
    }
}

//重置
- (void)reset
{
    nowIndex = -1;
    preStartIndex = -1;
    preEndIndex = -1;
    totalCount = 0;
    for(NSString *key in displayCells.allKeys){
        ImageCell *cell = [displayCells objectForKey:key];
        [cell removeFromSuperview];
    }
    [displayCells removeAllObjects];
    [recycleCells removeAllObjects];
    [scrollView setContentOffset:CGPointZero];
    [scrollView setContentSize:CGSizeZero];
    //test
    [scrollView removeFromSuperview];
    scrollView = nil;
}

//重载
- (void)reload
{
    if(!dataSource){
        return;
    }
    [self reset];
    if(!scrollView){
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollEnabled = scrollEnabled;
        [self addSubview:scrollView];
    }
    if(dataSource && [dataSource respondsToSelector:@selector(totalNumber)]){
        totalCount = [dataSource totalNumber];
        if(totalCount){
            if(orientation == ScrollOrientationLandscape){
                scrollView.contentSize = CGSizeMake(999999*self.frame.size.width, 0);
                [scrollView setContentOffset:CGPointMake((BasePage/totalCount)*totalCount*scrollView.frame.size.width, 0)];
            }else{
                scrollView.contentSize = CGSizeMake(0, 999999*self.frame.size.height);
                [scrollView setContentOffset:CGPointMake(0, (BasePage/totalCount)*totalCount*scrollView.frame.size.height)];
            }
            [self load];
        }
    }
}

//计算cell
- (void)load
{
    if(!scrollView){
        return;
    }
    if(!totalCount){
        return;
    }
    
    CGFloat sizeWidth = scrollView.frame.size.width;
    CGFloat sizeHeight = scrollView.frame.size.height;
    if(!sizeWidth || !sizeHeight){
        return;
    }
    
    NSInteger startIndex = 0;
    NSInteger endIndex = 0;
    
    if(orientation == ScrollOrientationLandscape){
        CGFloat offsetX = scrollView.contentOffset.x;
        
        //计算当前页码
        NSInteger index = (int)(offsetX/sizeWidth+0.5);
        if(index == nowIndex){
            return;
        }
        nowIndex = index;
        
        CGFloat aboveX = offsetX-PreLoadPage*sizeWidth;
        CGFloat belowX = offsetX+sizeWidth+PreLoadPage*sizeWidth;
        startIndex = (int)(aboveX/sizeWidth+0.5);
        endIndex = (int)(belowX/sizeWidth+0.5)-1;
    }else{
        CGFloat offsetY = scrollView.contentOffset.y;
        
        //计算当前页码
        NSInteger index = (int)(offsetY/sizeHeight+0.5);
        if(index == nowIndex){
            return;
        }
        nowIndex = index;
        
        CGFloat aboveY = offsetY-PreLoadPage*sizeHeight;
        CGFloat belowY = offsetY+sizeHeight+PreLoadPage*sizeHeight;
        startIndex = (int)(aboveY/sizeHeight+0.5);
        endIndex = (int)(belowY/sizeHeight+0.5)-1;
    }
    
    //大范围
    NSInteger start,end;
    if(startIndex>preStartIndex){
        start = preStartIndex;
    }else{
        start = startIndex;
    }
    if(endIndex>preEndIndex){
        end = endIndex;
    }else{
        end = preEndIndex;
    }

    [UIView setAnimationsEnabled:NO]; //以下代码屏蔽动画
    for(NSInteger i=start;i>=start && i<=end;i++){
        NSInteger pageIndex = i%totalCount;
        if((i>=startIndex && i<=endIndex) && !(i>=preStartIndex && i<=preEndIndex)){
            //需要新加载
            if(dataSource && [dataSource respondsToSelector:@selector(imageCellAtIndex:)]){
                ImageCell *cell = [dataSource imageCellAtIndex:pageIndex];//
                if(cell){
//                    if(orientation == ScrollOrientationLandscape){
//                        cell.center = CGPointMake((i+0.5)*sizeWidth, sizeHeight*0.5);
//                    }else{
//                        cell.center = CGPointMake(sizeWidth*0.5, (i+0.5)*sizeHeight);
//                    }
                    if(orientation == ScrollOrientationLandscape){
                        cell.frame = CGRectMake(sizeWidth*i, 0, sizeWidth, sizeHeight);
                    }else{
                        cell.frame = CGRectMake(0, sizeHeight*i, sizeWidth, sizeHeight);
                    }
                    [scrollView addSubview:cell];
                    [displayCells setObject:cell forKey:@(i)];//
                }
            }
        }else if (!(i>=startIndex && i<=endIndex) && (i>=preStartIndex && i<=preEndIndex)){
            //需要移除
            ImageCell *cell = [displayCells objectForKey:@(i)];
            if(cell){
                if(dataSource && [dataSource respondsToSelector:@selector(scrollViewWillRemoveCell:index:)]){
                    [dataSource scrollViewWillRemoveCell:cell index:pageIndex];
                }
                [cell removeFromSuperview];
                [displayCells removeObjectForKey:@(i)];//
                [self saveCell:cell];
                if(cellResetWhenRemove){
                    [cell reset];
                }
            }
        }
    }
    [UIView setAnimationsEnabled:YES];//恢复动画
    
    //NSLog(@"display cell count %d",displayCells.count);
    
    if(dataSource && [dataSource respondsToSelector:@selector(scrollViewDidShowNewCell:index:)]){
        ImageCell *nowCell = [self getCellWithIndex:nowIndex%totalCount];
        if(nowCell){
            [dataSource scrollViewDidShowNewCell:nowCell index:nowIndex%totalCount];
        }
    }
    
    preStartIndex = startIndex;
    preEndIndex = endIndex;
}

- (ImageCell*)getCellWithIndex:(NSInteger)index
{
    for(NSNumber *number in displayCells.allKeys){
        if([number integerValue]%totalCount == index){
            return [displayCells objectForKey:number];
        }
    }
    return nil;
}

#pragma mark - CellRecycle
//存入回收站
- (void)saveCell:(ImageCell*)cell
{
    if(!cell || !cell.identifier.length){
        return;
    }
    NSMutableArray *array = [recycleCells objectForKey:cell.identifier];
    if(!array){
        array = [NSMutableArray array];
        [recycleCells setObject:array forKey:cell.identifier];
    }
    [array addObject:cell];
}

//从回收站取出cell
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
{
    ImageCell *cell = nil;
    NSMutableArray *array = [recycleCells objectForKey:identifier];
    if(array && array.count){
        cell = [array objectAtIndex:0];
        [array removeObject:cell];
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    [self load];
}

@end

@implementation ImageCell
@synthesize identifier,index;

- (void)reset
{
    
}

@end
