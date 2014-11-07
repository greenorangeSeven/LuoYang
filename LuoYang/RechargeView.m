//
//  RechargeView.m
//  BeautyLife
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "RechargeView.h"

@interface RechargeView ()

@end

@implementation RechargeView

@synthesize imageDownloadsInProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"在线服务";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    links = [[NSMutableArray alloc] init];
    [Tool roundView:self.bgLb andCornerRadius:3.0];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[RechargeCell class] forCellWithReuseIdentifier:RechargeCellIdentifier];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self reload];
    //适配iOS7uinavigationbar遮挡tableView的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//取数方法
- (void)reload
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_getlinks, appkey];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           links = [Tool readJsonStrToLinksArray:operation.responseString];
                                           [self.collectionView reloadData];
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

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [links count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RechargeCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RechargeCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[RechargeCell class]]) {
                cell = (RechargeCell *)o;
                break;
            }
        }
    }
    OnlineLink *project = [links objectAtIndex:[indexPath row]];
    cell.titleLb.text = project.title;
    
    
    //图片显示及缓存
    if (project.imgData) {
        cell.logoIv.image = project.imgData;
    }
    else
    {
        if ([project.logo isEqualToString:@""]) {
            project.imgData = [UIImage imageNamed:@"loadpic3.png"];
        }
        else
        {
            NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:project.logo]];
            if (imageData) {
                project.imgData = [UIImage imageWithData:imageData];
                cell.logoIv.image = project.imgData;
            }
            else
            {
                IconDownloader *downloader = [imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                if (downloader == nil) {
                    ImgRecord *record = [ImgRecord new];
                    NSString *urlStr = project.logo;
                    record.url = urlStr;
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
    return CGSizeMake(92, 87);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7, 5, 3, 5);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OnlineLink *project = [links objectAtIndex:[indexPath row]];
    if (project) {
        if ([project.link length] > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:project.link]];
//            RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
//            detailView.titleStr = project.title;
//            detailView.urlStr = project.link;
//            [self.navigationController pushViewController:detailView animated:YES];
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
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:key];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgRecord = imgRecord;
        iconDownloader.index = key;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:key];
        [iconDownloader startDownload];
    }
}

- (void)appImageDidLoad:(NSString *)index
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:index];
    if (iconDownloader)
    {
        int _index = [index intValue];
        if (_index >= [links count]) {
            return;
        }
        OnlineLink *project = [links objectAtIndex:[index intValue]];
        if (project) {
            project.imgData = iconDownloader.imgRecord.img;
            // cache it
            NSData * imageData = UIImagePNGRepresentation(project.imgData);
            [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:project.logo]];
            [self.collectionView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidUnload {
    [self setCollectionView:nil];
    [links removeAllObjects];
    [imageDownloadsInProgress removeAllObjects];
    links = nil;
    _iconCache = nil;
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
}

- (IBAction)huocheAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"火车票";
    detailView.urlStr = @"http://touch.qunar.com/h5/train/?from=touchindex";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)jipiaoAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"机票";
    detailView.urlStr = @"http://touch.qunar.com/h5/flight/";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)yidongAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"移动充值";
    detailView.urlStr = @"http://wap.10086.cn/czjf/czjf.jsp";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)liantongAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"联通充值";
    detailView.urlStr = @"http://wap.10010.com/t/home.htm";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)dianxinAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"电信充值";
    detailView.urlStr = @"http://wapzt.189.cn";
    [self.navigationController pushViewController:detailView animated:YES];
}
@end
