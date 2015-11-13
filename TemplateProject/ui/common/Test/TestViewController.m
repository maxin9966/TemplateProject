//
//  TestViewController.m
//  TemplateProject
//
//  Created by admin on 15/7/24.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "TestViewController.h"
#import "BannerScrollView.h"

/**
 
 bean
 
 */

@interface FlashBgBean : NSObject

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) CGRect frame;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *highlightedImage;

@property (nonatomic,assign) BOOL highlighted;

@property (nonatomic,assign) NSInteger count;

@end

@implementation FlashBgBean
@synthesize index,frame,normalImage,highlightedImage,highlighted,count;

- (BOOL)highlighted
{
    return count>=(frame.size.width*frame.size.height*0.35);
}

@end

/**
 
 vc
 
 */

#define BgLineNumber 20

@interface TestViewController ()
{
    UIImageView *iv;
    BannerScrollView *bannerScrollView;
}

@end

@implementation TestViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat height = SCREEN_WIDTH;
    CGFloat width = SCREEN_HEIGHT;//image.size.width/image.size.height*height;
    bannerScrollView = [[BannerScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.f-width/2.f, SCREEN_HEIGHT/2-height/2, width, height)];
    bannerScrollView.minOffset = SCREEN_WIDTH/BgLineNumber;
    bannerScrollView.speed = 1;
    bannerScrollView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:bannerScrollView];
    bannerScrollView.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    UIImage *image = [self createFlashImageWithTextImage:[self imageWithText:@"ALKDJLLDSD卡老地方独立开"]];
    bannerScrollView.images = @[image];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [bannerScrollView start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*)imageWithText:(NSString*)text
{
    CGFloat imageHeight = SCREEN_WIDTH;
    
    CGFloat leftMarginX = 30;
    UIFont *font = [UIFont boldSystemFontOfSize:imageHeight*(280.f/320.f)];
    UIColor *textColor  = RGBA(255, 255, 255, 1);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *dict = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:textColor};
    CGSize textSize = [text sizeWithAttributes:dict];
    
    CGFloat marginY = (imageHeight-textSize.height)/2;
    
    CGFloat imageWidth = (imageHeight-marginY*2)*(textSize.width/textSize.height)+leftMarginX;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), YES, SCREEN_SCALE);
    [text drawInRect:CGRectMake(leftMarginX, marginY, textSize.width, textSize.height) withAttributes:dict];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)createFlashImageWithTextImage:(UIImage*)textImage
{
    if(textImage==nil || textImage.size.width==0 || textImage.size.height==0)
        return nil;
    
    //data
    CGSize imageSize = textImage.size;
    imageSize.width *= textImage.scale;
    imageSize.height *= textImage.scale;
    
//    imageSize.width = (int)imageSize.width;
//    imageSize.height = (int)imageSize.height;
    
    CGFloat bgSideLength = imageSize.height/BgLineNumber;
    CGFloat newSizeWidth = imageSize.width+imageSize.height*(SCREEN_HEIGHT/SCREEN_WIDTH);
    NSInteger bgNumberPerRow = newSizeWidth/bgSideLength+1;
    newSizeWidth = bgNumberPerRow*bgSideLength;
    CGSize newSize = CGSizeMake(newSizeWidth, imageSize.height);
    
    newSize.width = (int)newSize.width;
    newSize.height = (int)newSize.height;
    
    int bytesPerRow	= 4*newSize.width;
    
    //bean data
    NSMutableDictionary *bgBeanDict = [NSMutableDictionary dictionary];
    NSInteger index = 0;
    UIImage *normalImage = [UIImage imageNamed:@"flash_bg_n"];
    UIImage *highlightedImage = [UIImage imageNamed:@"flash_bg_h"];
    for(int i=0;i<BgLineNumber;i++){
        for(int j=0;j<bgNumberPerRow;j++){
            FlashBgBean *bean = [FlashBgBean new];
            bean.index = index;
            bean.frame = CGRectMake(j*bgSideLength, i*bgSideLength, bgSideLength, bgSideLength);
            bean.normalImage = normalImage;
            bean.highlightedImage = highlightedImage;
            [bgBeanDict setObject:bean forKey:@(index)];
            index++;
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char* rgbData = malloc(bytesPerRow*newSize.height);
    //创建Bitmap Context，也就是图像缓冲区
    CGContextRef context = CGBitmapContextCreate(rgbData,
                                                 newSize.width,newSize.height,//缓冲区的尺寸
                                                 8,//RGBA每个通道8位
                                                 bytesPerRow,//每行像素占用的总字节数
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    if(context==0)
        return nil;
    
    CGRect rect	= CGRectMake(0, 0, imageSize.width, imageSize.height);//绘制的目标区域
    CGContextDrawImage(context, rect, textImage.CGImage);//将原始图像绘制到图像缓冲区中（其中包含了图像解码的过程）
    
    int r = 0;
    int g = 0;
    int b = 0;
    for(int y = 0;y<newSize.height; y++)
    {
        for (int x = 0; x<newSize.width; x++) {
            int offset = bytesPerRow*y+x*4;
            r = rgbData[offset];
            g = rgbData[offset+1];
            b = rgbData[offset+2];
            if(r>0 && g>0 && b>0){
                //有内容
                NSInteger xIndex = x/bgSideLength;
                NSInteger yIndex = y/bgSideLength;
                NSInteger index = yIndex*bgNumberPerRow+xIndex;
                FlashBgBean *instance = [bgBeanDict objectForKeySafely:@(index)];
                instance.count++;
            }
        }
    }
    CGContextRelease(context);
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, SCREEN_SCALE);
    for(id key in bgBeanDict.allKeys){
        FlashBgBean *bean = [bgBeanDict objectForKeySafely:key];
        UIImage *drawImage = nil;
        drawImage = bean.highlighted ? bean.highlightedImage : bean.normalImage;
        [drawImage drawInRect:bean.frame];
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
