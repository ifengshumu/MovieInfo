//
//  UIColor+MethodExtend.m
//  ZHUIKit
//
//  Created by zach on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "UIColor+MethodExtend.h"

UIColorRGBValue const UIColorRedValue = @"ColorRedValue";
UIColorRGBValue const UIColorGreenValue = @"ColorGreenValue";
UIColorRGBValue const UIColorBlueValue = @"ColorBlueValue";
UIColorRGBValue const UIColorAlphaValue = @"ColorAlphaValue";


@implementation UIColor (MethodExtend)
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSDictionary *rgb = [self colorValueFromHexString:hexString];
    CGFloat red = [rgb[UIColorRedValue] floatValue];
    CGFloat green = [rgb[UIColorGreenValue] floatValue];
    CGFloat blue = [rgb[UIColorBlueValue] floatValue];
    CGFloat alpha = [rgb[UIColorAlphaValue] floatValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSDictionary *rgb = [self colorValueFromHexString:hexString];
    CGFloat red = [rgb[UIColorRedValue] floatValue];
    CGFloat green = [rgb[UIColorGreenValue] floatValue];
    CGFloat blue = [rgb[UIColorBlueValue] floatValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)hexString {
    //颜色值个数，rgb和alpha
    NSInteger cpts = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    if (cpts == 4) {
        CGFloat a = components[3];//透明度
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX", lroundf(a * 255), lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    } else {
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    }
}

+ (UIColor *)gradientColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)aSize direction:(UIGradientColorDirection)direction {
    UIGraphicsBeginImageContextWithOptions(aSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray *colors = @[(__bridge id)fromColor.CGColor, (__bridge id)toColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGPoint endPoint = CGPointZero;
    if (direction == UIGradientColorDirectionHorizontal) {
        //水平
        endPoint = CGPointMake(aSize.width, 0);
    } else {
        //垂直
        endPoint = CGPointMake(0, aSize.height);
    }
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), endPoint, 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

+ (NSDictionary *)rgbValueFromColorObject:(id)colorObject {
    if ([colorObject isKindOfClass:[NSString class]]) {
        return [self colorValueFromHexString:colorObject];
    } else {
        return [self colorValueFromColor:colorObject];
    }
}

+ (NSDictionary *)colorValueFromHexString:(NSString *)hexString {
    //去除空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //把开头截取
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //6位或8位(带透明度)
    if ([cString length] < 6) {
        return nil;
    }
    //取出透明度、红、绿、蓝
    unsigned int a, r, g, b;
    NSRange range;
    range.location = 0;
    range.length = 2;
    if (cString.length == 8) {
        //a
        NSString *aString = [cString substringWithRange:range];
        //r
        range.location = 2;
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 4;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 6;
        NSString *bString = [cString substringWithRange:range];
        
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return @{UIColorRedValue:@(r / 255.0f), UIColorGreenValue:@(g / 255.0f), UIColorBlueValue:@(b / 255.0f), UIColorAlphaValue:@(a / 255.0f)};
    } else {
        //r
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return @{UIColorRedValue:@(r / 255.0f), UIColorGreenValue:@(g / 255.0f), UIColorBlueValue:@(b / 255.0f), UIColorAlphaValue:@(1.0)};
    }
}

+ (NSDictionary *)colorValueFromColor:(UIColor *)aColor {
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    if ([self instancesRespondToSelector:@selector(getRed:green:blue:alpha:)]) {
        [aColor getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        const CGFloat *compoments = CGColorGetComponents(aColor.CGColor);
        red = compoments[0];
        green = compoments[1];
        blue = compoments[2];
        alpha = compoments[3];
    }
    return @{UIColorRedValue:@(red), UIColorGreenValue:@(green), UIColorBlueValue:@(blue), UIColorAlphaValue:@(alpha)};
}
@end
