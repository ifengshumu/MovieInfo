//
//  MusicViewController.m
//  MovieInfo
//
//  Created by 李志华 on 2018/10/22.
//  Copyright © 2018年 zachariahlee. All rights reserved.
//

#import "MusicViewController.h"
#import "BookMusicViewCell.h"
#import "ResponseModel.h"
#import "MusicBookDetailController.h"

@interface MusicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger start;
@end

static NSString * const identifier = @"cell";
static NSString * const identifierFoot = @"foot";
@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"音乐";
    self.kind = @"music";
    [self layoutCollectionView];
}
#pragma mark - layout
- (void)layoutCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2.0, 300);
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSuitHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookMusicViewCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifierFoot];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView addPullToRefreshWithActionHandler:^{
        [self requestData];
    }];
    [collectionView triggerPullToRefresh];
}

- (void)requestData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"https://api.douban.com/v2/%@/search?q=all&apikey=0b2bdeda43b5688921839c8ecb20399b&start=0&count=10", self.kind] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResponseModel *model = [[ResponseModel alloc] initWithDictionary:responseObject error:nil];
        if ([self.kind isEqualToString:@"music"]) {
            self.dataSource = model.musics;
        } else {
            self.dataSource = model.books;
        }
        [self.collectionView reloadData];
        [self.collectionView.pullToRefreshView stopAnimating];
        self.start = model.start;
        __block typeof(self)weakSelf = self;
        if (model.count+model.start<model.total) {
            [self.collectionView addInfiniteScrollingWithActionHandler:^{
                [weakSelf loadMore];
            }];
            self.collectionView.showsInfiniteScrolling = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}
- (void)loadMore {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"https://api.douban.com/v2/%@/search?q=all&apikey=0b2bdeda43b5688921839c8ecb20399b&start=%ld&count=10", self.kind, self.start+10] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResponseModel *model = [[ResponseModel alloc] initWithDictionary:responseObject error:nil];
        if ([self.kind isEqualToString:@"music"]) {
            [self.dataSource addObjectsFromArray:model.musics];
        } else {
            [self.dataSource addObjectsFromArray:model.books];
        }
        [self.collectionView reloadData];
        [self.collectionView.infiniteScrollingView stopAnimating];
        if (model.count+model.start>model.total) {
            self.collectionView.showsInfiniteScrolling = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookMusicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell configCell:self.dataSource[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MusicBookDetailController *vc = [[MusicBookDetailController alloc] init];
    vc.kind = self.kind;
    vc.model = self.dataSource[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
