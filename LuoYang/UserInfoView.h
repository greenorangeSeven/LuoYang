//
//  UserInfoView.h
//  BeautyLife
//
//  Created by Seven on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EGOImageView.h"
#import "NSString+STRegex.h"
#import "ChooseAreaView.h"

@interface UserInfoView : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate, UIPickerViewDelegate>
{
    EGOImageView *faceEGOImageView;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *userFaceIv;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UILabel *homeAddressLb;
@property (weak, nonatomic) IBOutlet UITextField *emailTf;
@property (weak, nonatomic) IBOutlet UITextField *idCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *saveInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectHomeAddressBtn;

- (IBAction)selectHomeAddressAction:(id)sender;
- (IBAction)saveInfoAction:(id)sender;
- (IBAction)uploadFaceAction:(id)sender;

@end
