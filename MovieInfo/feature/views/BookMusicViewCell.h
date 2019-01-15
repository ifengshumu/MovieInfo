//
//  BookMusicViewCell.h
//  MovieInfo
//
//  Created by 李志华 on 2018/10/22.
//  Copyright © 2018年 zachariahlee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseModel.h"

@interface BookMusicViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *second;
@property (weak, nonatomic) IBOutlet UILabel *three;
- (void)configCell:(MusicBook *)model;
@end

