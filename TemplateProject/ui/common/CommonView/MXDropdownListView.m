//
//  MXDropdownListView.m
//  YanMo-Artist
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "MXDropdownListView.h"

@interface MXDropdownListView ()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MXDropdownListView

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
    self.selectedIndex = -1;
    _cellHeight = 44.f;
    _maxListHeight = 263.5f;
    _normalTitleColor = [UIColor blackColor];
    _highlightTitleColor = LT_Color_Main;
    [self addTarget:self action:@selector(bgTap) forControlEvents:UIControlEventTouchUpInside];
    CGFloat selfWidth = self.frameWidth;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 0) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.alwaysBounceVertical = NO;
    _tableView.alwaysBounceHorizontal = NO;
    self.userInteractionEnabled = NO;
    self.clipsToBounds = YES;
}

- (void)bgTap
{
    [self dismiss];
}

- (void)setDataList:(NSMutableArray *)dataList
{
    _dataList = dataList;
}

#pragma mark - public method
- (void)show
{
    if(_visible || !_dataList.count){
        return;
    }
    __weak typeof(self)wSelf = self;
    CGFloat tableViewHeight = _dataList.count*_cellHeight;
    if(tableViewHeight>_maxListHeight){
        tableViewHeight = _maxListHeight;
    }
    _tableView.frame = CGRectMake(0, -tableViewHeight, self.frameWidth, tableViewHeight);
    [_tableView reloadData];
    self.backgroundColor = RGBA(0, 0, 0, 0);
    [self addSubview:_tableView];
    [UIView animateWithDuration:0.22 animations:^{
        wSelf.backgroundColor = RGBA(0, 0, 0, 0.3f);
        wSelf.tableView.frame = CGRectMake(0, 0, wSelf.frameWidth, wSelf.tableView.frameHeight);
    } completion:^(BOOL finished) {
        wSelf.userInteractionEnabled = YES;
    }];
    self.visible = YES;
}

- (void)dismiss
{
    if(!_visible){
        return;
    }
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        wSelf.backgroundColor = RGBA(0, 0, 0, 0);
        wSelf.tableView.frame = CGRectMake(0, -wSelf.tableView.frameHeight, wSelf.frameWidth, wSelf.tableView.frameHeight);
    } completion:^(BOOL finished) {
        wSelf.userInteractionEnabled = NO;
    }];
    self.visible = NO;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    }
    id object = [self.dataList objectAtIndexSafely:indexPath.row];
    if(_delegate && [_delegate respondsToSelector:@selector(mxDropdownListView:titleForData:index:)]){
        cell.textLabel.text = [_delegate mxDropdownListView:self titleForData:object index:indexPath.row];
    }else{
        if([object isKindOfClass:[NSString class]]){
            cell.textLabel.text = object;
        }
    }
    if(_delegate && [_delegate respondsToSelector:@selector(mxDropdownListView:iconForData:index:)]){
        cell.imageView.image = [_delegate mxDropdownListView:self iconForData:object index:indexPath.row];
    }
    __weak typeof(self)wSelf = self;
    [RACObserve(self, selectedIndex) subscribeNext:^(id object) {
        if(wSelf.selectedIndex>=0 && indexPath.row == wSelf.selectedIndex){
            //高亮
            cell.textLabel.textColor = _highlightTitleColor;
        }else{
            //非高亮
            cell.textLabel.textColor = _normalTitleColor;
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id object = [self.dataList objectAtIndexSafely:indexPath.row];
    if(_delegate && [_delegate respondsToSelector:@selector(mxDropdownListView:didSelect:index:)]){
        [_delegate mxDropdownListView:self didSelect:object index:indexPath.row];
    }
}

@end
