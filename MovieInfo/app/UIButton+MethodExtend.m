//
//  UIButton+MethodExtend.m
//  ZHUIKit
//
//  Created by 李志华 on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "UIButton+MethodExtend.h"
#import <objc/runtime.h>

@implementation UIButton (MethodExtend)

- (void)setUserInfo:(NSDictionary *)userInfo {
    objc_setAssociatedObject(self, @selector(userInfo), userInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSDictionary *)userInfo {
    return objc_getAssociatedObject(self, _cmd);
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)aTitle titleColor:(UIColor *)aColor titleFont:(UIFont *)aFont image:(UIImage *)aImage {
    return [UIButton buttonWithFrame:frame title:aTitle titleColor:aColor titleFont:aFont image:aImage actionHandler:nil];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)aTitle titleColor:(UIColor *)aColor titleFont:(UIFont *)aFont image:(UIImage *)aImage actionHandler:(void(^)(UIButton *sedner))action {
    if (!aTitle && !aImage) {
        NSAssert(aTitle && aImage, @"图标和标题必须传入一个");
        return nil;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (aTitle) {
        [button setTitle:aTitle forState:UIControlStateNormal];
        if (aColor) {
            [button setTitleColor:aColor forState:UIControlStateNormal];
        }
        if (aFont) {
            button.titleLabel.font = aFont;
        }
    }
    if (aImage) {
        [button setImage:aImage forState:UIControlStateNormal];
    }
    if (action) {
        [button addActionHandler:action];
    }
    return button;
}

- (void)addActionHandler:(void (^)(UIButton *))action {
    self.userInfo = @{@"action":action};
    [self addTarget:self action:@selector(actionHandler:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionHandler:(UIButton *)sender {
    void(^buttonActionHandler)(UIButton *) = sender.userInfo[@"action"];
    buttonActionHandler(sender);
}

- (void)setImageTextAlignmentStyle:(UIButtonImageTextAlignmentStyle)style  space:(CGFloat)space {
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat imageHeight = self.imageView.bounds.size.height;
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    CGFloat labelHeight = self.titleLabel.bounds.size.height;
    space = space / 2.0;
    
    /*
     top : 为正数的时候,是往下偏移,为负数的时候往上偏移;
     
     left : 为正数的时候往右偏移,为负数的时候往左偏移;
     
     bottom : 为正数的时候往上偏移,为负数的时候往下偏移;
     
     right :为正数的时候往左偏移,为负数的时候往右偏移;
     */
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
    if (style == UIButtonImageTextAlignmentStyleDefault) {
        //左图右文
        imageEdgeInsets = UIEdgeInsetsMake(0, -space, 0, space);
        titleEdgeInsets = UIEdgeInsetsMake(0, space, 0, -space);
    } else if (style == UIButtonImageTextAlignmentStyleReverse) {
        //左文右图
        titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth+space), 0, imageWidth+space);
        imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space, 0, -(labelWidth+space));
    } else if (style == UIButtonImageTextAlignmentStyleRotateCW) {
        //上图下文
        imageEdgeInsets = UIEdgeInsetsMake(-(labelHeight+space), 0, 0, -labelWidth);
        titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -(imageHeight+space), 0);
    } else {
        //上文下图
        titleEdgeInsets = UIEdgeInsetsMake(-(imageHeight+space), -imageWidth, 0, 0);
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, -(labelHeight+space), -labelWidth);
    }
    self.titleEdgeInsets = titleEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

- (void)countdownWithDuration:(NSUInteger)dutation endButtonTitle:(NSString *)title remainingTime:(void(^)(NSUInteger time))remainingTime {
    __block NSUInteger timeOut = dutation;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeOut <= 0) {
            //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //计时结束时的按钮显示
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        } else {
            //剩余时间（秒）
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时过程中的按钮显示
                self.userInteractionEnabled = NO;
                if (remainingTime) {
                    remainingTime(timeOut);
                }
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
