//
//  BusniessSearchView.m
//  BeautyLife
//
//  Created by Seven on 14-8-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "BusniessSearchView.h"

@interface BusniessSearchView ()

@end

@implementation BusniessSearchView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"搜索";
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
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.searchBar.delegate = self;
    if (!IS_IOS7) {
        [self.searchBar setTintColor:[Tool getBackgroundColor]];
    }
    [self.searchBar becomeFirstResponder];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, 320, 44)];
    noDataLabel.font = [UIFont boldSystemFontOfSize:18];
    noDataLabel.text = @"暂无相关数据";
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
        NSString *viewAPI = @"";
        if ([_viewType isEqualToString:@"shop"]) {
            viewAPI = api_shoplist;
        }
        else
        {
            viewAPI = api_lifelist;
        }
        NSMutableString *urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, viewAPI, appkey];
        if (searchKey != nil && [searchKey length] > 0) {
            [urlTemp appendString:[NSString stringWithFormat:@"&kwd=%@", searchKey]];
        }
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
                                                   CLLocationDistance distanceTmp = BMKMetersBetweenMapPoints(_myPoint,shopPoint);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shopData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_viewType isEqualToString:@"shop"]) {
        BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:BusinessCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BusinessCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[BusinessCell class]]) {
                    cell = (BusinessCell *)o;
                    break;
                }
            }
        }
        Shop *shop = [shopData objectAtIndex:[indexPath row]];
        
        EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loadingpic4.png"]];
        imageView.imageURL = [NSURL URLWithString:shop.logo];
        imageView.frame = CGRectMake(0.0f, 0.0f, 116.0f, 61.0f);
        [cell.logo addSubview:imageView];
        
        cell.shopTitleLb.text = shop.name;
        cell.summaryLb.text = shop.summary;
        
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
    else
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_viewType isEqualToString:@"shop"]) {
        return 102;
    }
    else
    {
        return 103;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shop *shop = [shopData objectAtIndex:[indexPath row]];
    if (shop) {
        if ([_viewType isEqualToString:@"shop"]) {
            
            BusinessDetailView *businessDetailView = [[BusinessDetailView alloc] init];
            businessDetailView.shop = shop;
            businessDetailView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:businessDetailView animated:YES];
        }
        else
        {
            ConvOrderView *convView = [[ConvOrderView alloc] init];
            convView.shop = shop;
            convView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:convView animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchKey = searchBar.text;
    if ([searchKey length] > 0) {
        [self.searchBar resignFirstResponder];// 放弃第一响应者
        [self.searchBar setShowsCancelButton:NO animated:YES];
        [self reload];
    }
    else
    {
        [Tool showCustomHUD:@"请输入要搜索的商家名称" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
    }
}

//编辑代理(完成编辑触发)
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];// 放弃第一响应者
    searchKey = @"";
}

@end
