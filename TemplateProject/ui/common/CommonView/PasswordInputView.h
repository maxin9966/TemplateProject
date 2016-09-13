//
//  NumberInputView.h
//  YanMo-Artist
//
//  Created by admin on 15/12/30.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "NoCoverView.h"

@class PasswordInputView;

typedef void (^PasswordInputViewCompleteBlock)(PasswordInputView *inputView, NSString *text);
typedef void (^PasswordInputViewCancelBlock)(PasswordInputView *inputView);

@interface PasswordInputView : UIControl

@property (nonatomic,assign) BOOL visible;

@property (nonatomic,strong) PasswordInputViewCompleteBlock completeBlock;

@property (nonatomic,strong) PasswordInputViewCancelBlock cancelBlock;

- (id)initWithPasswordNumber:(NSUInteger)number title:(NSString*)title description:(NSString*)des;

- (void)show;

- (void)dismiss;

@end
