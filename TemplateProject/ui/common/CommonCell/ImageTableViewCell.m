//
//  ImageCell.m
//  TemplateProject
//
//  Created by antsmen on 15/6/23.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "ImageTableViewCell.h"

@interface ImageTableViewCell()
{
    IBOutlet UIImageView *aImageView;
}

@end

@implementation ImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageWithURL:(NSString*)urlString
{
    [self reset];
    [aImageView mx_setImageWithURL:urlString placeholderImage:nil completed:^(UIImage *image, NSError *error) {
        
    }];
}

- (void)reset
{
    [aImageView mx_cancelCurrentImageLoad];
}

@end
