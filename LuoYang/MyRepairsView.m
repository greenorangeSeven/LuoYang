//
//  MyRepairsView.m
//  BeautyLife
//
//  Created by Seven on 14-8-4.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "MyRepairsView.h"

@interface MyRepairsView ()

@end

@implementation MyRepairsView

@synthesize bgView;
@synthesize myRepairsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Tool roundView:self.bgView andCornerRadius:3.0];
    self.myRepairsTable.dataSource = self;
    self.myRepairsTable.delegate = self;
    //    设置无分割线
    self.myRepairsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self reload];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:Notification_RefreshMyRepairs object:nil];
}

- (void)reload
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_mybaoxiu, appkey, [[UserModel Instance] getUserValueForKey:@"id"]];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           myRepairsData = [Tool readJsonStrToMyRepairs:operation.responseString];
                                           [self.myRepairsTable reloadData];
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


#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myRepairsData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRepairsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRepairsCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyRepairsCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MyRepairsCell class]]) {
                cell = (MyRepairsCell *)o;
                break;
            }
        }
    }
    RepairsList *myRepair = [myRepairsData objectAtIndex:[indexPath row]];
    [Tool borderView:cell.bgLb];
    cell.repairsNoLb.text = myRepair.order_no;
    cell.summaryLb.text = myRepair.summary;
    if ([myRepair.weixiu_name length] > 0) {
        cell.weixiuInfoLb.text = [NSString stringWithFormat:@"维修人：%@  %@", myRepair.weixiu_name, myRepair.weixiu_tel];
    }
    
    cell.statusTextLb.text = myRepair.status;
    if ([myRepair.rate intValue] > 0) {
        //星级评价
        AMRatingControl *gradeControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0)
                                                                       emptyColor:[UIColor colorWithRed:245.0/255 green:130.0/255 blue:33.0/255 alpha:1.0]
                                                                       solidColor:[UIColor colorWithRed:245.0/255 green:130.0/255 blue:33.0/255 alpha:1.0]
                                                                     andMaxRating:5  andStarSize:15 andStarWidthAndHeight:15];
        
        [gradeControl setRating:[myRepair.rate intValue]];
        [cell.gradeLb addSubview:gradeControl];
    }
    
    return cell;
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairsList *myRepair = [myRepairsData objectAtIndex:[indexPath row]];
    if (myRepair) {
        if ([myRepair.status isEqualToString:@"维修完成"]) {
            RepairsRateView *rateView = [[RepairsRateView alloc] init];
            rateView.repair = myRepair;
            [self.navigationController pushViewController:rateView animated:YES];
        }
        else
        {
            RepairsItemView *repairsItem = [[RepairsItemView alloc] init];
            repairsItem.repair = myRepair;
            [self.navigationController pushViewController:repairsItem animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
