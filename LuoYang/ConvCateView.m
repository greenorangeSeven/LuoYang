//
//  ConvCateView.m
//  LuoYang
//
//  Created by Seven on 14-11-6.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "ConvCateView.h"

@interface ConvCateView ()

@end

@implementation ConvCateView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"社区万花筒";
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
    BusniessSearchView *searchView = [[BusniessSearchView alloc] init];
    searchView.myPoint = myPoint;
    searchView.viewType = @"conv";
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [self startLocation];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.cateCollection.delegate = self;
    self.cateCollection.dataSource = self;
    [self.cateCollection registerClass:[BusinessCateCell class] forCellWithReuseIdentifier:BusinessCateCellIdentifier];
    self.cateCollection.backgroundColor = [UIColor clearColor];
    [self reloadCate];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initMainADV];
}

- (void)initMainADV
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=31", api_base_url, api_getadv, appkey];
        NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
        if (cid != nil && [cid length] > 0) {
            [tempUrl appendString:[NSString stringWithFormat:@"&cid=%@", cid]];
        }
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           advDatas = [Tool readJsonStrToADV:operation.responseString];
                                           
                                           int length = [advDatas count];
                                           //点赞按钮初始化
                                           Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
                                           
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:length-1];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:i];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:0];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 145) delegate:self imageItems:itemArray isAuto:YES];
                                           [bannerView scrollToIndex:0];
                                           [self.advIv addSubview:bannerView];
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

//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    if (adv)
    {
        if ([adv.redirecturl length] > 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:adv.redirecturl]];
        }
        else
        {
            ADVDetailView *advDetail = [[ADVDetailView alloc] init];
            advDetail.hidesBottomBarWhenPushed = YES;
            advDetail.adv = adv;
            [self.navigationController pushViewController:advDetail animated:YES];
        }
    }
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
    advIndex = index;
}

- (void)viewDidUnload
{
    [self setCateCollection:nil];
    [shopCateData removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    shopCateData = nil;
    _iconCache = nil;
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    //清空
    for (ShopsCate *c in shopCateData) {
        c.imgData = nil;
    }
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    bannerView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bannerView.delegate = self;
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
                                       [shopCateData removeAllObjects];
                                       @try {
                                           shopCateData = [Tool readJsonStrToShopsCate:operation.responseString];
                                           int n = [shopCateData count] % 3;
                                           if(n > 0)
                                           {
                                               for (int i = 0; i < 3 - n; i++) {
                                                   ShopsCate *nCate = [[ShopsCate alloc] init];
                                                   nCate.id = @"-1";
                                                   [shopCateData addObject:nCate];
                                               }
                                           }
                                           
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
    
    if ([cate.id isEqualToString:@"-1"]) {
        cell.picIv.hidden = YES;
        cell.nameLb.hidden = YES;
    }
    else
    {
        cell.picIv.hidden = NO;
        cell.nameLb.hidden = NO;
        cell.nameLb.text = cate.cate_name;
        
        if (cate.imgData) {
            cell.picIv.image = cate.imgData;
        }
        else
        {
            if ([cate.logo isEqualToString:@""]) {
                cate.imgData = [UIImage imageNamed:@"loadpic2"];
            }
            else
            {
                NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:cate.logo]];
                if (imageData)
                {
                    cate.imgData = [UIImage imageWithData:imageData];
                    cell.picIv.image = cate.imgData;
                }
                else
                {
                    IconDownloader *downloader = [_imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                    if (downloader == nil) {
                        ImgRecord *record = [ImgRecord new];
                        record.url = cate.logo;
                        [self startIconDownload:record forIndexPath:indexPath];
                    }
                }
            }
        }
    }
    
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(106, 106);
    
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
    ShopsCate *cate = [shopCateData objectAtIndex:[indexPath row]];
    if (cate) {
        if ([cate.id isEqualToString:@"-1"] == NO) {
            ConvView *convView = [[ConvView alloc] init];
            convView.catid = cate.id;
            convView.typeTitle = cate.cate_name;
            convView.myPoint = myPoint;
            [self.navigationController pushViewController:convView animated:YES];
        }
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma 下载图片
- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",[indexPath row]];
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:key];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgRecord = imgRecord;
        iconDownloader.index = key;
        iconDownloader.delegate = self;
        [_imageDownloadsInProgress setObject:iconDownloader forKey:key];
        [iconDownloader startDownload];
    }
}

- (void)appImageDidLoad:(NSString *)index
{
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:index];
    if (iconDownloader)
    {
        int _index = [index intValue];
        if (_index >= [shopCateData count])
        {
            return;
        }
        ShopsCate *c = [shopCateData objectAtIndex:[index intValue]];
        if (c) {
            c.imgData = iconDownloader.imgRecord.img;
            // cache it
            NSData * imageData = UIImagePNGRepresentation(c.imgData);
            [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:c.logo]];
            [self.cateCollection reloadData];
        }
    }
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

@end
