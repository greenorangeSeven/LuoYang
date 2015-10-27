//
//  FeeDetailView.m
//  LuoYangSQ
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "FeeDetailView.h"
#import "UIViewController+CWPopup.h"

@interface FeeDetailView ()

@end

@implementation FeeDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.bill) {
        self.monthLb.text = [NSString stringWithFormat:@"%@清单：", self.bill.riqi];
        self.preDiShuLb.text = [NSString stringWithFormat:@"上月抄表底数：%@", self.bill.pre_chaobiao_num];
        self.benyueDiShuLb.text = [NSString stringWithFormat:@"本月抄表底数：%@", self.bill.benyue_chaobiao_num];
        self.totalLiangLb.text = [NSString stringWithFormat:@"总用水量：%@", self.bill.total_shui];
        self.erciLb.text = [NSString stringWithFormat:@"二次加压水费：%@", self.bill.erci_dianfei];
        self.priceLb.text = [NSString stringWithFormat:@"单价：%@", self.bill.price];
        self.totalMoneyLb.text = [NSString stringWithFormat:@"本月水费总额：%@元", self.bill.total_fee];
    }
    else if(self.dianBill)
    {
        self.monthLb.text = [NSString stringWithFormat:@"%@清单：", self.dianBill.riqi];
        self.preDiShuLb.text = [NSString stringWithFormat:@"上月抄表底数：%@", self.dianBill.pre_chaobiao_num];
        self.benyueDiShuLb.text = [NSString stringWithFormat:@"本月抄表底数：%@", self.dianBill.benyue_chaobiao_num];
        self.totalLiangLb.text = [NSString stringWithFormat:@"总用电量：%@", self.dianBill.total_dian];
        self.erciLb.hidden =YES;
        self.priceLb.text = [NSString stringWithFormat:@"单价：%@", self.dianBill.price];
        self.totalMoneyLb.text = [NSString stringWithFormat:@"本月电费总额：%@元", self.dianBill.total_dianfei];
    }
}

- (void)closeLoad
{
    [_parentView dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeAction:(id)sender {
    [self closeLoad];
}
@end
