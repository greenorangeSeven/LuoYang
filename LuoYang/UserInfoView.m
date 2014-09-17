//
//  UserInfoView.m
//  BeautyLife
//
//  Created by Seven on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "UserInfoView.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface UserInfoView ()

@end

@implementation UserInfoView
@synthesize nicknameTf;
@synthesize nameTf;
@synthesize homeAddressLb;
@synthesize emailTf;
@synthesize idCodeTf;
@synthesize saveInfoBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"编辑用户信息";
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
    UserModel *usermodel = [UserModel Instance];
    
    faceEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"userface.png"]];
    faceEGOImageView.imageURL = [NSURL URLWithString:[[UserModel Instance] getUserValueForKey:@"avatar"]];
    faceEGOImageView.frame = CGRectMake(0.0f, 0.0f, 65.0f, 65.0f);
    [self.userFaceIv addSubview:faceEGOImageView];
    
    NSString *nicknameStr = [usermodel getUserValueForKey:@"nickname"];
    NSString *nameStr = [usermodel getUserValueForKey:@"name"];
    NSString *emailStr = [usermodel getUserValueForKey:@"email"];
    NSString *addressStr = [usermodel getUserValueForKey:@"address"];
    NSString *idcodeStr = [usermodel getUserValueForKey:@"card_id"];
    self.nicknameTf.text = nicknameStr;
    self.nameTf.text = nameStr;
    if (addressStr != nil && [addressStr length] > 0) {
        self.homeAddressLb.text = addressStr;
    }
    self.emailTf.text = emailStr;
    self.idCodeTf.text = idcodeStr;
    //用户是否已认证，已认证后真实信息不能修改
    //    if ([[usermodel getUserValueForKey:@"checkin"] isEqualToString:@"1"]) {
    //        self.nameTf.enabled = NO;
    //        self.selectHomeAddressBtn.enabled = NO;
    //        self.idCodeTf.enabled = NO;
    //    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UserModel *usermodel = [UserModel Instance];
    NSString *provinceStr = [usermodel getUserValueForKey:@"selectProvinceStr"];
    NSString *cityStr = [usermodel getUserValueForKey:@"selectCityStr"];
    NSString *regionStr = [usermodel getUserValueForKey:@"selectRegionStr"];
    NSString *communityStr = [usermodel getUserValueForKey:@"selectCommunityStr"];
    NSString *buildStr = [usermodel getUserValueForKey:@"selectBuildStr"];
    NSString *houseStr = [usermodel getUserValueForKey:@"selectHouseStr"];
    if([communityStr length] > 0 && [buildStr length] > 0 && [houseStr length] > 0)
    {
        self.homeAddressLb.text = [NSString stringWithFormat:@"%@%@%@", communityStr, buildStr, houseStr];
    }
    self.homeAddressLb.textColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectHomeAddressAction:(id)sender {
    ChooseAreaView *chooseView = [[ChooseAreaView alloc] init];
    chooseView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chooseView animated:YES];
}

- (IBAction)saveInfoAction:(id)sender {
    NSString *nicknameStr = self.nicknameTf.text;
    NSString *nameStr = self.nameTf.text;
    NSString *homeAddressStr = self.homeAddressLb.text;
    NSString *emailStr = self.emailTf.text;
    NSString *idcodeStr = self.idCodeTf.text;
    if (nicknameStr == nil || [nicknameStr length] == 0) {
        [Tool showCustomHUD:@"请填写昵称" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (nameStr == nil || [nameStr length] == 0) {
        [Tool showCustomHUD:@"请填写姓名" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([emailStr length] > 0 && ![emailStr isValidEmail]) {
        [Tool showCustomHUD:@"邮箱格式错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([idcodeStr length] > 0 && ![idcodeStr isValidIdCardNum]) {
        [Tool showCustomHUD:@"身份证格式错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.saveInfoBtn.enabled = NO;
    UserModel *usermodel = [UserModel Instance];
    NSString *regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_editinfo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:[usermodel getUserValueForKey:@"id"] forKey:@"id"];
    [request setPostValue:[usermodel getUserValueForKey:@"tel"] forKey:@"tel"];
    NSString * selectCommunityId = [usermodel getUserValueForKey:@"selectCommunityId"];
    NSString * selectBuildId = [usermodel getUserValueForKey:@"selectBuildId"];
    NSString * selectHouseStr = [usermodel getUserValueForKey:@"selectHouseStr"];
    if (![selectCommunityId isEqualToString:@""] && ![selectBuildId isEqualToString:@""] && ![selectHouseStr isEqualToString:@""]) {
        [request setPostValue:selectCommunityId forKey:@"cid"];
        [request setPostValue:selectBuildId forKey:@"build_id"];
        [request setPostValue:selectHouseStr forKey:@"house_number"];
    }
    else
    {
        [request setPostValue:[usermodel getUserValueForKey:@"cid"] forKey:@"cid"];
        [request setPostValue:[usermodel getUserValueForKey:@"build_id"] forKey:@"build_id"];
        [request setPostValue:[usermodel getUserValueForKey:@"house_number"] forKey:@"house_number"];
    }
    [request setPostValue:emailStr forKey:@"email"];
    [request setPostValue:idcodeStr forKey:@"card_id"];
    [request setPostValue:nameStr forKey:@"name"];
    [request setPostValue:nicknameStr forKey:@"nickname"];
    [request setPostValue:homeAddressStr forKey:@"address"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSaveInfo:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在提交" andView:self.view andHUD:request.hud];
}



- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}

- (void)requestSaveInfo:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:request.responseString
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    User *user = [Tool readJsonStrToUser:request.responseString];
    int errorCode = [user.status intValue];
    NSString *errorMessage = user.info;
    switch (errorCode) {
        case 1:
        {
            UserModel *userModel = [UserModel Instance];
            NSString * selectCommunityId = [userModel getUserValueForKey:@"selectCommunityId"];
            NSString * selectBuildId = [userModel getUserValueForKey:@"selectBuildId"];
            NSString * selectHouseStr = [userModel getUserValueForKey:@"selectHouseStr"];
            if (![selectCommunityId isEqualToString:@""] && ![selectBuildId isEqualToString:@""] && ![selectHouseStr isEqualToString:@""]) {
                [userModel saveValue:selectCommunityId ForKey:@"cid"];
                [userModel saveValue:selectBuildId ForKey:@"build_id"];
                [userModel saveValue:selectHouseStr ForKey:@"house_number"];
                [userModel saveValue:[userModel getUserValueForKey:@"selectCommunityStr"] ForKey:@"comm_name"];
                [userModel saveValue:[userModel getUserValueForKey:@"selectBuildStr"] ForKey:@"build_name"];
            }
            
            [userModel saveValue:self.nameTf.text ForKey:@"name"];
            [userModel saveValue:self.nicknameTf.text ForKey:@"nickname"];
            [userModel saveValue:self.homeAddressLb.text ForKey:@"address"];
            [userModel saveValue:self.emailTf.text ForKey:@"email"];
            [userModel saveValue:self.idCodeTf.text ForKey:@"card_id"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:errorMessage
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
            [av show];
            
            [userModel saveValue:nil ForKey:@"selectProvinceId"];
            [userModel saveValue:nil ForKey:@"selectProvinceStr"];
            [userModel saveValue:nil ForKey:@"selectCityId"];
            [userModel saveValue:nil ForKey:@"selectCityStr"];
            [userModel saveValue:nil ForKey:@"selectRegionId"];
            [userModel saveValue:nil ForKey:@"selectRegionStr"];
            [userModel saveValue:nil ForKey:@"selectCommunityId"];
            [userModel saveValue:nil ForKey:@"selectCommunityStr"];
            [userModel saveValue:nil ForKey:@"selectBuildId"];
            [userModel saveValue:nil ForKey:@"selectBuildStr"];
            [userModel saveValue:nil ForKey:@"selectHouseId"];
            [userModel saveValue:nil ForKey:@"selectHouseStr"];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
            self.saveInfoBtn.enabled = YES;
        }
            break;
    }
}

- (IBAction)uploadFaceAction:(id)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    faceEGOImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        NSString *updateUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_upload_avatar];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
        
        [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
        [request setPostValue:appkey forKey:@"APPKey"];
        [request setPostValue:[[UserModel Instance] getUserValueForKey:@"tel"] forKey:@"tel"];
        NSLog([[UserModel Instance] getUserValueForKey:@"tel"]);
        [request addData:UIImageJPEGRepresentation(editedImage, 0.75f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:@"portrait"];
        request.delegate = self;
        request.tag = 11;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestPortrait:)];
        [request startAsynchronous];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [Tool showHUD:@"头像上传" andView:self.view andHUD:request.hud];
    }];
}

- (void)requestPortrait:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    User *user = [Tool readJsonStrToUser:request.responseString];
    NSLog(request.responseString);
    int errorCode = [user.status intValue];
    switch (errorCode) {
        case 1:
        {
            [[UserModel Instance] saveValue:user.avatar ForKey:@"avatar"];
            [Tool showCustomHUD:user.info andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:1];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:user.info andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        }
            break;
    }
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                //使用前置摄像头
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
            
        } else if (buttonIndex == 1) {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
