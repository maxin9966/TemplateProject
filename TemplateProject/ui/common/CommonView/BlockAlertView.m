//
//  BlockAlertView.m
//  bcj
//
//  Created by antsmen on 15-3-25.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "BlockAlertView.h"

@interface BlockAlertView()<UIAlertViewDelegate>
{
    AlertActionBlock actionBlock;
}

@end

@implementation BlockAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actionBlock:(AlertActionBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    actionBlock = block;
    return [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionBlock){
        actionBlock(buttonIndex);
    }
}

@end
