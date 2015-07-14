//
//  MainViewController.m
//  TemplateProject
//
//  Created by antsmen on 15/6/23.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MainViewController.h"
#import "ImageTableViewCell.h"

@interface MainViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
    NSMutableArray *dataList;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self installNavigationBar];
    [self setNavigationTitle:@"主界面"];
    
    UINib *nib = [UINib nibWithNibName:@"ImageTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"ImageTableViewCell"];
    
    dataList = [NSMutableArray array];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [dataList removeAllObjects];
    
    for(int i = 0 ; i<200; i++){
        [dataList addObject:[[MyCommon getRandomImageURL] absoluteString]];
    }
    
    [tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell" forIndexPath:indexPath];
    [cell setImageWithURL:[dataList objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

@end
