//
//  MITabBarController.m
//  MovieInfo
//
//  Created by zach on 2018/10/16.
//  Copyright © 2018年 zach. All rights reserved.
//

#import "MITabBarController.h"

@interface MITabBarController ()<UITabBarControllerDelegate>

@end

@implementation MITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabBar];
}

- (void)setupTabBar {
    UITabBar *tabBar = self.tabBar;
    self.delegate = self;
    NSArray *titles = @[@"电影",@"音乐",@"图书",@"搜索"];
    NSArray *images = @[@"tab_11",@"tab_21",@"tab_31",@"tab_41"];
    NSArray *selectedImages = @[@"tab_1",@"tab_2",@"tab_3",@"tab_4"];
    [tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#555555"],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:THEME_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateHighlighted];
        item.tag = idx;
        item.title = titles[idx];
        item.image = [[UIImage imageNamed:images[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:selectedImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
}


@end
