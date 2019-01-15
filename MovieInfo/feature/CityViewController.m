//
//  CityViewController.m
//  MovieInfo
//
//  Created by 李志华 on 2018/10/22.
//  Copyright © 2018年 zachariahlee. All rights reserved.
//

#import "CityViewController.h"
#import "ResponseModel.h"

@interface CityViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *av;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *sortKeys;
@property (nonatomic, strong) NSMutableDictionary *dataSource;
@property (nonatomic, assign) NSInteger start;
@end

static NSString * const identifier = @"cell";
static NSString * const identifierH = @"cell";
@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择城市";
    self.datas = [NSMutableArray arrayWithCapacity:0];
    self.dataSource = [NSMutableDictionary dictionaryWithCapacity:0];
    self.sortKeys = [NSMutableArray arrayWithCapacity:0];
    [self layoutTableView];
    [self requestData];
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
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:identifierH];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)requestData {
    if (!self.av) {
        UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        av.color = THEME_COLOR;
        av.center = self.view.center;
        [av startAnimating];
        [self.view addSubview:av];
        self.av = av;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"https://api.douban.com/v2/loc/list?apikey=0b2bdeda43b5688921839c8ecb20399b&start=%ld&count=100", self.start] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err = nil;
        ResponseModel *model = [[ResponseModel alloc] initWithDictionary:responseObject error:&err];
        __block typeof(self)weakSelf = self;
        if (model.count+model.start<model.total) {
            [weakSelf.datas addObjectsFromArray:model.locs];
            weakSelf.start = model.start+100;
            [weakSelf requestData];
        } else {
            [self reload];
            [self.av stopAnimating];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)reload {
    [self.datas enumerateObjectsUsingBlock:^(Location *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *regex = @"[\u4e00-\u9fa5]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:obj.name]) {
            NSString *key = [[obj.uid substringToIndex:1] uppercaseString];
            if (![key isEqualToString:@"1"]) {
                if ([self.sortKeys containsObject:key]) {
                    NSMutableArray *data = self.dataSource[key];
                    [data addObject:obj];
                } else {
                    NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
                    [data addObject:obj];
                    self.dataSource[key] = data;
                    [self.sortKeys addObject:key];
                }
            }
        }
    }];
    self.sortKeys = [self.sortKeys sortedArrayUsingSelector:@selector(compare:)].mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortKeys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[self.sortKeys[section]] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    Location *loc = self.dataSource[self.sortKeys[indexPath.section]][indexPath.row];
    cell.textLabel.text = loc.name;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *h = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierH];
    h.textLabel.text = self.sortKeys[section];
    h.textLabel.font = [UIFont boldSystemFontOfSize:20];
    return h;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Location *loc = self.dataSource[self.sortKeys[indexPath.section]][indexPath.row];
    if (self.chooseCity) {
        self.chooseCity(loc.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
