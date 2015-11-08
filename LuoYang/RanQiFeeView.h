//
//  RanQiFeeView.h
//  LuoYangSQ
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RanQiFeeView : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *rqCodeNumTf;
@property (weak, nonatomic) IBOutlet UITextField *moneyTv;
- (IBAction)payAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTf;

@end
