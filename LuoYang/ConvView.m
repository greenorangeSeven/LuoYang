//
//  ConvView.m
//  BeautyLife
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ConvView.h"

@interface ConvView () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ConvView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"便民服务";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 63, 22)];
        [rBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"conv_search"] forState:UIControlStateNormal];
        UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnSearch;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAction
{
    if (myPoint.x > 0) {
        BusniessSearchView *searchView = [[BusniessSearchView alloc] init];
        searchView.myPoint = myPoint;
        searchView.viewType = @"conv";
        [self.navigationController pushViewController:searchView animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在定位" andView:self.view andHUD:hud];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [self startLocation];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    self.cateCollection.delegate = self;
    self.cateCollection.dataSource = self;
    [self.cateCollection registerClass:[BusinessCateCell class] forCellWithReuseIdentifier:BusinessCateCellIdentifier];
    self.cateCollection.backgroundColor = [UIColor clearColor];
    [self reloadCate];
    
    noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, 320, 44)];
    noDataLabel.font = [UIFont boldSystemFontOfSize:18];
    noDataLabel.text = @"暂无数据";
    noDataLabel.textColor = [UIColor blackColor];
    noDataLabel.backgroundColor = [UIColor clearColor];
    noDataLabel.textAlignment = UITextAlignmentCenter;
    noDataLabel.hidden = YES;
    [self.view addSubview:noDataLabel];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//数组排序
-(void)startArraySort:(NSString *)keystring isAscending:(BOOL)isAscending
{
    NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:keystring ascending:isAscending];
    shopData = [[NSMutableArray alloc]initWithArray:[shopData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByA]]];
}

//取数方法
- (void)reload
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableString *urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_lifelist, appkey];
        if (catid != nil && [catid intValue] > 0) {
            [urlTemp appendString:[NSString stringWithFormat:@"&catid=%@", catid]];
        }
        //        if (keyword != nil && [keyword length] > 0) {
        //            [urlTemp appendString:[NSString stringWithFormat:@"?name=%@", keyword]];
        //        }
        NSString *url = [[NSString stringWithString:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [shopData removeAllObjects];
                                       @try {
                                           [shopData removeAllObjects];
                                           noDataLabel.hidden = YES;
                                           shopData = [Tool readJsonStrToShopArray:operation.responseString];
                                           if (shopData != nil && [shopData count] > 0) {
                                               //计算当前位置与商家距离
                                               for (int i = 0; i < [shopData count]; i++) {
                                                   Shop *temp =[shopData objectAtIndex:(i)];
                                                   CLLocationCoordinate2D coor;
                                                   coor.longitude = [temp.longitude doubleValue];
                                                   coor.latitude = [temp.latitude doubleValue];
                                                   BMKMapPoint shopPoint = BMKMapPointForCoordinate(coor);
                                                   CLLocationDistance distanceTmp = BMKMetersBetweenMapPoints(myPoint,shopPoint);
                                                   temp.distance =(int)distanceTmp;
                                               }
                                               [self startArraySort:@"distance" isAscending:YES];
                                           }
                                           else
                                           {
                                               noDataLabel.hidden = NO;
                                           }
                                           [self.tableView reloadData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

//取数方法
- (void)reloadCate
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_lifecate, appkey];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [shopData removeAllObjects];
                                       @try {
                                           shopCateData = [Tool readJsonStrToShopsCate:operation.   responseString];
                                           [self.cateCollection reloadData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           //                                           if (hud != nil) {
                                           //                                               [hud hide:YES];
                                           //                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shopData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConvCell *cell = [tableView dequeueReusableCellWithIdentifier:ConvCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ConvCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[ConvCell class]]) {
                cell = (ConvCell *)o;
                break;
            }
        }
    }
    Shop *shop = [shopData objectAtIndex:[indexPath row]];
    
    cell.titleLb.text = shop.title;
    cell.adressLb.text = [NSString stringWithFormat:@"地址:%@", shop.address];;
    cell.telLb.text = [NSString stringWithFormat:@"电话:%@", shop.tel];
    
    if (shop.distance > 1000) {
        float disf = ((float)shop.distance)/1000;
        cell.distanceLb.text = [NSString stringWithFormat:@"距您%.2f千米", disf];
    }
    else
    {
        cell.distanceLb.text = [NSString stringWithFormat:@"距您%d米", shop.distance];
    }
    [Tool roundView:cell.cellbackgroudView andCornerRadius:3.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shop *shop = [shopData objectAtIndex:[indexPath row]];
    if (shop) {
        ConvOrderView *convView = [[ConvOrderView alloc] init];
        convView.shop = shop;
        convView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:convView animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
}

-(void)startLocation
{
    NSLog(@"进入定位");
    [_locService startUserLocationService];
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D mycoord = userLocation.location.coordinate;
    myPoint = BMKMapPointForCoordinate(mycoord);
    //    如果经纬度大于0表单表示定位成功，停止定位
    if (userLocation.location.coordinate.latitude > 0) {
        [self reload];
        [_locService stopUserLocationService];
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [shopCateData count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BusinessCateCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BusinessCateCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[BusinessCateCell class]]) {
                cell = (BusinessCateCell *)o;
                break;
            }
        }
    }
    int indexRow = [indexPath row];
    ShopsCate *cate = [shopCateData objectAtIndex:indexRow];
    
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loadingpic4.png"]];
    imageView.imageURL = [NSURL URLWithString:cate.logo];
    imageView.frame = CGRectMake(15.0f, 9.0f, 50.0f, 50.0f);
    [cell addSubview:imageView];
    
    cell.nameLb.text = cate.cate_name;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(80, 80);
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int indexRow = [indexPath row];
    ShopsCate *cate = [shopCateData objectAtIndex:indexRow];
    catid = cate.id;
    [self reload];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
