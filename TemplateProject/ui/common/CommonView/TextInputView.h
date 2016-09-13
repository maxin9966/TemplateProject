//
//  TextInputView.h
//  FansKit
//
//  Created by antsmen on 15-1-7.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextInputView;

@protocol TextInputViewDelegate <NSObject>
@optional

- (void)textInputViewAffirm:(TextInputView*)inputView;
- (void)textInputViewCancel:(TextInputView*)inputView;

@end

@interface TextInputView : UIView

@property (nonatomic,assign) id<TextInputViewDelegate> delegate;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *placeholder;
@property (nonatomic,assign) NSUInteger limmitNumber;

@property (nonatomic,strong) IBOutlet UITextField *textField;

- (void)show;
- (void)dismiss;

@end
