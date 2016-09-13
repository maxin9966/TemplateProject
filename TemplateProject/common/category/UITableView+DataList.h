//
//  UITableView+DataList.h
//  YanMo-Artist
//
//  Created by admin on 16/3/7.
//  Copyright © 2016年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSOperation * (^TableViewLoadDataBlock)(UITableView *tableView,NSInteger startIndex);

@interface UITableView (DataList)

@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSOperation *op;
@property (nonatomic,assign) BOOL isRequesting;
@property (nonatomic,assign) BOOL needsRefresh;
@property (nonatomic,assign) BOOL noMore;
@property (nonatomic,assign) BOOL loaded;
@property (nonatomic,strong) UIImage *placeholderImage;
@property (nonatomic,strong) UIImageView *placeholderImageView;

@property (nonatomic,copy) TableViewLoadDataBlock loadDataBlock;

- (void)mx_reload;

- (void)mx_loadMore;

- (void)mx_completion:(NSArray*)list noMore:(BOOL)noMore error:(NSError*)error;

- (void)mx_cancel;

@end
