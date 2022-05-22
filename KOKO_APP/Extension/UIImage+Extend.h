//
//  UIImage+convertGradientToImage.h
//  ASUSWebStorage
//
//  Created by jim on 2020/6/4.
//  Copyright © 2020 asuscloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(Extend)

+ (UIImage *)convertGradientToImage:(UIColor *)startColor endColor:(UIColor *)endColor frame:(CGRect)frame;
+ (UIImage *)createOvalImage:(UIColor *)startColor endColor:(UIColor *)endColor frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
