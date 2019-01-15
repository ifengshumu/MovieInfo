//
//  CityViewController.h
//  MovieInfo
//
//  Created by 李志华 on 2018/10/22.
//  Copyright © 2018年 zachariahlee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CityViewController : UIViewController
@property (nonatomic, copy) void(^chooseCity)(NSString *city);
@end

NS_ASSUME_NONNULL_END
