//
//  UIButton+MethodExtend.h
//  ZHUIKit
//
//  Created by 李志华 on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, UIButtonImageTextAlignmentStyle) {
    ///左图右文
    UIButtonImageTextAlignmentStyleDefault = 0,
    ///左文右图
    UIButtonImageTextAlignmentStyleReverse,
    ///上图下文
    UIButtonImageTextAlignmentStyleRotateCW,
    ///上文下图
    UIButtonImageTextAlignmentStyleRotateCCW,
};

@interface UIButton (MethodExtend)

/**
 可以让UIButton携带多参数
 */
@property (nonatomic, copy) NSDictionary *userInfo;

/**
 初始化UIButton
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)aTitle titleColor:(UIColor *)aColor titleFont:(UIFont *)aFont image:(UIImage *)aImage;

/**
 初始化UIButton，带Block事件
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)aTitle titleColor:(UIColor *)aColor titleFont:(UIFont *)aFont image:(UIImage *)aImage actionHandler:(void(^)(UIButton *sedner))action;

/**
 添加Block事件
 */
- (void)addActionHandler:(void(^)(UIButton *sedner))action;

/**
 设置按钮图片文字排列位置，务必在按钮图片文字和frame设置完毕后调用

 @param style see UIButtonImageTextAlignmentStyle
 @param space 图片文字间距
 */
- (void)setImageTextAlignmentStyle:(UIButtonImageTextAlignmentStyle)style  space:(CGFloat)space;

/**
 倒计时

 @param dutation 时间
 @param title 倒计时结束时按钮显示标题
 @param remainingTime 剩余时间
 */
- (void)countdownWithDuration:(NSUInteger)dutation endButtonTitle:(NSString *)title remainingTime:(void(^)(NSUInteger time))remainingTime;
@end

