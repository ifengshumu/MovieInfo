//
//  AppConfig.m
//  AKCar
//
//  Created by zach on 2018/10/16.
//  Copyright © 2018年 zach. All rights reserved.
//

#import "AppConfig.h"

@interface AppConfig()

@end

@implementation AppConfig

//状态栏适配
BOOL isIPhoneX() {
    if ([UIScreen mainScreen].bounds.size.height > 800) {
        return YES;
    }
    return NO;
}
CGFloat suitScreenHeight() {
    CGFloat h = UIScreen.mainScreen.bounds.size.height;
    return isIPhoneX() ? h-tabbarSpace() : h;
}
CGFloat tabbarSpace() {
    return isIPhoneX() ? 34 : 0;
}
CGFloat tabbarHeight() {
    return 49;
}
CGFloat statusHeight() {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return rectStatus.size.height;
}
CGFloat naviHeight() {
    return 44;
}
CGFloat topBarHeight() {
    return naviHeight()+statusHeight();
}
CGFloat suitHeight() {
    return kSuitScreenHeight-topBarHeight();
}

@end
