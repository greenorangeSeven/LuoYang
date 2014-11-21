//
//  SelectHomeAddressView.m
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "SelectHomeAddressView.h"

@interface SelectHomeAddressView ()

@end

@implementation SelectHomeAddressView

@synthesize selectAreaBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"住址选择";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    AreaListModel *areaList = (AreaListModel *)[[EGOCache currentCache] objectForKey:AreaListKey];
    if (areaList == nil) {
        [self initAreaData];
    }
    else
    {
        areaData = areaList.areaList;
    }
    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)initAreaData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"数据获取" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_getregion, appkey];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           areaData = [Tool readJsonStrToRegionArray:operation.responseString];
                                           AreaListModel *areaList = [[AreaListModel alloc] initWithParameters:areaData];
                                           [[EGOCache currentCache] setObject:areaList forKey:AreaListKey withTimeoutInterval:3600 * 24 *7];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

- (void)getCommunity
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"数据获取" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&town=%@", api_base_url, api_community, appkey, selectRegionId];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           communityData = [Tool readJsonStrToCommunityArray:operation.responseString];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

- (IBAction)selectRegionAction:(id)sender {
    provinceArray = areaData;
    ProvinceModel *pro = (ProvinceModel *)[provinceArray objectAtIndex:0];
    cityArray = pro.cityArray;
    CityModel *city = (CityModel *)[cityArray objectAtIndex:0];
    regionArray = city.regionArray;
    RegionModel *region = (RegionModel *)[regionArray objectAtIndex:0];
    selectProvinceId = pro.id;
    selectProvinceStr = pro.name;
    selectCityId = city.id;
    selectCityStr = city.name;
    selectRegionId = region.id;
    selectRegionStr = region.name;
    if (IS_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIPickerView *cityPicker = [[UIPickerView alloc] init];
        cityPicker.delegate = self;
        cityPicker.showsSelectionIndicator = YES;
        cityPicker.tag = 0;
        [alert.view addSubview:cityPicker];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [self getCommunity];
                                                    [self.selectAreaBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@", selectProvinceStr, selectCityStr, selectRegionStr] forState:UIControlStateNormal];
                                                    selectCommunityId = nil;
                                                    selectCommunityStr = nil;
                                                    self.selectCommunityBtn.enabled = YES;
                                                    [self.selectCommunityBtn setTitle:@"选择小区" forState:UIControlStateNormal];
                                                    selectBuildId = nil;
                                                    selectBuildStr = nil;
                                                    self.selectBuildBtn.enabled = NO;
                                                    [self.selectBuildBtn setTitle:@"选择楼栋" forState:UIControlStateNormal];
                                                    selectHouseId = nil;
                                                    selectHouseStr = nil;
                                                    self.selectHouseBtn.enabled = NO;
                                                    [self.selectHouseBtn setTitle:@"选择房号" forState:UIControlStateNormal];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
        UIPickerView *cityPicker = [[UIPickerView alloc] init];
        cityPicker.delegate = self;
        cityPicker.showsSelectionIndicator = YES;
        cityPicker.tag = 0;
        [actionSheet addSubview:cityPicker];
    }
}

- (IBAction)selectCommunityAction:(id)sender {
    if (communityData != nil && [communityData count] > 0) {
        CommunityModel *community = (CommunityModel *)[communityData objectAtIndex:0];
        buildData = community.buildArray;
        selectCommunityId = community.id;
        selectCommunityStr = community.title;
    }
    else
    {
        [self.selectCommunityBtn setTitle:@"暂无小区" forState:UIControlStateNormal];
        return;
    }
    if (IS_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIPickerView *communityPicker = [[UIPickerView alloc] init];
        communityPicker.delegate = self;
        communityPicker.showsSelectionIndicator = YES;
        communityPicker.tag = 1;
        [alert.view addSubview:communityPicker];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    self.selectBuildBtn.enabled = YES;
                                                    [self.selectCommunityBtn setTitle:selectCommunityStr forState:UIControlStateNormal];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
        UIPickerView *communityPicker = [[UIPickerView alloc] init];
        communityPicker.delegate = self;
        communityPicker.showsSelectionIndicator = YES;
        communityPicker.tag = 1;
        [actionSheet addSubview:communityPicker];
    }
}

- (IBAction)selectBuildAction:(id)sender {
    if (buildData != nil && [buildData count] > 0) {
        BuildModel *build = (BuildModel *)[buildData objectAtIndex:0];
        houseData = build.houseArray;
        selectBuildId = build.id;
        selectBuildStr = build.name;
    }
    if (IS_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIPickerView *buildPicker = [[UIPickerView alloc] init];
        buildPicker.delegate = self;
        buildPicker.showsSelectionIndicator = YES;
        buildPicker.tag = 2;
        [alert.view addSubview:buildPicker];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    self.selectHouseBtn.enabled = YES;
                                                    [self.selectBuildBtn setTitle:selectBuildStr forState:UIControlStateNormal];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        actionSheet.tag = 2;
        [actionSheet showInView:self.view];
        UIPickerView *buildPicker = [[UIPickerView alloc] init];
        buildPicker.delegate = self;
        buildPicker.showsSelectionIndicator = YES;
        buildPicker.tag = 2;
        [actionSheet addSubview:buildPicker];
    }
}

- (IBAction)selectHouseAction:(id)sender {
    if (houseData != nil && [houseData count] > 0) {
        HouseModel *house = (HouseModel *)[houseData objectAtIndex:0];
        selectHouseId = house.id;
        selectHouseStr = house.house_number;
    }
    if (IS_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIPickerView *housePicker = [[UIPickerView alloc] init];
        housePicker.delegate = self;
        housePicker.showsSelectionIndicator = YES;
        housePicker.tag = 3;
        [alert.view addSubview:housePicker];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [self.selectHouseBtn setTitle:selectHouseStr forState:UIControlStateNormal];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        actionSheet.tag = 3;
        [actionSheet showInView:self.view];
        UIPickerView *housePicker = [[UIPickerView alloc] init];
        housePicker.delegate = self;
        housePicker.showsSelectionIndicator = YES;
        housePicker.tag = 3;
        [actionSheet addSubview:housePicker];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            [self getCommunity];
            [self.selectAreaBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@", selectProvinceStr, selectCityStr, selectRegionStr] forState:UIControlStateNormal];
            selectCommunityId = nil;
            selectCommunityStr = nil;
            self.selectCommunityBtn.enabled = YES;
            [self.selectCommunityBtn setTitle:@"选择小区" forState:UIControlStateNormal];
            selectBuildId = nil;
            selectBuildStr = nil;
            self.selectBuildBtn.enabled = NO;
            [self.selectBuildBtn setTitle:@"选择楼栋" forState:UIControlStateNormal];
            selectHouseId = nil;
            selectHouseStr = nil;
            self.selectHouseBtn.enabled = NO;
            [self.selectHouseBtn setTitle:@"选择房号" forState:UIControlStateNormal];
        }
    }
    else if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            self.selectBuildBtn.enabled = YES;
            [self.selectCommunityBtn setTitle:selectCommunityStr forState:UIControlStateNormal];
        }
    }
    else if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            self.selectHouseBtn.enabled = YES;
            [self.selectBuildBtn setTitle:selectBuildStr forState:UIControlStateNormal];
        }
    }
    else if (actionSheet.tag == 3) {
        if (buttonIndex == 0) {
            [self.selectHouseBtn setTitle:selectHouseStr forState:UIControlStateNormal];
        }
    }
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 0) {
        return 3;
    }
    else if (pickerView.tag == 1 || pickerView.tag == 2 || pickerView.tag == 3)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
    {
        switch (component) {
            case 0:
                return [provinceArray count];
                break;
            case 1:
                return [cityArray count];
                break;
            case 2:
                return [regionArray count];
                break;
            default:
                return 0;
                break;
        }
    }
    else if (pickerView.tag == 1)
    {
        return [communityData count];
    }
    else if (pickerView.tag == 2)
    {
        return [buildData count];
    }
    else if (pickerView.tag == 3)
    {
        return [houseData count];
    }
    else
    {
        return 0;
    }
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
    {
        if (component == 0) {
            ProvinceModel *pro = (ProvinceModel *)[provinceArray objectAtIndex:row];
            return pro.name;
        }
        else if(component == 1) {
            CityModel *city = (CityModel *)[cityArray objectAtIndex:row];
            return city.name;
        }
        else if(component == 2) {
            RegionModel *region = (RegionModel *)[regionArray objectAtIndex:row];
            return region.name;
        }
        else
        {
            return nil;
        }
    }
    else if (pickerView.tag == 1)
    {
        CommunityModel *community = (CommunityModel *)[communityData objectAtIndex:row];
        return community.title;
    }
    else if (pickerView.tag == 2)
    {
        BuildModel *build = (BuildModel *)[buildData objectAtIndex:row];
        return build.name;
    }
    else if (pickerView.tag == 3)
    {
        HouseModel *house = (HouseModel *)[houseData objectAtIndex:row];
        return house.house_number;
    }
    else
    {
        return nil;
    }
}

-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    if(pickerView.tag == 0)
    {
        if (component == 0) {
            ProvinceModel *pro = (ProvinceModel *)[provinceArray objectAtIndex:row];
            cityArray = pro.cityArray;
            CityModel *city = (CityModel *)[cityArray objectAtIndex:0];
            regionArray = city.regionArray;
            RegionModel *region = (RegionModel *)[regionArray objectAtIndex:0];
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
            selectProvinceId = pro.id;
            selectProvinceStr = pro.name;
            selectCityId = city.id;
            selectCityStr = city.name;
            selectRegionId = region.id;
            selectRegionStr = region.name;
        }
        else if(component == 1) {
            CityModel *city = (CityModel *)[cityArray objectAtIndex:row];
            regionArray = city.regionArray;
            RegionModel *region = (RegionModel *)[regionArray objectAtIndex:0];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
            selectCityId = city.id;
            selectCityStr = city.name;
            selectRegionId = region.id;
            selectRegionStr = region.name;
        }
        else if(component == 2) {
            RegionModel *region = (RegionModel *)[regionArray objectAtIndex:row];
            selectRegionId = region.id;
            selectRegionStr = region.name;
        }
    }
    else if (pickerView.tag == 1)
    {
        CommunityModel *community = (CommunityModel *)[communityData objectAtIndex:row];
        buildData = community.buildArray;
        selectCommunityId = community.id;
        selectCommunityStr = community.title;
    }
    else if (pickerView.tag == 2)
    {
        BuildModel *build = (BuildModel *)[buildData objectAtIndex:row];
        houseData = build.houseArray;
        selectBuildId = build.id;
        selectBuildStr = build.name;
    }
    else if (pickerView.tag == 3)
    {
        HouseModel *house = (HouseModel *)[houseData objectAtIndex:row];
        selectHouseId = house.id;
        selectHouseStr = house.house_number;
    }
}

- (IBAction)finishAction:(id)sender {
    UserModel *userModel = [UserModel Instance];
    [userModel saveValue:selectProvinceId ForKey:@"selectProvinceId"];
    [userModel saveValue:selectProvinceStr ForKey:@"selectProvinceStr"];
    [userModel saveValue:selectCityId ForKey:@"selectCityId"];
    [userModel saveValue:selectCityStr ForKey:@"selectCityStr"];
    [userModel saveValue:selectRegionId ForKey:@"selectRegionId"];
    [userModel saveValue:selectRegionStr ForKey:@"selectRegionStr"];
    [userModel saveValue:selectCommunityId ForKey:@"selectCommunityId"];
    [userModel saveValue:selectCommunityStr ForKey:@"selectCommunityStr"];
    [userModel saveValue:selectBuildId ForKey:@"selectBuildId"];
    [userModel saveValue:selectBuildStr ForKey:@"selectBuildStr"];
    [userModel saveValue:selectHouseId ForKey:@"selectHouseId"];
    [userModel saveValue:selectHouseStr ForKey:@"selectHouseStr"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
