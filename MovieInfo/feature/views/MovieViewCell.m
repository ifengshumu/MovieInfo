//
//  MovieViewCell.m
//  MovieInfo
//
//  Created by zach on 2018/10/16.
//  Copyright © 2018年 zach. All rights reserved.
//

#import "MovieViewCell.h"
#import "ResponseModel.h"

@implementation MovieViewCell

- (void)configCell:(id)m kind:(NSInteger)kind{
    if (kind == 1) {
        Movie *model = (Movie *)m;
        self.title.text = model.title;
        [self.photo setImageWithURL:[NSURL URLWithString:model.images.medium] placeholderImage:[UIImage imageNamed:@"info"]];
        __block NSMutableArray *director = @[].mutableCopy;
        [model.directors enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [director addObject:obj.name];
        }];
        self.director.text = [@"导演：" stringByAppendingString:[director componentsJoinedByString:@"/"]];
        [director removeAllObjects];
        [model.casts enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [director addObject:obj.name];
        }];
        self.cast.text = [@"演员：" stringByAppendingString:[director componentsJoinedByString:@"/"]];
        self.want.text = [model.collect_count stringByAppendingString:@"人想看"];
    } else {
        if ([m isKindOfClass:[MusicBook class]]) {
            MusicBook *model = (MusicBook *)m;
            self.title.text = model.title;
            [self.photo setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"info"]];
            __block NSMutableArray *author = @[].mutableCopy;
            [model.author enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [author addObject:obj.name];
            }];
            NSString *auth = model.price?@"作者：":@"演唱者：";
            NSString *name = author.count?[author componentsJoinedByString:@"/"]:@"未知";
            self.director.text = [auth stringByAppendingString:name];
            
            if (model.publisher) {
                self.cast.text = [@"出版社：" stringByAppendingString:model.publisher.length?model.publisher:@"未知"];
            } else {
                [author removeAllObjects];
                [model.tags enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [author addObject:obj.name];
                }];
                self.cast.text = [@"标签：" stringByAppendingString:[author componentsJoinedByString:@"/"]];
            }
        } else {
            Movie *model = (Movie *)m;
            self.title.text = model.title;
            [self.photo setImageWithURL:[NSURL URLWithString:model.images.medium] placeholderImage:[UIImage imageNamed:@"info"]];
            self.director.text = [NSString stringWithFormat:@"评分：%.1f", model.rating.average.floatValue];
            __block NSMutableArray *director = @[].mutableCopy;
            [model.directors enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [director addObject:obj.name];
            }];
            self.cast.text = [@"导演：" stringByAppendingString:[director componentsJoinedByString:@"/"]];
            [director removeAllObjects];
            [model.casts enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [director addObject:obj.name];
            }];
            self.want.text = [@"演员：" stringByAppendingString:[director componentsJoinedByString:@"/"]];
        }

        self.view.layer.borderWidth = 1;
        self.view.layer.borderColor = THEME_COLOR.CGColor;
        self.view.layer.cornerRadius = 5;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
