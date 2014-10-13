//
//  VolnInfoView.m
//  NanNIng
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "VolnInfoView.h"
#import "VolnInfoCell.h"

@interface VolnInfoView ()

@end

@implementation VolnInfoView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"志愿者信息";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
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
    //适配iOS7uinavigationbar遮挡问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   
//    self.view.backgroundColor = [Tool getBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.backgroundColor = [Tool getBackgroundColor];
    [self loadData];
}

- (void)loadData
{
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_get_vol_list, appkey];
    
    [[AFOSCClient sharedClient] getPath:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try
        {
            volnArray = [Tool readJsonStrToVolnArray:operation.responseString];
            [self.tableView reloadData];
        }
        @catch (NSException *exception)
        {
            [NdUncaughtExceptionHandler TakeException:exception];
        }
        @finally
        {
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"获取出错");
        //刷新错误
        if([UserModel Instance].isNetworkRunning == NO)
        {
            return;
        }
        if([UserModel Instance].isNetworkRunning)
        {
            [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return volnArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([volnArray count] > 0)
    {
        if (indexPath.row < [volnArray count])
        {
            VolnInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VolnInfoCell"];
            if (!cell)
            {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"VolnInfoCell" owner:self options:nil];
                for (NSObject *o in objects)
                {
                    if ([o isKindOfClass:[VolnInfoCell class]])
                    {
                        cell = (VolnInfoCell *)o;
                        break;
                    }
                }
            }
            Voln *voln = [volnArray objectAtIndex:[indexPath row]];
            cell.nameLabel.text = [NSString stringWithFormat:@"姓名:%@",voln.name];
            cell.telLabel.text = [NSString stringWithFormat:@"电话:%@",voln.tel];
            NSString *time = [Tool intervalSinceNow:[Tool TimestampToDateStr:voln.addtime andFormatterStr:@"yyyy-MM-dd HH:mm:ss"]];
            
            cell.causeLb.frame = CGRectMake(cell.causeLb.frame .origin.x, cell.causeLb.frame.origin.y, cell.causeLb.frame.size.width, voln.causeHeight);
            cell.causeLb.text = voln.cause;
            
            cell.timeLabel.text = [NSString stringWithFormat:@"%@加入",time];

            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Voln *voln = [volnArray objectAtIndex:[indexPath row]];
    int height = 80 + voln.causeHeight - 21;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Voln *voln = [volnArray objectAtIndex:[indexPath row]];
//    VolnInfoDetailView *volnInfoDetailView = [[VolnInfoDetailView alloc] init];
//    volnInfoDetailView.voln = voln;
//    volnInfoDetailView.hidesBottomBarWhenPushed = NO;
//    [self.navigationController pushViewController:volnInfoDetailView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
