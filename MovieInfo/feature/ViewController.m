//
//  ViewController.m
//  MovieInfo
//
//  Created by zach on 2018/10/16.
//  Copyright © 2018年 zach. All rights reserved.
//


#import "ViewController.h"
#import "MovieViewCell.h"
#import "ResponseModel.h"
#import "DetailViewController.h"
#import "CityViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSArray *types;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) UIButton *barBtn;
@property (nonatomic, strong) NSMutableArray *scrollData;
@end

static NSString * const identifier = @"cell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"电影";
    self.kind = @"in_theaters";
    [self layoutNavLeft];
    [self layoutTableView];
}
#pragma mark - layout
- (void)layoutNavLeft {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.barBtn = btn;
    btn.frame = CGRectMake(0, 0, 80, kNaviHeight);
    [btn setTitle:@"全国" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [btn setImageTextAlignmentStyle:UIButtonImageTextAlignmentStyleReverse space:0];
    [btn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flex.width = -15;
    self.navigationItem.leftBarButtonItems = @[flex, item];
}
- (void)chooseCity {
    CityViewController *vc = [[CityViewController alloc] init];
    vc.chooseCity = ^(NSString * _Nonnull city) {
        [self.barBtn setTitle:city forState:UIControlStateNormal];
        self.city = city;
        [self.tableView triggerPullToRefresh];
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)layoutTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSuitHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorColor = THEME_COLOR;
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 115;
    [tableView registerNib:[UINib nibWithNibName:@"MovieViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView addPullToRefreshWithActionHandler:^{
        [self requestData];
    }];
    [tableView triggerPullToRefresh];
}
- (void)layoutHeaderView {
    if (!self.tableView.tableHeaderView) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 340)];
        self.tableView.tableHeaderView = header;
        
        SDCycleScrollView *sc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, header.width, 300) delegate:self placeholderImage:[UIImage imageNamed:@"info"]];
        [header addSubview:sc];
        self.scrollData = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *imags = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *datas = self.dataSource.mutableCopy;
        while (imags.count < 5) {
            Movie *m = datas[arc4random()%datas.count];
            [imags addObject:m.images.large];
            [datas removeObject:m];
            [self.scrollData addObject:m];
        }
        sc.imageURLStringsGroup = imags.copy;
        
        NSArray *kinds = @[@"正在热映", @"即将上映",@"经典榜",@"新片榜"];
         self.types = @[@"in_theaters", @"coming_soon", @"top250", @"new_movies"];
        [kinds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:obj forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
            [header addSubview:btn];
            btn.tag = idx+1000;
            btn.frame = CGRectMake(header.width/kinds.count*idx, sc.bottom, header.width/kinds.count, 40);
            if (idx == 0) {
                btn.selected = YES;
                self.selectBtn = btn;
            }
            [btn addTarget:self action:@selector(selectKind:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    Movie *model = self.scrollData[index];
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.ID = model.id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)selectKind:(UIButton *)sender {
    if (self.selectBtn != sender) {
        self.selectBtn.selected = NO;
        self.selectBtn = sender;
        self.kind = self.types[sender.tag-1000];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.tableView triggerPullToRefresh];
    }
    self.selectBtn.selected = YES;
}
- (void)requestData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.douban.com/v2/movie/%@?city=%@&apikey=0b2bdeda43b5688921839c8ecb20399b&start=0&count=10", self.kind,self.city];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResponseModel *model = [[ResponseModel alloc] initWithDictionary:responseObject error:nil];
        self.dataSource = model.subjects;
        [self layoutHeaderView];
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
        self.start = model.start;
        __block typeof(self)weakSelf = self;
        if (model.count+model.start<model.total) {
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                [weakSelf loadMore];
            }];
            self.tableView.showsInfiniteScrolling = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}
- (void)loadMore {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"https://api.douban.com/v2/movie/%@?apikey=0b2bdeda43b5688921839c8ecb20399b&start=%ld&count=10", self.kind, self.start+10] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResponseModel *model = [[ResponseModel alloc] initWithDictionary:responseObject error:nil];
        [self.dataSource addObjectsFromArray:model.subjects];
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
        if (model.count+model.start>model.total) {
            self.tableView.showsInfiniteScrolling = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell configCell:self.dataSource[indexPath.row] kind:1];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Movie *model = self.dataSource[indexPath.row];
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.ID = model.id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
