//
//  UIImage+convertGradientToImage.m
//  ASUSWebStorage
//
//  Created by jim on 2020/6/4.
//  Copyright © 2020 asuscloud. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage(Extend)

+ (UIImage *)convertGradientToImage:(UIColor *)startColor endColor:(UIColor *)endColor frame:(CGRect)frame {
    
    // start with a CAGradientLayer
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    [gradientLayer setFrame:frame];
    
    // add colors as CGCologRef to a new array and calculate the distances
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
//    gradientLayer.locations = @[@0.50, @0.50];

    gradientLayer.startPoint = CGPointMake(0.0, 0.5);   // start at left middle
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);     // end at right middle
    gradientLayer.cornerRadius = 20.0;

    // now build a UIImage from the gradient
    UIGraphicsBeginImageContext(gradientLayer.bounds.size);
    
    if (UIGraphicsGetCurrentContext() != nil) {
        [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    }

    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // return the gradient image
    return gradientImage;
}

+ (UIImage *)createOvalImage:(UIColor *)startColor endColor:(UIColor *)endColor frame:(CGRect)frame {
    
    // start with a CAGradientLayer
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    frame.size.width = 30.0;
    frame.size.height = 5.0;
    [gradientLayer setFrame:frame];
    
    // add colors as CGCologRef to a new array and calculate the distances
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
//    gradientLayer.locations = @[@0.50, @0.50];

    gradientLayer.startPoint = CGPointMake(0.0, 0.5);   // start at left middle
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);     // end at right middle
    gradientLayer.cornerRadius = 3.0;

    // now build a UIImage from the gradient
    UIGraphicsBeginImageContext(gradientLayer.bounds.size);
    
    if (UIGraphicsGetCurrentContext() != nil) {
        [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    }

    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // return the gradient image
    return gradientImage;
}


@end
