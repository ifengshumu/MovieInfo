//
//  UIColor+MethodExtend.h
//  ZHUIKit
//
//  Created by zach on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NSString *UIColorRGBValue NS_EXTENSIBLE_STRING_ENUM;
UIKIT_EXTERN UIColorRGBValue const UIColorRedValue;
UIKIT_EXTERN UIColorRGBValue const UIColorGreenValue;
UIKIT_EXTERN UIColorRGBValue const UIColorBlueValue;
UIKIT_EXTERN UIColorRGBValue const UIColorAlphaValue;


typedef NS_ENUM(NSUInteger, UIGradientColorDirection) {
    /// 水平
    UIGradientColorDirectionHorizontal,
    /// 垂直
    UIGradientColorDirectionVertical,
};

@interface UIColor (MethodExtend)
/**
 十六进制颜色值转UIColor，
 hexString除去开头的0X或#为6位或8位，
 hexStringt如果是6位则alpha=1，如果为8位则使用颜色值中的透明度
 
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 十六进制颜色值转UIColor，指定alpha
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 UIColor转十六进制颜色值
 */
- (NSString *)hexString;

/**
 渐变颜色
 
 @param aSize 渐变尺寸
 @param direction 渐变方向
 */
+ (UIColor *)gradientColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)aSize direction:(UIGradientColorDirection)direction;

/**
 RGB(red、green、blue、alpha)字典，key=BTColorHexStringRedValue
 
 @param colorObject UIColor或十六进制颜色值
 @return RGB
 */
+ (NSDictionary<UIColorRGBValue, id> *)rgbValueFromColorObject:(id)colorObject;


@end

