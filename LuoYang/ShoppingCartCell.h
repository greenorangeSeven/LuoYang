//
//  ShoppingCartCell.h
//  BeautyLife
//
//  Created by Seven on 14-8-25.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UITextField *numberTv;

@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
