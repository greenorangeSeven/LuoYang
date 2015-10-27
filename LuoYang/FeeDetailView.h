//
//  FeeDetailView.h
//  LuoYangSQ
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShuiBill.h"
#import "DianBIll.h"

@interface FeeDetailView : UIViewController

@property (weak, nonatomic) ShuiBill *bill;
@property (weak, nonatomic) DianBIll *dianBill;
@property (weak, nonatomic) UIViewController *parentView;
- (IBAction)closeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *monthLb;
@property (weak, nonatomic) IBOutlet UILabel *preDiShuLb;
@property (weak, nonatomic) IBOutlet UILabel *benyueDiShuLb;
@property (weak, nonatomic) IBOutlet UILabel *totalLiangLb;
@property (weak, nonatomic) IBOutlet UILabel *erciLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLb;

@end
