//
//  MusicBookDetailController.h
//  MovieInfo
//
//  Created by 李志华 on 2018/10/22.
//  Copyright © 2018年 zachariahlee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseModel.h"

@interface MusicBookDetailController : UIViewController
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, strong) MusicBook *model;
@end

