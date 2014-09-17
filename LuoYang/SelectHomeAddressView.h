//
//  SelectHomeAddressView.h
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOCache.h"
#import "AreaListModel.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "RegionModel.h"

@interface SelectHomeAddressView : UIViewController< UIActionSheetDelegate, UIPickerViewDelegate>
{
    NSArray *areaData;
    NSArray *communityData;
    NSArray *buildData;
    NSArray *houseData;
    
    NSArray *provinceArray;
    NSArray *cityArray;
    NSArray *regionArray;
    
    NSString *selectProvinceId;
    NSString *selectCityId;
    NSString *selectRegionId;
    
    NSString *selectProvinceStr;
    NSString *selectCityStr;
    NSString *selectRegionStr;
    
    NSString *selectCommunityId;
    NSString *selectCommunityStr;
    
    NSString *selectBuildId;
    NSString *selectBuildStr;
    
    NSString *selectHouseId;
    NSString *selectHouseStr;
    
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIButton *selectAreaBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectCommunityBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBuildBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectHouseBtn;

- (IBAction)selectCommunityAction:(id)sender;
- (IBAction)selectBuildAction:(id)sender;
- (IBAction)selectHouseAction:(id)sender;
- (IBAction)selectRegionAction:(id)sender;

- (IBAction)finishAction:(id)sender;

@end
