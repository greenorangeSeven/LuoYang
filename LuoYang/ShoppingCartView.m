//
//  ShoppingCartView.m
//  BeautyLife
//
//  Created by Seven on 14-8-25.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ShoppingCartView.h"
#import "PayOrder.h"
#import "ShoppingBuyView.h"

@interface ShoppingCartView ()

@end

@implementation ShoppingCartView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"购物车";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
    }
    return self;
    
}

- (void)myAction
{
    [Tool pushToMyView:self.navigationController];
}

- (void)settingAction
{
    [Tool pushToSettingView:self.navigationController];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([_type isEqualToString:@"detail"]) {
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
    } else {
//        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 31, 28)];
//        [lBtn addTarget:self action:@selector(myAction) forControlEvents:UIControlEventTouchUpInside];
//        [lBtn setImage:[UIImage imageNamed:@"navi_my"] forState:UIControlStateNormal];
//        UIBarButtonItem *btnMy = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
//        self.navigationItem.leftBarButtonItem = btnMy;
//        
//        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 31, 28)];
//        [rBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
//        [rBtn setImage:[UIImage imageNamed:@"navi_setting"] forState:UIControlStateNormal];
//        UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
//        self.navigationItem.rightBarButtonItem = btnSetting;
    }
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    goodData = [[NSMutableArray alloc] init];
    self.goodTableView.dataSource = self;
    self.goodTableView.delegate = self;
    self.goodTableView.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
    
    noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 44)];
    noDataLabel.font = [UIFont boldSystemFontOfSize:18];
    noDataLabel.text = @"暂无物品";
    noDataLabel.textColor = [UIColor blackColor];
    noDataLabel.backgroundColor = [UIColor clearColor];
    noDataLabel.textAlignment = UITextAlignmentCenter;
    noDataLabel.hidden = YES;
    [self.view addSubview:noDataLabel];
    
    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserModel Instance].isLogin == NO)
    {
        self.totalLb.text = @"0.00";
        [goodData removeAllObjects];
        [self.goodTableView reloadData];
        noDataLabel.hidden = NO;
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    noDataLabel.hidden = YES;
    [self reloadData];
}

//取数方法
- (void)reloadData
{
    self.totalLb.text = @"0.00";
    [goodData removeAllObjects];
    total = 0.00;
    FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
    if (![database open]) {
        NSLog(@"Open database failed");
        return;
    }
    if (![database tableExists:@"shoppingcart"]) {
        [database executeUpdate:createshoppingcart];
    }
    FMResultSet* resultSet=[database executeQuery:@"select * from shoppingcart where user_id = ? order by business_id", [[UserModel Instance] getUserValueForKey:@"id"]];
    while ([resultSet next]) {
        Goods *good = [[Goods alloc] init];
        good.id = [resultSet stringForColumn:@"goodid"];
        good.title = [resultSet stringForColumn:@"title"];
        good.attrsStr = [resultSet stringForColumn:@"attrs"];
        good.thumb = [resultSet stringForColumn:@"thumb"];
        good.price = [resultSet stringForColumn:@"price"];
        good.store_name = [resultSet stringForColumn:@"store_name"];
        good.business_id = [resultSet stringForColumn:@"business_id"];
        good.number = [NSNumber numberWithInteger:[resultSet intForColumn:@"number"]];
        
        total += [good.price doubleValue] * [good.number intValue];
        [goodData addObject:good];
    }
    if ([goodData count] > 0) {
        self.totalLb.text = [NSString stringWithFormat:@"%.2f", total];
    }
    else
    {
        noDataLabel.hidden = NO;
        _buyButton.enabled = NO;
    }
    [self.goodTableView reloadData];
    [database close];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [goodData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ShoppingCartCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ShoppingCartCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[ShoppingCartCell class]]) {
                cell = (ShoppingCartCell *)o;
                break;
            }
        }
    }
    int indexRow = [indexPath row];
    
    Goods *good = (Goods *)[goodData objectAtIndex:indexRow];
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"nopic2.png"]];
    imageView.imageURL = [NSURL URLWithString:good.thumb];
    imageView.frame = CGRectMake(0.0f, 0.0f, 80.0f, 80.0f);
    [cell.picIv addSubview:imageView];
    
    cell.storeNameLb.text = good.store_name;
    cell.titleLb.text = good.title;
    cell.priceLb.text = good.price;
    cell.numberTv.text = [good.number stringValue];
    
    if ([good.number intValue] <= 1) {
        cell.minusBtn.enabled = NO;
    }
    
    cell.attrsLb.text = good.attrsStr;
    
    [cell.minusBtn addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.minusBtn.tag = indexRow;
    
    [cell.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.addBtn.tag = indexRow;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = indexRow;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)minusAction:(id)sender {
    UIButton *tap = (UIButton *)sender;
    if (tap) {
        Goods *good = (Goods *)[goodData objectAtIndex:tap.tag];
        
        FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
        if (![database open]) {
            NSLog(@"Open database failed");
            return;
        }
        if (![database tableExists:@"shoppingcart"]) {
            [database executeUpdate:createshoppingcart];
        }
        BOOL updateGood = [database executeUpdate:@"update shoppingcart set number = number - 1 where goodid= ? and user_id = ?", good.id, [[UserModel Instance] getUserValueForKey:@"id"]];
        [database close];
        if (updateGood) {
            [self reloadData];
        }
    }
}

- (IBAction)addAction:(id)sender {
    UIButton *tap = (UIButton *)sender;
    if (tap) {
        Goods *good = (Goods *)[goodData objectAtIndex:tap.tag];
        
        FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
        if (![database open]) {
            NSLog(@"Open database failed");
            return;
        }
        if (![database tableExists:@"shoppingcart"]) {
            [database executeUpdate:createshoppingcart];
        }
        BOOL updateGood = [database executeUpdate:@"update shoppingcart set number = number + 1 where goodid= ? and user_id = ?", good.id, [[UserModel Instance] getUserValueForKey:@"id"]];
        [database close];
        if (updateGood) {
            [self reloadData];
        }
    }
}

- (IBAction)deleteAction:(id)sender {
    UIButton *tap = (UIButton *)sender;
    if (tap) {
        Goods *good = (Goods *)[goodData objectAtIndex:tap.tag];
        
        FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
        if (![database open]) {
            NSLog(@"Open database failed");
            return;
        }
        if (![database tableExists:@"shoppingcart"]) {
            [database executeUpdate:createshoppingcart];
        }
        BOOL detele = [database executeUpdate:@"delete from shoppingcart where goodid = ? and user_id = ?", good.id, [[UserModel Instance] getUserValueForKey:@"id"]];
        [database close];
        if (detele) {
            [self reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)balanceAction:(id)sender {
    if ([goodData count] > 0)
    {
        ShoppingBuyView *shoppingBuyView = [[ShoppingBuyView alloc] init];
        shoppingBuyView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shoppingBuyView animated:YES];
    }
    else
    {
        
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

@end
