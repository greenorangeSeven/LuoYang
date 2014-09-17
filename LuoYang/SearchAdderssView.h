//
//  SearchAdderssView.h
//  BeautyLife
//
//  Created by Seven on 14-9-3.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchAdderssView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate, UISearchBarDelegate>
{
    NSString *searchWord;
    
    NSArray *communityData;
    NSArray *buildData;
    NSArray *houseData;
    
    NSString *selectCommunityId;
    NSString *selectCommunityStr;
    
    NSString *selectBuildId;
    NSString *selectBuildStr;
    
    NSString *selectHouseId;
    NSString *selectHouseStr;
    
    MBProgressHUD *hud;
}


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *selectCommunityBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBuildBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectHouseBtn;

- (IBAction)selectCommunityAction:(id)sender;
- (IBAction)selectBuildAction:(id)sender;
- (IBAction)selectHouseAction:(id)sender;

- (IBAction)finishAction:(id)sender;

@end
