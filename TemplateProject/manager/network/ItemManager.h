//
//  ItemManager.h
//  YanMo
//
//  Created by 蚁众 on 15/12/15.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemManager : NSObject

+ (instancetype)shareInstance;

//确认节目
- (NSOperation *)SureOverWithJobId:(NSInteger)jobId completion:(BooleanBlock)completion;

@end
