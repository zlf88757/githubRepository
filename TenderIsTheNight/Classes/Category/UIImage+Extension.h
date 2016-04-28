//
//  UIImage+Extension.h
//  CYG网易新闻框架-test
//
//  Created by 千锋 on 15/12/5.
//  Copyright © 2015年 cyg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)resizedImage:(NSString *)name;

//利用颜色创建一张图片
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
