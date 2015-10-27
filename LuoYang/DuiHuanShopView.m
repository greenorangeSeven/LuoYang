//
//  DuiHuanShopView.m
//  LuoYangSQ
//
//  Created by Seven on 15/9/2.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "DuiHuanShopView.h"
#import "BusinessGoodCell.h"
#import "UIImageView+WebCache.h"
#import "DuiHuanDetailView.h"

@interface DuiHuanShopView ()

@end

@implementation DuiHuanShopView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = self.tjTitle;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.collectionView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[BusinessGoodCell class] forCellWithReuseIdentifier:BusinessGoodCellIdentifier];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.74 green:0.78 blue:0.81 alpha:1];
    [self reload];
}

- (void)viewDidUnload
{
    [self setCollectionView:nil];
    [goods removeAllObjects];
    goods = nil;
    [super viewDidUnload];
}

- (void)clear
{
    [goods removeAllObjects];
    isLoadOver = NO;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//取数方法
- (void)reload
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@/getDuihuanShop?APPKey=%@&catid=%@", api_base_url, appkey, self.tjCatId];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [self clear];
                                       @try {
                                           goods = [Tool readJsonStrToDuiHuanShopArray:operation.responseString];
                                           if (goods != nil) {
                                               [self.collectionView reloadData];
                                           }
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           [self doneLoadingTableViewData];
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [self doneLoadingTableViewData];
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.collectionView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.collectionView];
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self refresh];
}

// tableView添加拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning) {
        [self reload];
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [goods count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BusinessGoodCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BusinessGoodCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[BusinessGoodCell class]]) {
                cell = (BusinessGoodCell *)o;
                break;
            }
        }
    }
    
    DuiHuanShop *good = (DuiHuanShop *)[goods objectAtIndex:[indexPath row]];
    
    [cell.picIv sd_setImageWithURL:[NSURL URLWithString:good.thumb] placeholderImage:[UIImage imageNamed:@"loadpic2"]];
    cell.titleLb.text = good.title;
    if ([good.keys isEqualToString:@"0"]) {
        cell.priceLb.text = [NSString stringWithFormat:@"%@深盟券", good.duihuan_quan];
        cell.marketPriceLb.hidden = YES;
    }
    else if ([good.keys isEqualToString:@"1"]) {
        cell.marketPriceLb.hidden = NO;
        cell.priceLb.text = [NSString stringWithFormat:@"%@深盟券+", good.duihuan_quan02];
        cell.marketPriceLb.text = [NSString stringWithFormat:@"%@现金", good.duihuan_xianjin];
    }
    else if ([good.keys isEqualToString:@"2"]) {
        cell.priceLb.text = [NSString stringWithFormat:@"%@深盟券", good.duihuan_quan];
        cell.marketPriceLb.hidden = YES;
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 172);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DuiHuanShop *good = (DuiHuanShop *)[goods objectAtIndex:[indexPath row]];
    if (good) {
        DuiHuanDetailView *goodsDetail = [[DuiHuanDetailView alloc] init];
        goodsDetail.goodDetail = good;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
