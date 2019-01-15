//
//  UIView+MethodExtend.m
//  ZHUIKit
//
//  Created by 李志华 on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "UIView+MethodExtend.h"
#import <objc/runtime.h>

@interface UIView ()
@property (nonatomic, copy) void(^tapAction)(UIView *tapView);
@end

@implementation UIView (MethodExtend)

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right {
    CGFloat delta = right - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, self.frame.size.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addTapGestureRecognizerrWithActionHandler:(void(^)(id tapView))action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelAction:)];
    tap.numberOfTapsRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    self.tapAction = action;
}
- (void)handelAction:(UITapGestureRecognizer *)sender {
    if (self.tapAction) {
        self.tapAction(sender.view);
    }
}
- (void)setTapAction:(void (^)(UIView *))tapAction {
    objc_setAssociatedObject(self, @selector(tapAction), tapAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIView *))tapAction {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIViewController *)supViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)transitionAnimationWithDuration:(NSTimeInterval)duration animationType:(ZHTransitonAnimationType)type transitionDirection:(ZHTransitonAnimationDirection)direction {
    NSString *directionString = nil;
    switch (direction) {
        case ZHTransitonAnimationDirectionTop: {
            directionString = kCATransitionFromTop;
        }
            break;
        case ZHTransitonAnimationDirectionBottom: {
            directionString = kCATransitionFromBottom;
        }
            break;
        case ZHTransitonAnimationDirectionLeft: {
            directionString = kCATransitionFromLeft;
        }
            break;
        case ZHTransitonAnimationDirectionRight: {
            directionString = kCATransitionFromRight;
        }
            break;
        default: {
            
        }
            break;
    }
    NSString *typeString = nil;
    switch (type) {
        case ZHTransitonAnimationTypeFade: {//不支持过渡方向
            typeString = kCATransitionFade;
        }
            break;
        case ZHTransitonAnimationTypePush: {
            typeString = kCATransitionPush;
        }
            break;
        case ZHTransitonAnimationTypeMoveIn: {
            typeString = kCATransitionMoveIn;
        }
            break;
        case ZHTransitonAnimationTypeReveal: {
            typeString = kCATransitionReveal;
        }
            break;
        case ZHTransitonAnimationTypeCube: {
            typeString = @"cube";
        }
            break;
        case ZHTransitonAnimationTypeOglFlip: {
            typeString = @"oglFlip";
        }
            break;
        case ZHTransitonAnimationTypeSuckEffect: {//不支持过渡方向
            typeString = @"suckEffect";
            directionString = nil;
        }
            break;
        case ZHTransitonAnimationTypeRippleEffect: {//不支持过渡方向
            typeString = @"rippleEffect";
            directionString = nil;
        }
            break;
        case ZHTransitonAnimationTypePageCurl: {
            typeString = @"PageCurl";
        }
            break;
        case ZHTransitonAnimationTypePageUnCurl: {
            typeString = @"PageUnCurl";
        }
            break;
        case ZHTransitonAnimationTypeCameraIrisHollowOpen: {//不支持过渡方向
            typeString = @"cameraIrisHollowOpen";
        }
            break;
        case ZHTransitonAnimationTypeCameraIrisHollowClose: {//不支持过渡方向
            typeString = @"cameraIrisHollowClose";
        }
            break;
    }
    [self transitionWithDuration:duration animationType:typeString transitionDirection:directionString];
}


- (void)transitionWithDuration:(NSTimeInterval)duration animationType:(NSString *)type transitionDirection:(NSString *)direction {
    
    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.type = type; //过度效果
    if (direction != nil) {
        animation.subtype = direction; //过渡方向
    }
    animation.startProgress = 0.0; //动画开始起点(在整体动画的百分比)
    animation.endProgress = 1.0; //动画停止终点(在整体动画的百分比)
    [self.layer addAnimation:animation forKey:@"transitionAnimation"];
}
@end
