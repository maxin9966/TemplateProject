//
//  BlockAlertView.h
//  bcj
//
//  Created by antsmen on 15-3-25.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertActionBlock)(NSInteger buttonIndex);

@interface BlockAlertView : UIAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actionBlock:(AlertActionBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
