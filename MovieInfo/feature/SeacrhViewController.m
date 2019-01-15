//
//  SeacrhViewController.m
//  MovieInfo
//
//  Created by 李志华 on 2018/10/19.
//  Copyright © 2018年 zachariahlee. All rights reserved.
//

#import "SeacrhViewController.h"
#import "MovieViewCell.h"
#import "ResponseModel.h"
#import "DetailViewController.h"
#import "MusicBookDetailController.h"

static NSString * const identifier = @"cell";
@interface SeacrhViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSArray *types;
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation SeacrhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutSearchBar];
    [self layoutTableView];
}
#pragma mark - layout
- (void)layoutSearchBar {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusHeight, SCREEN_WIDTH, 65)];
    self.headerView = header;
    header.backgroundColor = self.navigationController.navigationBar.barTintColor;
    [self.view addSubview:header];
    
    
    self.types = @[@"movie",@"music",@"book"];
    self.kind = @"movie";
    NSArray *kind = @[@"电影", @"音乐",@"图书"];
    [kind enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [header addSubview:btn];
        btn.tag = idx+1000;
        btn.frame = CGRectMake(50*idx, 5, 50, 20);
        if (idx == 0) {
            btn.selected = YES;
            self.selectBtn = btn;
        }
        [btn addTarget:self action:@selector(selectKind:) forControlEvents:UIControlEventTouchUpInside];
    }];

    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 30, header.width-15, 30)];
    self.searchBar = search;
    [header addSubview:search];
    search.delegate = self;
    search.placeholder = @"搜索";
    search.backgroundImage = [[UIImage alloc] init];
    UITextField *tf = [search valueForKey:@"_searchField"];
    tf.layer.masksToBounds = YES;
    tf.layer.cornerRadius = 5;
    tf.layer.borderWidth = 0.5;
    tf.layer.borderColor = [UIColor colorWithHexString:@"#d6d6d6"].CGColor;
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, search.bottom+4.5, header.width, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [header addSubview:line];
    
}
- (void)selectKind:(UIButton *)sender {
    if (self.selectBtn != sender) {
        self.selectBtn.selected = NO;
        self.selectBtn = sender;
        self.kind = self.types[sender.tag-1000];
        [self.tableView triggerPullToRefresh];
    }
    self.selectBtn.selected = YES;
}
- (void)layoutTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, SCREEN_WIDTH, kSuitHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 115;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [tableView registerNib:[UINib nibWithNibName:@"MovieViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView addPullToRefreshWithActionHandler:^{
        [self requestData];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchText = searchBar.text;
    [searchBar endEditing:YES];
    [self requestData];
}
- (void)requestData {
    UIActivityIndicatorView *av = nil;
    if (!self.dataSource.count) {
        av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        av.color = THEME_COLOR;
        av.center = self.view.center;
        [av startAnimating];
        [self.view addSubview:av];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.douban.com/v2/%@/search?q=%@&apikey=0b2bdeda43b5688921839c8ecb20399b&start=0&count=10",self.kind, self.searchText];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResponseModel *model = [[ResponseModel alloc] initWithDictionary:responseObject error:nil];
        if ([self.kind isEqualToString:@"movie"]) {
            self.dataSource = model.subjects;
        } else if ([self.kind isEqualToString:@"music"]) {
            self.dataSource = model.musics;
        } else {
            self.dataSource = model.books;
        }
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
        self.start = model.start;
        [av stopAnimating];
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
    NSString *url = [NSString stringWithFormat:@"https://api.douban.com/v2/%@/search?q=%@&apikey=0b2bdeda43b5688921839c8ecb20399b&start=%ld&count=10",self.kind, self.searchText, self.start+10];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResponseModel *model = [[ResponseModel alloc] initWithDictionary:responseObject error:nil];
        if ([self.kind isEqualToString:@"movie"]) {
            [self.dataSource addObjectsFromArray:model.subjects];
        } else if ([self.kind isEqualToString:@"music"]) {
            [self.dataSource addObjectsFromArray:model.musics];
        } else {
            [self.dataSource addObjectsFromArray:model.books];
        }
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
        self.start = model.start;
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
    [cell configCell:self.dataSource[indexPath.row] kind:2];
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
    if ([self.kind isEqualToString:@"movie"]) {
        Movie *model = self.dataSource[indexPath.row];
        DetailViewController *vc = [[DetailViewController alloc] init];
        vc.ID = model.id;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else {
        MusicBookDetailController *vc = [[MusicBookDetailController alloc] init];
        vc.kind = self.kind;
        vc.model = self.dataSource[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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
