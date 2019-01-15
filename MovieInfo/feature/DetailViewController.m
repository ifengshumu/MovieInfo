//
//  DetailViewController.m
//  MovieInfo
//
//  Created by 李志华 on 2018/10/18.
//  Copyright © 2018年 zachariahlee. All rights reserved.
//

#import "DetailViewController.h"
#import "ResponseModel.h"
#import "XLPhotoBrowser.h"

@interface DetailViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Movie *model;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"电影";
    [self requestData];
}

- (void)requestData {
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    av.color = THEME_COLOR;
    av.center = self.view.center;
    [av startAnimating];
    [self.view addSubview:av];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"https://api.douban.com/v2/movie/subject/%@", self.ID] parameters:@{@"apikey":@"0b2bdeda43b5688921839c8ecb20399b",@"client":@"something"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         Movie *model = [[Movie alloc] initWithData:responseObject error:nil];
        self.model = model;
        [self layout];
        [av stopAnimating];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
    
    Movie *model = self.model;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, header.width, 405)];
    [header addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.images.large]];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, imageView.bottom+10, header.width, 15)];
    title.font = [UIFont boldSystemFontOfSize:20];
    title.text = model.title;
    [header addSubview:title];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, title.bottom+10, header.width, 15)];
    label.textColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"评分：%.1f", model.rating.average.floatValue];
    [header addSubview:label];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, label.bottom+10, header.width, 15)];
    label1.textColor = [UIColor grayColor];
    label1.text = [[model.year stringByAppendingPathComponent:[model.countries componentsJoinedByString:@"/"]] stringByAppendingPathComponent:[model.genres componentsJoinedByString:@"/"]];
    [header addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, label1.bottom+10, header.width, 15)];
    label2.textColor = [UIColor grayColor];
    label2.text = [@"上映时间：" stringByAppendingString:model.pubdate];
    [header addSubview:label2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, label2.bottom+10, header.width, 15)];
    label3.textColor = [UIColor grayColor];
    label3.text = [@"片长：" stringByAppendingString:model.durations[0]];
    [header addSubview:label3];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, label3.bottom+10, header.width, 1)];
    line.backgroundColor = THEME_COLOR;
    [header addSubview:line];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, line.bottom+20, header.width, 15)];
    label4.font = [UIFont boldSystemFontOfSize:20];
    label4.text = @"剧情简介";
    [header addSubview:label4];
    CGFloat h = [model.summary boundingRectWithSize:CGSizeMake(header.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(15, label4.bottom+10, header.width-30, h)];
    label5.numberOfLines = 0;
    label5.textColor = [UIColor grayColor];;
    label5.text = model.summary;
    [header addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(15, label5.bottom+20, header.width, 15)];
    label6.font = [UIFont boldSystemFontOfSize:20];
    label6.text = @"演员";
    [header addSubview:label6];
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(15, label6.bottom+10, header.width-30, 175)];
    sv.contentSize = CGSizeMake(model.casts.count*100+(model.casts.count-1)*10, 175);
    [header addSubview:sv];
    self.images = [NSMutableArray arrayWithCapacity:0];
    [model.casts enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((100+10)*idx, 0, 100, 150)];
        imageView.tag = idx;
        [sv addSubview:imageView];
        if (obj.avatars) {
            [self.images addObject:obj.avatars.large];
        } else {
            [self.images addObject:[UIImage imageNamed:@"info"]];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj.avatars.small] placeholderImage:[UIImage imageNamed:@"info"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browerImage:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left, imageView.bottom+10, imageView.width, 15)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = obj.name;
        [sv addSubview:label];
    }];
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(15, sv.bottom+20, header.width, 15)];
    label7.font = [UIFont boldSystemFontOfSize:20];
    label7.text = @"剧照";
    [header addSubview:label7];
    UIScrollView *sv1 = [[UIScrollView alloc] initWithFrame:CGRectMake(15, label7.bottom+10, header.width-30, 250)];
    sv1.contentSize = CGSizeMake(model.photos.count*200+(model.photos.count-1)*10, 250);
    [header addSubview:sv1];
    self.photos = [NSMutableArray arrayWithCapacity:0];
    [model.photos enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((200+10)*idx, 0, 200, 250)];
        imageView.tag = idx;
        [sv1 addSubview:imageView];
        if (obj[@"image"]) {
            [self.photos addObject:obj[@"image"]];
        } else {
            [self.photos addObject:[UIImage imageNamed:@"info"]];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj[@"image"]] placeholderImage:[UIImage imageNamed:@"info"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browerPhoto:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }];
    
    
    header.height = sv1.bottom+10;
}
- (void)browerImage:(UITapGestureRecognizer *)tap {
    [XLPhotoBrowser showPhotoBrowserWithImages:self.images.copy currentImageIndex:tap.view.tag];
}
- (void)browerPhoto:(UITapGestureRecognizer *)tap {
    [XLPhotoBrowser showPhotoBrowserWithImages:self.photos.copy currentImageIndex:tap.view.tag];
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
