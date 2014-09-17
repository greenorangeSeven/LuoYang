//
//  StewardFeeView.h
//  BeautyLife
//
//  Created by Seven on 14-8-1.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyFeeInfo.h"
#import "EGOImageView.h"

@interface StewardFeeView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate, UIAlertViewDelegate>
{
    UserModel *usermodel;
    double monthFee;
    //应缴物业费
    double arrearage;
    int arrearageMonth;
    //预缴物业费
    double presetValue;
    int presetMonth;
    NSArray *presetData;
}

@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (strong, nonatomic) UIView *parentView;

@property (weak, nonatomic) IBOutlet UILabel *telLb;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *payfeeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLb;
@property (weak, nonatomic) IBOutlet UILabel *shouldPayLb;
@property (weak, nonatomic) IBOutlet UIButton *presetBtn;
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *feeinfoLb;

- (IBAction)showPresetAction:(id)sender;

- (IBAction)payFeeAction:(UIButton *)sender;

- (IBAction)showHistoryAction:(UIButton *)sender;
@end
