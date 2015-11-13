//
//  PlaceholderImageView.h
//  MeiMei
//
//  Created by 马鑫 on 14-7-4.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    占位图
 */

@interface PlaceholderImageView : UIView

+ (PlaceholderImageView *) getPlaceholderImageByTitle:(NSString*)title;

@property (nonatomic,strong) NSString *title;

@end
