//
//  AppConfig.h
//  MovieInfo
//
//  Created by zach on 2018/10/16.
//  Copyright © 2018年 zach. All rights reserved.


#import <UIKit/UIKit.h>

#define kSuitScreenHeight    suitScreenHeight()
#define kTabbarSpace         tabbarSpace()
#define kTabbarHeight        tabbarHeight()
#define kStatusHeight        statusHeight()
#define kNaviHeight          naviHeight()
#define kTopBarHeight        topBarHeight()
#define kSuitHeight          suitHeight()

#define THEME_COLOR             [UIColor colorWithHexString:@"#1296db"]


@interface AppConfig : NSObject

//状态栏适配
BOOL isIPhoneX();
CGFloat suitScreenHeight(); //屏幕高度-tabbar显示距离底部间距
CGFloat tabbarSpace();      //tabbar显示距离底部间距
CGFloat tabbarHeight();     //tabbar显示高度
CGFloat statusHeight();     //状态栏高度
CGFloat naviHeight();       //导航栏高度
CGFloat topBarHeight();     //导航栏+状态栏高度
CGFloat suitHeight();       //SuitScreenHeight-topBarHeight

@end
