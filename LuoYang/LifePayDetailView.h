//
//  LifePayDetailView.h
//  LuoYangSQ
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifePayCell.h"

@interface LifePayDetailView : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *bills;
}

@property (weak, nonatomic) NSString *type;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLb;

- (IBAction)payAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end
