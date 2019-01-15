//
//  UIView+MethodExtend.h
//  ZHUIKit
//
//  Created by 李志华 on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZHTransitonAnimationType) {
    ZHTransitonAnimationTypeFade, //交叉淡化过渡(不支持过渡方向)
    ZHTransitonAnimationTypePush, //新视图把旧视图推出去
    ZHTransitonAnimationTypeMoveIn, //新视图移到旧视图上面
    ZHTransitonAnimationTypeReveal, //将旧视图移开,显示下面的新视图
    ZHTransitonAnimationTypeCube, //立方体翻滚效果
    ZHTransitonAnimationTypeOglFlip, //上下左右翻转效果
    ZHTransitonAnimationTypeSuckEffect, //收缩效果，如一块布被抽走(不支持过渡方向)
    ZHTransitonAnimationTypeRippleEffect, //滴水效果(不支持过渡方向)
    ZHTransitonAnimationTypePageCurl, //向上翻页效果
    ZHTransitonAnimationTypePageUnCurl, //向下翻页效果
    ZHTransitonAnimationTypeCameraIrisHollowOpen, //相机镜头打开效果(不支持过渡方向)
    ZHTransitonAnimationTypeCameraIrisHollowClose, //相机镜头关上效果(不支持过渡方向)
};

typedef NS_ENUM(NSUInteger, ZHTransitonAnimationDirection) {
    ZHTransitonAnimationDirectionTop,
    ZHTransitonAnimationDirectionBottom,
    ZHTransitonAnimationDirectionLeft,
    ZHTransitonAnimationDirectionRight,
    ZHTransitonAnimationDirectionNone,
};

@interface UIView (MethodExtend)
/**
 控件顶部,即y坐标
 */
@property (nonatomic, assign) CGFloat top;

/**
 控件底部,即y坐标+高
 */
@property (nonatomic, assign) CGFloat bottom;

/**
 控件左侧,即x坐标
 */
@property (nonatomic, assign) CGFloat left;

/**
 控件右侧,即x坐标+宽
 */
@property (nonatomic, assign) CGFloat right;

/**
 控件Center X
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 控件Center Y
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 控件(x, y)
 */
@property (nonatomic, assign) CGPoint origin;

/**
 控件(width, height)
 */
@property (nonatomic, assign) CGSize size;

/**
 控件宽
 */
@property (nonatomic, assign) CGFloat width;

/**
 控件高
 */
@property (nonatomic, assign) CGFloat height;


/**
 设置某一方向圆角
 
 @param radius 角度
 @param corners 方向
 */
- (void)setCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners;


/**
 添加点击手势
 
 @param action 手势活动
 */
- (void)addTapGestureRecognizerrWithActionHandler:(void(^)(id tapView))action;


/**
 页面跳转动画
 
 @param duration 动画周期
 @param type 动画方式
 @param direction 方向
 */
- (void)transitionAnimationWithDuration:(NSTimeInterval)duration animationType:(ZHTransitonAnimationType)type transitionDirection:(ZHTransitonAnimationDirection)direction;
@end

