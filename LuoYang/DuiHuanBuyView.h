//
//  DuiHuanBuyView.h
//  LuoYangSQ
//
//  Created by Seven on 15/9/3.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuiHuanBuyView : UIViewController<UIAlertViewDelegate>
{
    //付款金额
    double amount;
}

@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) DuiHuanShop *goods;
@property (weak, nonatomic) NSString *amountStr;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
- (IBAction)doBuy:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *GoodsTitles;
@property (weak, nonatomic) IBOutlet UIButton *payBuootn;

@end
