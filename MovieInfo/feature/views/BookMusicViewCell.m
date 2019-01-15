//
//  BookMusicViewCell.m
//  MovieInfo
//
//  Created by 李志华 on 2018/10/22.
//  Copyright © 2018年 zachariahlee. All rights reserved.
//

#import "BookMusicViewCell.h"

@implementation BookMusicViewCell

- (void)configCell:(MusicBook *)model {
    [self.photo setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"info"]];
    self.title.text = model.title;
    __block NSMutableArray *author = @[].mutableCopy;
    [model.author enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [author addObject:obj.name];
    }];
    NSString *auth = model.price?@"作者：":@"演唱者：";
    NSString *name = author.count?[author componentsJoinedByString:@"/"]:@"未知";
    self.second.text = [auth stringByAppendingString:name];
    
    if (model.publisher) {
        self.three.text = [@"出版社：" stringByAppendingString:model.publisher.length?model.publisher:@"未知"];
    } else {
        [author removeAllObjects];
        [model.tags enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [author addObject:obj.name];
        }];
        self.three.text = [@"标签：" stringByAppendingString:[author componentsJoinedByString:@"/"]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
