//
//  PlaceholderTableView.h
//  LaneTrip
//
//  Created by antsmen on 15-5-11.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTableView : UITableView

@property (nonatomic,strong) NSString *placeholderString;

- (void)showPlaceholder:(BOOL)isShow;

@end
