//
//  BusinessDetailViewViewController.m
//  BeautyLife
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "BusinessDetailView.h"
#import "ADVDetailView.h"
#import "RouteSearchView.h"

@interface BusinessDetailView () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation BusinessDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
    }
    return self;
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapPointAction
{
    if (_shop) {
        if(self.myCoor.latitude > 0)
        {
            CLLocationCoordinate2D coor;
            coor.longitude = [_shop.longitude doubleValue];
            coor.latitude = [_shop.latitude doubleValue];
            
            RouteSearchView *routeSearch = [[RouteSearchView alloc] init];
            routeSearch.startCoor = self.myCoor;
            routeSearch.endCoor = coor;
            routeSearch.storeTitle = _shop.title;
            [self.navigationController pushViewController:routeSearch animated:YES];
        }
        else
        {
            CLLocationCoordinate2D coor;
            coor.longitude = [_shop.longitude doubleValue];
            coor.latitude = [_shop.latitude doubleValue];
            StoreMapPointView *pointView = [[StoreMapPointView alloc] init];
            pointView.storeCoor = coor;
            pointView.storeTitle = _shop.name;
            [self.navigationController pushViewController:pointView animated:YES];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    couponIndex = 0;
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    if (self.tjCatId != nil && [self.tjCatId length] > 0) {
        titleLabel.text = self.tjTitle;
    }
    else
    {
        titleLabel.text = self.shop.name;
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 63, 22)];
        [rBtn addTarget:self action:@selector(mapPointAction) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"business_map"] forState:UIControlStateNormal];
        UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnSearch;
    }

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
    [_imageDownloadsInProgress removeAllObjects];
    goods = nil;
    _iconCache = nil;
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    //清空
    for (Goods *c in goods) {
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

- (void)clear
{
    [goods removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    isLoadOver = NO;
}

//取数方法
- (void)reload
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableString *urlTemp = [[NSMutableString alloc] init];
        if (self.tjCatId != nil && [self.tjCatId length] > 0) {
            if ([self.tjCatId intValue] == 0) {
                urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_tjgoods, appkey];
            }
            else
            {
                urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&catid=%@", api_base_url, api_tjgoods, appkey, self.tjCatId];
            }
        }
        else
        {
            urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_shopsgoods, appkey, self.shop.id];
        }
        if (orderByStr != nil && [orderByStr length] > 0) {
            [urlTemp appendString:[NSString stringWithFormat:@"&orderby=%@", orderByStr]];
        }
        NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
        if (cid != nil && [cid length] > 0) {
            [urlTemp appendString:[NSString stringWithFormat:@"&target=%@", cid]];
        }
        NSString *url = [[NSString stringWithString:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [self clear];
                                       @try {
                                           BusinessGoods *businessGoods = [Tool readJsonStrBusinessGoods:operation.responseString];
                                           
                                           goods = businessGoods.goodlist;
                                           if (goods != nil) {
                                               
                                               [self.collectionView reloadData];
                                           }
                                           
                                           [self doneLoadingTableViewData];
                                           
                                           if (self.tjCatId != nil && [self.tjCatId length] > 0) {
                                               if(advDatas == nil || [advDatas count] == 0)
                                               {
                                                   [self initMainADV];
                                               }
                                           }
                                           else
                                           {
                                               if ([self.couponIv.subviews count] == 0)
                                               {
                                                   [self initMainADV2];
//                                                   if (coupons == nil || [coupons count] == 0) {
//                                                       coupons = businessGoods.coupons;
//                                                       if (coupons != nil && [coupons count] > 0) {
//                                                           int length = [coupons count];
//                                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
//                                                           if (length > 1)
//                                                           {
//                                                               Coupons *coupon = [coupons objectAtIndex:length-1];
//                                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:coupon.title image:coupon.thumb tag:-1];
//                                                               [itemArray addObject:item];
//                                                           }
//                                                           for (int i = 0; i < length; i++)
//                                                           {
//                                                               Coupons *coupon = [coupons objectAtIndex:i];
//                                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:coupon.title image:coupon.thumb tag:-1];
//                                                               [itemArray addObject:item];
//                                                               
//                                                           }
//                                                           //添加第一张图 用于循环
//                                                           if (length >1)
//                                                           {
//                                                               Coupons *coupon = [coupons objectAtIndex:0];
//                                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:coupon.title image:coupon.thumb tag:-1];
//                                                               [itemArray addObject:item];
//                                                           }
//                                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 135) delegate:self imageItems:itemArray isAuto:YES];
//                                                           [bannerView scrollToIndex:0];
//                                                           [self.couponIv addSubview:bannerView];
//                                                       }
//                                                   }
                                               }
                                           }
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

- (void)refreshed:(NSNotification *)notification
{
    if (notification.object) {
        if ([(NSString *)notification.object isEqualToString:@"0"]) {
            [self.collectionView setContentOffset:CGPointMake(0, -75) animated:YES];
            [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
        }
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

- (void)initMainADV
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=13", api_base_url, api_getadv, appkey];
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
                                           
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:length-1];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:length-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:i];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:i];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:0];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:0];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 135) delegate:self imageItems:itemArray isAuto:YES];
                                           [bannerView scrollToIndex:0];
                                           [self.couponIv addSubview:bannerView];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {

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

- (void)initMainADV2
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=28", api_base_url, api_getadv, appkey];
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
                                           
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:length-1];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:length-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:i];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:i];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:0];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:0];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 135) delegate:self imageItems:itemArray isAuto:YES];
                                           [bannerView scrollToIndex:0];
                                           [self.couponIv addSubview:bannerView];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           
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
//    if (self.tjCatId != nil && [self.tjCatId length] > 0) {
        Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:couponIndex];
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
//    }
//    else
//    {
//        Coupons *coupon = [coupons objectAtIndex:couponIndex];
//        CouponDetailView *couponDetail = [[CouponDetailView alloc] init];
//        couponDetail.couponsId = coupon.id;
//        [self.navigationController pushViewController:couponDetail animated:YES];
//    }
    
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
    couponIndex = index;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    bannerView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
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
    
    Goods *good = (Goods *)[goods objectAtIndex:[indexPath row]];
//    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loadpic2.png"]];
//    imageView.imageURL = [NSURL URLWithString:good.thumb];
//    imageView.frame = CGRectMake(0.0f, 0.0f, 150.0f, 91.0f);
//    [cell.picIv addSubview:imageView];
    
    cell.priceLb.text = [NSString stringWithFormat:@"￥%@", good.price];
    cell.titleLb.text = good.title;
    
    //去除所以子视图
    for(UIView *view in [cell.marketPriceLb subviews])
    {
        [view removeFromSuperview];
    }
    
    StrikeThroughLabel *slabel = [[StrikeThroughLabel alloc] initWithFrame:CGRectMake(0, 0, 59, 21)];
    slabel.text = [NSString stringWithFormat:@"￥%@", good.market_price];
    slabel.font = [UIFont italicSystemFontOfSize:12.0f];
    slabel.strikeThroughEnabled = YES;
    [cell.marketPriceLb addSubview:slabel];
    
    if (good.imgData) {
        cell.picIv.image = good.imgData;
    }
    else
    {
        if ([good.thumb isEqualToString:@""]) {
            good.imgData = [UIImage imageNamed:@"loadpic2"];
        }
        else
        {
            NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:good.thumb]];
            if (imageData)
            {
                good.imgData = [UIImage imageWithData:imageData];
                cell.picIv.image = good.imgData;
            }
            else
            {
                IconDownloader *downloader = [_imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                if (downloader == nil) {
                    ImgRecord *record = [ImgRecord new];
                    record.url = good.thumb;
                    [self startIconDownload:record forIndexPath:indexPath];
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
    Goods *good = (Goods *)[goods objectAtIndex:[indexPath row]];
    if (good) {
        GoodsDetailView *goodsDetail = [[GoodsDetailView alloc] init];
        goodsDetail.goodId = good.id;
        [self.navigationController pushViewController:goodsDetail animated:YES];
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
        if (_index >= [goods count])
        {
            return;
        }
        Goods *c = [goods objectAtIndex:[index intValue]];
        if (c) {
            c.imgData = iconDownloader.imgRecord.img;
            // cache it
            NSData * imageData = UIImagePNGRepresentation(c.imgData);
            [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:c.thumb]];
            [self.collectionView reloadData];
        }
    }
}

- (IBAction)segnebtedChangeAction:(id)sender {
    switch (self.orderSegmented.selectedSegmentIndex) {
        case 0:
            orderByStr = @"id";
            break;
        case 1:
            orderByStr = @"buys";
            break;
        case 2:
            orderByStr = @"price";
            break;
    }
    [self reload];
}
@end