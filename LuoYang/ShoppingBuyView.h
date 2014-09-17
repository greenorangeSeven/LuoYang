//
//  ShoppingBuyView.h
//  BeautyLife
//
//  Created by mac on 14-9-4.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingBuyView : UIViewController

@property (weak, nonatomic) Goods *goods;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
- (IBAction)doBuy:(UIButton *)sender;


@end
