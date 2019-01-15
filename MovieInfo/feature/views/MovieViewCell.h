//
//  MovieViewCell.h
//  MovieInfo
//
//  Created by zach on 2018/10/16.
//  Copyright © 2018年 zach. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MovieViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *director;
@property (weak, nonatomic) IBOutlet UILabel *cast;
@property (weak, nonatomic) IBOutlet UILabel *want;
@property (weak, nonatomic) IBOutlet UIView *view;
- (void)configCell:(id)model kind:(NSInteger)kind;
@end

