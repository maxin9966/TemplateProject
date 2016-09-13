/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "UIViewController+DismissKeyboard.h"

@implementation UIViewController (DismissKeyboard)

- (void)setupTapGestureForDismissKeyboard {
    
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    
    __weak UIViewController *weakSelf = self;
    
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [DefaultNotificationCenter addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view addGestureRecognizer:singleTapGR];
                }];
    [DefaultNotificationCenter addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)setupCloseBtnForDismissKeyboard
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    __weak UIViewController *weakSelf = self;
    
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [DefaultNotificationCenter addObserverForName:UIKeyboardWillShowNotification
                                           object:nil
                                            queue:mainQuene
                                       usingBlock:^(NSNotification *note){
                                           [weakSelf.view addSubview:btn];
                                       }];
    [DefaultNotificationCenter addObserverForName:UIKeyboardWillHideNotification
                                           object:nil
                                            queue:mainQuene
                                       usingBlock:^(NSNotification *note){
                                           [btn removeFromSuperview];
                                       }];
}

- (void)closeKeyboard
{
    [self.view endEditing:YES];
}

- (void)setupAutoRise
{
    __weak UIViewController *weakSelf = self;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    
    __block UIView *focusInput;
    __block BOOL isKeyboardShow;
    __block CGFloat superOriginY;
    [DefaultNotificationCenter addObserverForName:UIKeyboardWillShowNotification
                                           object:nil
                                            queue:mainQuene
                                       usingBlock:^(NSNotification *note){
                                           focusInput = [weakSelf firstResponderInView:weakSelf.view];
                                           if(!focusInput){
                                               return;
                                           }
                                           NSDictionary *info = [note userInfo];
                                           //当前键盘尺寸
                                           NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
                                           CGSize keyboardSize = [value CGRectValue].size;
                                           //部分第三方输入法适配
                                           if(!keyboardSize.height){
                                               return;
                                           }
                                           CGFloat kbHeight = keyboardSize.height;
                                           
                                           UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                           CGRect rect = [focusInput.superview convertRect:focusInput.frame toView:window];
                                           
                                           if(!isKeyboardShow){
                                               superOriginY = weakSelf.view.frame.origin.y;
                                           }
                                           CGFloat offsetY = (rect.origin.y+rect.size.height)-(window.frame.size.height-kbHeight);
                                           if(offsetY>-8){
                                               weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, weakSelf.view.frame.origin.y-offsetY-8, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
                                           }
                                           isKeyboardShow = YES;
                                       }];
    [DefaultNotificationCenter addObserverForName:UIKeyboardWillHideNotification
                                           object:nil
                                            queue:mainQuene
                                       usingBlock:^(NSNotification *note){
                                           if(isKeyboardShow && focusInput){
                                               weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, superOriginY, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
                                               isKeyboardShow = NO;
                                               focusInput = nil;
                                           }
                                       }];
    [DefaultNotificationCenter addObserverForName:NotificationNavigationPopGestureWillBegin
                                           object:nil
                                            queue:mainQuene
                                       usingBlock:^(NSNotification *note){
                                           //解决手势返回时 界面显示异常的bug
                                           if(isKeyboardShow && focusInput){
                                               [focusInput resignFirstResponder];
                                           }
                                       }];
}

#pragma mark - method
- (UIView *)firstResponderInView:(UIView*)view
{
    for(UIView *subview in view.subviews){
        if(subview.isFirstResponder){
            return subview;
        }else{
            UIView *view = [self firstResponderInView:subview];
            if(view){
                return view;
            }
        }
    }
    return nil;
}

@end
