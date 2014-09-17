//
//  ShoppingCartView.h
//  BeautyLife
//
//  Created by Seven on 14-8-25.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartCell.h"
#import "EGOImageView.h"
#import "OrderInfo.h"
#import "OrderBusiness.h"
#import "OrderGood.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "RMMapper.h"
#import "JSONKit.h"
#import "PrintObject.h"

@interface ShoppingCartView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    NSMutableArray *goodData;
    MBProgressHUD *hud;
    float total;
    UILabel *noDataLabel;
}

@property (weak, nonatomic) IBOutlet UITableView *goodTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLb;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

- (IBAction)balanceAction:(id)sender;

@end
