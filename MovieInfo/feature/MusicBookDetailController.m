//
//  MusicBookDetailController.m
//  MovieInfo
//
//  Created by 李志华 on 2018/10/22.
//  Copyright © 2018年 zachariahlee. All rights reserved.
//

#import "MusicBookDetailController.h"

@interface MusicBookDetailController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MusicBookDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.model.title;
    [self layout];
}

- (void)layout {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSuitScreenHeight-kStatusHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [self headerView];
}

- (void)headerView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.tableHeaderView = header;
    
    MusicBook *model = self.model;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, header.width, 405)];
    [header addSubview:imageView];
    NSString *url = [self.kind isEqualToString:@"music"]?model.image:model.images.large;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, imageView.bottom+10, header.width, 15)];
    title.font = [UIFont boldSystemFontOfSize:20];
    __block NSMutableArray *author = @[].mutableCopy;
    [model.author enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [author addObject:obj.name];
    }];
    NSString *auth = model.price?@"作者：":@"演唱者：";
    NSString *name = author.count?[author componentsJoinedByString:@"/"]:@"未知";
    title.text = [auth stringByAppendingString:name];
    [header addSubview:title];
    
    NSDictionary *attrs = model.attrs;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, title.bottom+10, header.width, 15)];
    label.textColor = [UIColor grayColor];
    if ([self.kind isEqualToString:@"music"]) {
        NSArray *media =  attrs[@"media"];
        label.text = [NSString stringWithFormat:@"介质：%@",media.count?[media componentsJoinedByString:@"/"]:@"无"];
    } else {
        label.text = [NSString stringWithFormat:@"原作名：%@", model.origin_title.length?model.origin_title:@"无"];
    }
    [header addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, label.bottom+10, header.width, 15)];
    label1.textColor = [UIColor grayColor];
    if ([self.kind isEqualToString:@"music"]) {
        NSArray *version =  attrs[@"version"];
        label1.text = [NSString stringWithFormat:@"专辑类型：%@",version.count?[version componentsJoinedByString:@"/"]:@"无"];
    } else {
        label1.text = [@"译者：" stringByAppendingString:model.translator.count?[model.translator componentsJoinedByString:@"/"]:@"无"];
    }
    [header addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, label1.bottom+10, header.width, 15)];
    label2.textColor = [UIColor grayColor];
    if ([self.kind isEqualToString:@"music"]) {
        NSArray *publisher =  attrs[@"publisher"];
        label2.text = [NSString stringWithFormat:@"发行者：%@",publisher.count?[publisher componentsJoinedByString:@"/"]:@"无"];
    } else {
        label2.text = [@"出版社：" stringByAppendingString:model.publisher.length?model.publisher:@"未知"];
    }
    [header addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, label2.bottom+10, header.width, 15)];
    label3.textColor = [UIColor grayColor];
    if ([self.kind isEqualToString:@"music"]) {
        NSArray *pubdate =  attrs[@"pubdate"];
        label3.text = [NSString stringWithFormat:@"发行日期：%@",pubdate.count?[pubdate componentsJoinedByString:@"/"]:@"无"];
    } else {
        label3.text = [@"出版日期：" stringByAppendingString:model.pubdate.length?model.pubdate:@"未知"];
    }
    [header addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, label3.bottom+10, header.width, 15)];
    label4.textColor = [UIColor grayColor];
    if ([self.kind isEqualToString:@"music"]) {
        NSArray *discs =  attrs[@"discs"];
        label4.text = [NSString stringWithFormat:@"唱片数：%@",discs.count?discs.firstObject:@"0"];
    } else {
        label4.text = [@"页数：" stringByAppendingString:model.pages];
    }
    [header addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(15, label4.bottom+10, header.width, 15)];
    label5.textColor = [UIColor grayColor];
    if ([self.kind isEqualToString:@"music"]) {
        label5.text = [NSString stringWithFormat:@"评分：%.1f", model.rating.average.floatValue];
    } else {
        label5.text = [@"价格：" stringByAppendingString:model.price.length?model.price:@"免费"];
    }
    [header addSubview:label5];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, label5.bottom+10, header.width, 1)];
    line.backgroundColor = THEME_COLOR;
    [header addSubview:line];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(15, line.bottom+20, header.width, 15)];
    label6.font = [UIFont boldSystemFontOfSize:20];
    label6.text = [self.kind isEqualToString:@"music"]?@"标签":@"作者简介";
    [header addSubview:label6];
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(15, label6.bottom+10, header.width-30, 15)];
    label7.textColor = [UIColor grayColor];;
    [header addSubview:label7];
    NSString *info1 = nil;
    if ([self.kind isEqualToString:@"music"]) {
        NSMutableArray *tags = [NSMutableArray arrayWithCapacity:0];
        [model.tags enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tags addObject:obj.name];
        }];
        info1 = tags.count?[tags componentsJoinedByString:@" / "]:nil;
    } else {
        info1 = model.author_intro;
    }
    if (info1.length) {
        CGFloat h = [info1 boundingRectWithSize:CGSizeMake(header.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        label7.height = h;
        label7.numberOfLines = 0;
        label7.text = info1;
    } else {
        label7.text = @"无";
    }
    
    
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(15, label7.bottom+20, header.width, 15)];
    label8.font = [UIFont boldSystemFontOfSize:20];
    label8.text = [self.kind isEqualToString:@"music"]?@"曲目":@"内容简介";
    [header addSubview:label8];
    
    UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(15, label8.bottom+10, header.width-30, 15)];
    label9.textColor = [UIColor grayColor];;
    [header addSubview:label9];
    NSString *info2 = nil;
    if ([self.kind isEqualToString:@"music"]) {
        NSArray *tracks = attrs[@"tracks"];
        info2 = tracks.count?[tracks componentsJoinedByString:@""]:nil;
    } else {
        info2 = model.summary;
    }
    if (info2.length) {
        CGFloat h = [info2 boundingRectWithSize:CGSizeMake(header.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        label9.height = h;
        label9.numberOfLines = 0;
        label9.text = info2;
    } else {
        label9.text = @"无";
    }
    
    
    header.height = label9.bottom+20;

    
    
//
//    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(15, label5.bottom+20, header.width, 15)];
//    label6.font = [UIFont boldSystemFontOfSize:20];
//    label6.text = @"演员";
//    [header addSubview:label6];
//    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(15, label6.bottom+10, header.width-30, 175)];
//    sv.contentSize = CGSizeMake(model.casts.count*100+(model.casts.count-1)*10, 175);
//    [header addSubview:sv];
//    self.images = [NSMutableArray arrayWithCapacity:0];
//    [model.casts enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((100+10)*idx, 0, 100, 150)];
//        imageView.tag = idx;
//        [sv addSubview:imageView];
//        if (obj.avatars) {
//            [self.images addObject:obj.avatars.large];
//        } else {
//            [self.images addObject:[UIImage imageNamed:@"info"]];
//        }
//        [imageView sd_setImageWithURL:[NSURL URLWithString:obj.avatars.small] placeholderImage:[UIImage imageNamed:@"info"]];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browerImage:)];
//        imageView.userInteractionEnabled = YES;
//        [imageView addGestureRecognizer:tap];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left, imageView.bottom+10, imageView.width, 15)];
//        label.font = [UIFont systemFontOfSize:12];
//        label.textColor = [UIColor grayColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = obj.name;
//        [sv addSubview:label];
//    }];
//
//    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(15, sv.bottom+20, header.width, 15)];
//    label7.font = [UIFont boldSystemFontOfSize:20];
//    label7.text = @"剧照";
//    [header addSubview:label7];
//    UIScrollView *sv1 = [[UIScrollView alloc] initWithFrame:CGRectMake(15, label7.bottom+10, header.width-30, 250)];
//    sv1.contentSize = CGSizeMake(model.photos.count*200+(model.photos.count-1)*10, 250);
//    [header addSubview:sv1];
//    self.photos = [NSMutableArray arrayWithCapacity:0];
//    [model.photos enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((200+10)*idx, 0, 200, 250)];
//        imageView.tag = idx;
//        [sv1 addSubview:imageView];
//        if (obj[@"image"]) {
//            [self.photos addObject:obj[@"image"]];
//        } else {
//            [self.photos addObject:[UIImage imageNamed:@"info"]];
//        }
//        [imageView sd_setImageWithURL:[NSURL URLWithString:obj[@"image"]] placeholderImage:[UIImage imageNamed:@"info"]];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browerPhoto:)];
//        imageView.userInteractionEnabled = YES;
//        [imageView addGestureRecognizer:tap];
//    }];
//
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
