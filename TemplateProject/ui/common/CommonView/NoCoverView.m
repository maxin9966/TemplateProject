//
//  NoCoverView.m
//  MeiYue
//
//  Created by antsmen on 15/6/1.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "NoCoverView.h"

@interface NoCoverView()
{
    UIView *focusView;
    BOOL isKeyboardShow;
    CGFloat superOriginY;
}

@end

@implementation NoCoverView
@synthesize targetView;

- (void)didMoveToWindow
{
    if(self.window){
        //注册观察者
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }else{
        //移除观察者
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

#pragma mark - notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    if(targetView){
        focusView = targetView;
    }
    if(!focusView){
        focusView = [self firstResponderInView:self];
    }
    if(!focusView){
        return;
    }
    NSDictionary *info = [notification userInfo];
    //当前键盘尺寸
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    //部分第三方输入法适配
    if(!keyboardSize.height){
        return;
    }
    CGFloat kbHeight = keyboardSize.height;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [focusView.superview convertRect:focusView.frame toView:window];
    
    if(!isKeyboardShow){
        superOriginY = self.frame.origin.y;
    }
    CGFloat offsetY = (rect.origin.y+rect.size.height)-(window.frame.size.height-kbHeight);
    if(offsetY>-8){
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-offsetY-8, self.frame.size.width, self.frame.size.height);
    }
    isKeyboardShow = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if(isKeyboardShow && focusView){
        self.frame = CGRectMake(self.frame.origin.x, superOriginY, self.frame.size.width, self.frame.size.height);
        isKeyboardShow = NO;
        focusView = nil;
    }
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
