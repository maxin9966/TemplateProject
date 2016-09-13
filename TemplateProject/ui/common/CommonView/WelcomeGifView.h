//
//  WelcomeGifView.h
//  YanMo
//
//  Created by admin on 16/3/24.
//  Copyright © 2016年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeGifView : UIView

+ (void)showWithGifName:(NSString*)gifName completion:(CommonBlock)completion;

+ (void)dismiss;

@end
