//
//  UITableView+DataList.m
//  YanMo-Artist
//
//  Created by admin on 16/3/7.
//  Copyright © 2016年 antsmen. All rights reserved.
//

#import "UITableView+DataList.h"
#import <objc/runtime.h>

@implementation UITableView (DataList)
@dynamic dataList,op,isRequesting,needsRefresh,noMore,placeholderImage,placeholderImageView,loadDataBlock;

- (void)mx_addPullToRefresh
{
    __weak typeof(self)wSelf = self;
    //增加下拉刷新
    [self addPullToRefreshWithActionHandler:^{
        [wSelf reload];
    }];
}

- (void)mx_reload
{
    if(!self.pullToRefreshView){
        [self mx_addPullToRefresh];
    }
    [self.pullToRefreshView triggerRefresh];
}

- (void)reload
{
    [self mx_cancel];
    if(!self.dataList){
        self.dataList = [NSMutableArray array];
    }
    self.needsRefresh = YES;
    self.noMore = NO;
    self.loaded = NO;
    [self mx_loadMore];
}

- (void)mx_loadMore
{
    if(self.isRequesting){
        return;
    }
    NSInteger startIndex = self.dataList.count;
    if(self.needsRefresh){
        startIndex = 0;
        //[self.view showLoadingTips:@"正在加载"];
    }else{
        if(self.noMore){
            return;
        }
    }
    self.isRequesting = YES;
    if(self.op){
        [self.op cancel];
    }
    self.op = self.loadDataBlock(self, startIndex);
}

- (void)mx_completion:(NSArray*)list noMore:(BOOL)noMore error:(NSError*)error
{
    if(self.needsRefresh){
        [self.pullToRefreshView stopAnimating];
    }
    if(!error){
        //success
        if(self.needsRefresh){
            [self.dataList removeAllObjects];
        }
        self.noMore = noMore;
        if(self.noMore){
            //没有更多了
            //[self.view showTips:@"没有更多了"];
        }
        if(!self.loaded){
            self.loaded = YES;
        }
        [self.dataList addObjectsFromArray:list];
        [self reloadData];
        if(self.needsRefresh){
            self.needsRefresh = NO;
        }
        self.placeholderImageView.hidden = self.dataList.count>0;
        self.placeholderImageView.frame = self.bounds;
    }else{
        //error
    }
    self.isRequesting = NO;
}

- (void)mx_cancel
{
    if(self.isRequesting){
        [self.op cancel];
        self.isRequesting = NO;
//        [self.pullToRefreshView stopAnimating];
    }
}

#pragma mark - getter setter

static char dataListKey = 0;
static char opKey = 0;
static char isRequestingKey = 0;
static char needsRefreshKey = 0;
static char noMoreKey = 0;
static char loadedKey = 0;
static char placeholderImageKey = 0;
static char placeholderImageViewKey = 0;
static char loadDataBlockKey = 0;

- (NSMutableArray*)dataList
{
    return objc_getAssociatedObject(self, &dataListKey);
}

- (void)setDataList:(NSMutableArray *)dataList
{
    objc_setAssociatedObject(self, &dataListKey, dataList, OBJC_ASSOCIATION_RETAIN);
}

- (NSOperation*)op
{
    return objc_getAssociatedObject(self, &opKey);
}

- (void)setOp:(NSOperation *)op
{
    objc_setAssociatedObject(self, &opKey, op, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isRequesting
{
    return [objc_getAssociatedObject(self, &isRequestingKey) boolValue];
}

- (void)setIsRequesting:(BOOL)isRequesting
{
    objc_setAssociatedObject(self, &isRequestingKey, @(isRequesting), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)needsRefresh
{
    return [objc_getAssociatedObject(self, &needsRefreshKey) boolValue];
}

- (void)setNeedsRefresh:(BOOL)needsRefresh
{
    objc_setAssociatedObject(self, &needsRefreshKey, @(needsRefresh), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)noMore
{
    return [objc_getAssociatedObject(self, &noMoreKey) boolValue];
}

- (void)setNoMore:(BOOL)noMore
{
    objc_setAssociatedObject(self, &noMoreKey, @(noMore), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)loaded
{
    return [objc_getAssociatedObject(self, &loadedKey) boolValue];
}

- (void)setLoaded:(BOOL)loaded
{
    objc_setAssociatedObject(self, &loadedKey, @(loaded), OBJC_ASSOCIATION_RETAIN);
}

- (TableViewLoadDataBlock)loadDataBlock
{
    return objc_getAssociatedObject(self, &loadDataBlockKey);
}

- (void)setLoadDataBlock:(TableViewLoadDataBlock)loadDataBlock
{
    objc_setAssociatedObject(self, &loadDataBlockKey, loadDataBlock, OBJC_ASSOCIATION_COPY);
}

- (UIImage*)placeholderImage
{
    return objc_getAssociatedObject(self, &placeholderImageKey);
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    objc_setAssociatedObject(self, &placeholderImageKey, placeholderImage, OBJC_ASSOCIATION_RETAIN);
    if(!self.placeholderImageView){
        self.placeholderImageView = [[UIImageView alloc] init];
        self.placeholderImageView.contentMode = UIViewContentModeCenter;
        self.placeholderImageView.image = placeholderImage;
        self.placeholderImageView.hidden = YES;
        [self addSubview:self.placeholderImageView];
    }
}

- (UIImageView*)placeholderImageView
{
    return objc_getAssociatedObject(self, &placeholderImageViewKey);
}

- (void)setPlaceholderImageView:(UIImageView *)placeholderImageView
{
    objc_setAssociatedObject(self, &placeholderImageViewKey, placeholderImageView, OBJC_ASSOCIATION_RETAIN);
}

@end
