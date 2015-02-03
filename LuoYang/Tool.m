//
//  Tool.m
//  oschina
//
//  Created by wangjun on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tool.h"
@implementation Tool

+ (UIAlertView *)getLoadingView:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(121, 80, 37, 37);
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

+ (NSString *)getBBSIndex:(int)index
{
    if (index < 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%d楼", index+1];
}

+ (void)toTableViewBottom:(UITableView *)tableView isBottom:(BOOL)isBottom
{
    if (isBottom) {
        NSUInteger sectionCount = [tableView numberOfSections];
        if (sectionCount) {
            NSUInteger rowCount = [tableView numberOfRowsInSection:0];
            if (rowCount) {
                NSUInteger ii[2] = {0, rowCount - 1};
                NSIndexPath * indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:isBottom ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop animated:YES];
            }
        }
    }
    else
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

+ (NSString *)getCommentLoginNoticeByCatalog:(int)catalog
{
    switch (catalog) {
        case 1:
        case 3:
            return @"请先登录后发表评论";
        case 2:
            return @"请先登录后再回帖或评论";
        case 4:
            return @"请先登录后发留言";
    }
    return @"请先登录后发表评论";
}

+ (void)borderView:(UIView *)view
{
    view.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] CGColor];
    view.layer.borderWidth = 1;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

+ (void)roundTextView:(UIView *)txtView andBorderWidth:(int)width andCornerRadius:(float)radius
{
    txtView.layer.borderColor = [[UIColor colorWithRed:202.0/255.0 green:204.0/255.0 blue:205.0/255.0 alpha:1.0] CGColor];
    txtView.layer.borderWidth = width;
    txtView.layer.cornerRadius = radius;
    txtView.layer.masksToBounds = YES;
    txtView.clipsToBounds = YES;
}

+ (void)roundView:(UIView *)view andCornerRadius:(float)radius
{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

+ (void)playAudio:(BOOL)isAlert
{
    NSString * path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath], isAlert ? @"/alertsound.wav" : @"/soundeffect.wav"];
    SystemSoundID soundID;
    NSURL * filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

+ (UIColor *)getColorForCell:(int)row
{
    return row % 2 ?
    [UIColor colorWithRed:235.0/255.0 green:242.0/255.0 blue:252.0/255.0 alpha:1.0]:
    [UIColor colorWithRed:248.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
}

+ (UIColor *)getColorForGreen
{
    return [UIColor colorWithRed:18.0/255 green:144.0/255 blue:2.0/255 alpha:1.0];
}

+ (void)clearWebViewBackground:(UIWebView *)webView
{
    UIWebView *web = webView;
    for (id v in web.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            [v setBounces:NO];
        }
    }
}

+ (void)doSound:(id)sender
{
    NSError *err;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"soundeffect" ofType:@"wav"]] error:&err];
    player.volume = 1;
    player.numberOfLoops = 1;
    [player prepareToPlay];
    [player play];
}

+ (NSString *)getAppClientString:(int)appClient
{
    switch (appClient) {
        case 1:
            return @"";
        case 2:
            return @"来自手机";
        case 3:
            return @"来自手机";
        case 4:
            return @"来自iPhone";
        case 5:
            return @"来自手机";
        default:
            return @"";
    }
}

+ (void)ReleaseWebView:(UIWebView *)webView
{
    [webView stopLoading];
    [webView setDelegate:nil];
    webView = nil;
}

+ (void)noticeLogin:(UIView *)view andDelegate:(id)delegate andTitle:(NSString *)title
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请先登录或注册" delegate:delegate cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"登录", @"注册", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}
+ (void)processLoginNotice:(UIActionSheet *)actionSheet andButtonIndex:(NSInteger)buttonIndex andNav:(UINavigationController *)nav andParent:(UIViewController *)parent
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"登录"]) {
        LoginView *loginView = [[LoginView alloc] init];
        [nav pushViewController:loginView animated:YES];
    }
    else if([buttonTitle isEqualToString:@"注册"])
    {
        RegisterView *regView = [[RegisterView alloc] init];
        [nav pushViewController:regView animated:YES];
    }
}

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray *array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
    }
    return timeString;
}

+ (BOOL)isToday:(NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    
    if (cha/86400<1) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(int)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt
{
    float fPadding = 16.0;
    CGSize constraint = CGSizeMake(txtView.contentSize.width - 10 - fPadding, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height + 16.0;
    return fHeight;
}

+(int)getTextHeight:(int)width andUIFont:(UIFont *)font andText:(NSString *)txt
{
    float fPadding = 16.0;
    CGSize constraint = CGSizeMake(width - 10 - fPadding, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height + 16.0;
    return fHeight;
}

+ (int)getDaysCount:(int)year andMonth:(int)month andDay:(int)day
{
    return year*365 + month * 31 + day;
}

+ (UIColor *)getBackgroundColor
{
//    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"fb_bg.jpg"]];
    return [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
}
+ (UIColor *)getCellBackgroundColor
{
    return [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
}

+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}
+ (NSString *)getCache:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}

+ (void)deleteAllCache
{
}

+ (NSString *)getHTMLString:(NSString *)html
{
    return html;
}
+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;
    //    hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
}

+ (void)showCustomHUD:(NSString *)text andView:(UIView *)view andImage:(NSString *)image andAfterDelay:(int)second
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    [HUD show:YES];
    [HUD hide:YES afterDelay:second];
}

+ (UIImage *)scale:(UIImage *)sourceImg toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [sourceImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (CGSize)scaleSize:(CGSize)sourceSize
{
    float width = sourceSize.width;
    float height = sourceSize.height;
    if (width >= height) {
        return CGSizeMake(800, 800 * height / width);
    }
    else
    {
        return CGSizeMake(800 * width / height, 800);
    }
}

+ (NSString *)getOSVersion
{
    return [NSString stringWithFormat:@"GreenOrange.com/%@/%@/%@/%@",AppVersion,[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion, [UIDevice currentDevice].model];
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    [notificationView hideAnimatedAfter:2.6];
}
+ (void)CancelRequest:(ASIHTTPRequest *)request
{
    if (request != nil) {
        [request cancel];
        [request clearDelegatesAndCancel];
    }
}
+ (NSDate *)NSStringDateToNSDate:(NSString *)string
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * d = [f dateFromString:string];
    return d;
}

+ (NSString *)TimestampToDateStr:(NSString *)timestamp andFormatterStr:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]];
    return [dateFormatter stringFromDate:confromTimesp];
}

+ (NSString *)GenerateTags:(NSMutableArray *)tags
{
    if (tags == nil || tags.count == 0) {
        return @"";
    }
    else
    {
        NSString *result = @"";
        for (NSString *t in tags) {
            result = [NSString stringWithFormat:@"%@<a style='background-color: #BBD6F3;border-bottom: 1px solid #3E6D8E;border-right: 1px solid #7F9FB6;color: #284A7B;font-size: 12pt;-webkit-text-size-adjust: none;line-height: 2.4;margin: 2px 2px 2px 0;padding: 2px 4px;text-decoration: none;white-space: nowrap;' href='http://www.oschina.net/question/tag/%@' >&nbsp;%@&nbsp;</a>&nbsp;&nbsp;",result,t,t];
        }
        return result;
    }
}

+ (void)saveCache:(NSString *)catalog andType:(int)type andID:(int)_id andString:(NSString *)str
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"%@-%d-%d",catalog,type, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}
+ (NSString *)getCache:(NSString *)catalog andType:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-%d-%d",catalog,type, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}

+ (NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

//过滤HTML标签
+ (NSString *)flattenHTML:(NSString *)html {
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}

+ (BOOL)testAlipayInstall
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        NSLog(@"支付宝install--");
        return YES;
    }else{
        NSLog(@"支付宝no---");
        return NO;
    }
}

+ (BOOL)testWeiXinInstall
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        NSLog(@"微信install--");
        return YES;
    }else{
        NSLog(@"微信no---");
        return NO;
    }
}

+ (void)shareAction:(UIButton *)sender andShowView:(UIView *)view andContent:(NSDictionary *)shareContent {
//    Activity *activity = [[Activity alloc] init];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[shareContent objectForKey:@"summary"]
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:[shareContent objectForKey:@"thumb"]]
                                                title:[shareContent objectForKey:@"title"]
                                                  url:@"http://www.hngsntwy.com"
                                          description:[shareContent objectForKey:@"summary"]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
    //                                                         allowCallback:YES
    //                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
    //                                                          viewDelegate:nil
    //                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    //    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ChellonaCar"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ChellonaCar"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
    //                                    nil]];
    
    //自定义新浪微博分享菜单项
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          [ShareSDK shareContent:publishContent
                                                                                            type:ShareTypeSinaWeibo
                                                                                     authOptions:nil
                                                                                   statusBarTips:NO
                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                              
                                                                                              if (state == SSPublishContentStateSuccess)
                                                                                              {
                                                                                                  [self showCustomHUD:@"分享成功" andView:view andImage:@"37x-Checkmark.png" andAfterDelay:1];
                                                                                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                                                              }
                                                                                              else if (state == SSPublishContentStateFail)
                                                                                              {
                                                                                                  [self showCustomHUD:@"分享失败" andView:view andImage:@"37x-Failure.png" andAfterDelay:1];
                                                                                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                                                              }
                                                                                          }];
                                                                      }];
    
    //自定义腾讯微博分享菜单项
    id<ISSShareActionSheetItem> tencentItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo]
                                                                                 icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                                                         clickHandler:^{
                                                                             [ShareSDK shareContent:publishContent
                                                                                               type:ShareTypeTencentWeibo
                                                                                        authOptions:nil
                                                                                      statusBarTips:NO
                                                                                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                 
                                                                                                 if (state == SSPublishContentStateSuccess)
                                                                                                 {
                                                                                                     [self showCustomHUD:@"分享成功" andView:view andImage:@"37x-Checkmark.png" andAfterDelay:1];
                                                                                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                                                                 }
                                                                                                 else if (state == SSPublishContentStateFail)
                                                                                                 {
                                                                                                     [self showCustomHUD:@"分享失败" andView:view andImage:@"37x-Failure.png" andAfterDelay:1];
                                                                                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                                                                 }
                                                                                             }];
                                                                         }];
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
//                          sinaItem,
                          tencentItem,
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          nil];
    
    
    
    NSArray *oneKeyShareList = [ShareSDK getShareListWithType:
//                                ShareTypeSinaWeibo,
                                ShareTypeTencentWeibo,
                                ShareTypeWeixiFav,
                                nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil      //分享视图标题
                                                              oneKeyShareList:oneKeyShareList           //一键分享菜单
                                                               qqButtonHidden:NO                               //QQ分享按钮是否隐藏
                                                        wxSessionButtonHidden:YES                   //微信好友分享按钮是否隐藏
                                                       wxTimelineButtonHidden:NO                 //微信朋友圈分享按钮是否隐藏
                                                         showKeyboardOnAppear:NO                  //是否显示键盘
                                                            shareViewDelegate:nil                            //分享视图委托
                                                          friendsViewDelegate:nil                          //好友视图委托
                                                        picViewerViewDelegate:nil];                    //图片浏览视图委托
    
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:nil
                      shareOptions:shareOptions                    //传入分享选项对象
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [self showCustomHUD:@"分享成功" andView:view andImage:@"37x-Checkmark.png" andAfterDelay:1];
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    [self showCustomHUD:@"分享失败" andView:view andImage:@"37x-Failure.png" andAfterDelay:1];
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

+ (NSString* )databasePath
{
    NSString* path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dbPath=[path stringByAppendingPathComponent:@"beautylife.db"];
    return dbPath;
}

+ (void)pushToSettingView:(UINavigationController *)navigationController
{
    SettingView *settingView = [[SettingView alloc] init];
    settingView.hidesBottomBarWhenPushed = YES;
    settingView.typeView = @"setting";
    [navigationController pushViewController:settingView animated:YES];
}

+ (void)pushToMyView:(UINavigationController *)navigationController
{
    SettingView *settingView = [[SettingView alloc] init];
    settingView.hidesBottomBarWhenPushed = YES;
    settingView.typeView = @"my";
    [navigationController pushViewController:settingView animated:YES];
}

+ (User *)readJsonStrToUser:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *detailDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( detailDic == nil) {
        return nil;
    }
    User *user = [RMMapper objectWithClass:[User class] fromDictionary:detailDic];
    return user;
}

+ (CityInfo *)readJsonStrToCityInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *detailDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( detailDic == nil) {
        return nil;
    }
    CityInfo *info = [RMMapper objectWithClass:[CityInfo class] fromDictionary:detailDic];
    return info;
}

+ (OrdersNum *)readJsonStrToOrdersNum:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *detailDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( detailDic == nil) {
        return nil;
    }
    OrdersNum *num = [RMMapper objectWithClass:[OrdersNum class] fromDictionary:detailDic];
    return num;
}

+ (NSMutableArray *)readJsonStrToVolnArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *volnJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( volnJsonArray == nil || [volnJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *volnArray = [RMMapper mutableArrayOfClass:[Voln class] fromArrayOfDictionary:volnJsonArray];
    for (Voln *v in volnArray) {
        v.cause = [NSString stringWithFormat:@"加入理由:%@", v.cause];
        v.causeHeight = [self getTextHeight:287 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:v.cause];
    }
    return volnArray;
}

+ (NSMutableArray *)readJsonStrToCouponArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *conponJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( conponJsonArray == nil || [conponJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *myArray = [RMMapper mutableArrayOfClass:[Coupons class] fromArrayOfDictionary:conponJsonArray];
    for (Coupons *c in myArray) {
        c.validityStr = [Tool intervalSinceNow:[Tool TimestampToDateStr:c.validity_date andFormatterStr:@"yyyy-MM-dd"]];
    }
    return myArray;
}

+ (NSMutableArray *)readJsonStrToMyCouponArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *conponJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( conponJsonArray == nil || [conponJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *myArray = [RMMapper mutableArrayOfClass:[Coupons class] fromArrayOfDictionary:conponJsonArray];
    NSMutableArray *myArray2 = [[NSMutableArray alloc] init];
    for (Coupons *c in myArray) {
        if ([c.status isEqualToString:@"0"]) {
            c.validityStr = [Tool intervalSinceNow:[Tool TimestampToDateStr:c.validity_date andFormatterStr:@"yyyy-MM-dd"]];
            [myArray2 addObject:c];
        }
    }
    myArray = nil;
    return myArray2;
}

+ (NSMutableArray *)readJsonStrToMyComplainArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *conponJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( conponJsonArray == nil || [conponJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *myArray = [RMMapper mutableArrayOfClass:[Complain class] fromArrayOfDictionary:conponJsonArray];
    for (Complain *c in myArray) {
        c.addtimeStr = [Tool intervalSinceNow:[Tool TimestampToDateStr:c.addtime andFormatterStr:@"yyyy年MM月dd日 HH:mm"]];
        c.replytimeStr = [Tool intervalSinceNow:[Tool TimestampToDateStr:c.reply_time andFormatterStr:@"yyyy年MM月dd日 HH:mm"]];
    }
    return myArray;
}

+ (AlipayInfo *)readJsonStrToAliPay:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *detailDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( detailDic == nil) {
        return nil;
    }
    AlipayInfo *alipay = [RMMapper objectWithClass:[AlipayInfo class] fromDictionary:detailDic];
    return alipay;
}

+ (NSMutableArray *)readJsonStrToRegionArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *areaArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( [areaArray count] <= 0) {
        return nil;
    }
    NSMutableArray *provinceArray;
    if ([areaArray count] >= 1) {
        NSDictionary *areaDic = [areaArray objectAtIndex:0];
        id areaJSON = [areaDic objectForKey:@"_child"];
        provinceArray = [RMMapper mutableArrayOfClass:[ProvinceModel class]
                                                fromArrayOfDictionary:areaJSON];
        for (ProvinceModel *p in provinceArray) {
            NSMutableArray *cityArray = [RMMapper mutableArrayOfClass:[CityModel class]
                                                fromArrayOfDictionary:p._child];
            for (CityModel *c in cityArray) {
                NSMutableArray *regionArray = [RMMapper mutableArrayOfClass:[RegionModel class]
                                                    fromArrayOfDictionary:c._child];
                c.regionArray = regionArray;
            }
            p.cityArray = cityArray;
        }
    }
    return provinceArray;
}

+ (NSMutableArray *)readJsonStrToCommunityArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *commJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( [commJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *commArray = [RMMapper mutableArrayOfClass:[CommunityModel class]
                                fromArrayOfDictionary:commJsonArray];
        for (CommunityModel *c in commArray) {
            NSMutableArray *buildArray = [RMMapper mutableArrayOfClass:[BuildModel class]
                                                fromArrayOfDictionary:c.build_list];
            for (BuildModel *b in buildArray) {
                if ([b.house_list isKindOfClass:[NSArray class]]) {
                    NSMutableArray *houseArray = [RMMapper mutableArrayOfClass:[HouseModel class]
                                                         fromArrayOfDictionary:b.house_list];
                    b.houseArray = houseArray;
                }
                
            }
            c.buildArray = buildArray;
        }

    return commArray;
}

+ (NSMutableArray *)readJsonStrToCommunityArray2:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *commJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( [commJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *commArray = [RMMapper mutableArrayOfClass:[CommunityModel class]
                                        fromArrayOfDictionary:commJsonArray];
    return commArray;
}

+ (NSMutableArray *)readJsonStrToADV:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *advJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( advJsonArray == nil || [advJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *advs = [RMMapper mutableArrayOfClass:[Advertisement class] fromArrayOfDictionary:advJsonArray];
    return advs;
}

+ (NSMutableArray *)readJsonStrToNews:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *newsJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( newsJsonArray == nil || [newsJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *newsArray = [RMMapper mutableArrayOfClass:[News class] fromArrayOfDictionary:newsJsonArray];
    return newsArray;
}

+ (NSMutableArray *)readJsonStrToRepairsCate:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *cateJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( cateJsonArray == nil || [cateJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *cateArray = [RMMapper mutableArrayOfClass:[RepairsCate class] fromArrayOfDictionary:cateJsonArray];
    return cateArray;
}

+ (NSMutableArray *)readJsonStrToMyRepairs:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *myJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( myJsonArray == nil || [myJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *myArray = [RMMapper mutableArrayOfClass:[RepairsList class] fromArrayOfDictionary:myJsonArray];
    return myArray;
}

+ (NSMutableArray *)readJsonStrToRepairItems:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *itemJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( itemJsonArray == nil || [itemJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *itemArray = [RMMapper mutableArrayOfClass:[RepairsItem class] fromArrayOfDictionary:itemJsonArray];
    return itemArray;
}

+ (PropertyFeeInfo *)readJsonStrToPropertyFeeInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *feeJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( feeJsondDic == nil ) {
        return nil;
    }
    PropertyFeeInfo *feeInfo = [RMMapper objectWithClass:[PropertyFeeInfo class] fromDictionary:feeJsondDic];
    return feeInfo;
}

+ (NSMutableArray *)readJsonStrToPropertyCarFeeInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *feeJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( feeJsonArray == nil || [feeJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *feeInfoArray = [RMMapper mutableArrayOfClass:[CarFeeInfo class] fromArrayOfDictionary:feeJsonArray];
    return feeInfoArray;
}

+ (NSMutableArray *)readJsonStrToMyOutBox:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *myJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( myJsonArray == nil || [myJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *myArray = [RMMapper mutableArrayOfClass:[OutExpress class] fromArrayOfDictionary:myJsonArray];
    return myArray;
}

+ (NSMutableArray *)readJsonStrToShopArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *shopJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( shopJsonArray == nil || [shopJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *shops = [RMMapper mutableArrayOfClass:[Shop class] fromArrayOfDictionary:shopJsonArray];
    return shops;
}

+ (NSMutableArray *)readJsonStrToShopsCate:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *cateJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( cateJsonArray == nil || [cateJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *shops = [RMMapper mutableArrayOfClass:[ShopsCate class] fromArrayOfDictionary:cateJsonArray];
    return shops;
}

#pragma mark 将缴费历史记录转换为bean
+ (NSMutableArray *)readJsonStrToFeeHistory:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *cateJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( cateJsonArray == nil || [cateJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *feeHistorys = [RMMapper mutableArrayOfClass:[FeeHistory class] fromArrayOfDictionary:cateJsonArray];
    return feeHistorys;
}


+ (BusinessGoods *)readJsonStrBusinessGoods:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *businessGoodsDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BusinessGoods *businessGoods = [[BusinessGoods alloc] init] ;
    if ([NSNull null] == businessGoodsDic) {
        return nil;
    }
    if([NSNull null] != [businessGoodsDic objectForKey:@"coupons"]) {
        id couponsJSON = [businessGoodsDic objectForKey:@"coupons"];
        NSMutableArray *coupons = [RMMapper mutableArrayOfClass:[Coupons class]
                                          fromArrayOfDictionary:couponsJSON];
        businessGoods.coupons = coupons;
    }
    if([NSNull null] != [businessGoodsDic objectForKey:@"goodlist"]) {
        id goodsJSON = [businessGoodsDic objectForKey:@"goodlist"];
        NSMutableArray *goods = [RMMapper mutableArrayOfClass:[Goods class]
                                        fromArrayOfDictionary:goodsJSON];
        businessGoods.goodlist = goods;
    }
    return businessGoods;
}

+ (Goods *)readJsonStrToGoodsInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *goodJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( goodJsondDic == nil ) {
        return nil;
    }
    Goods *goodInfo = [RMMapper objectWithClass:[Goods class] fromDictionary:goodJsondDic];
    if ([goodInfo.attrs count] > 0) {
        NSMutableArray *goodsAttrs = [RMMapper mutableArrayOfClass:[GoodsAttrs class]
                                             fromArrayOfDictionary:[goodJsondDic objectForKey:@"attrs"]];
        goodInfo.attrsArray = goodsAttrs;
    }
    return goodInfo;
}

+ (Coupons *)readJsonStrToCouponDetail:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *detailDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( detailDic == nil) {
        return nil;
    }
    Coupons *detail = [RMMapper objectWithClass:[Coupons class] fromDictionary:detailDic];
    return detail;
}

+ (NSMutableArray *)readJsonStrToGoodsArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *goodsJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( goodsJsonArray == nil || [goodsJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *goods = [RMMapper mutableArrayOfClass:[Goods class] fromArrayOfDictionary:goodsJsonArray];
    return goods;
}

+ (NSMutableArray *)readJsonStrToMyOrder:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *orderJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( orderJsonArray == nil || [orderJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *orders = [RMMapper mutableArrayOfClass:[MyOrder class] fromArrayOfDictionary:orderJsonArray];
    NSMutableArray *orders2 = [[NSMutableArray alloc] init];
    for (MyOrder *o in orders)
    {
        if (![o.status isEqualToString:@"交易已取消"]) {
            NSMutableArray *goodsArray = [RMMapper mutableArrayOfClass:[MyGoods class]
                                                 fromArrayOfDictionary:o.goodlist];
            o.goodArray = goodsArray;
            [orders2 addObject:o];
        }
        
    }
    return orders2;
}

+ (ResponseCode *)readJsonStrToResponseCode:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *detailDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( detailDic == nil) {
        return nil;
    }
    ResponseCode *responseCode = [RMMapper objectWithClass:[ResponseCode class] fromDictionary:detailDic];
    return responseCode;
}

+ (Shop *)readJsonStrToShopInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *shopJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( shopJsondDic == nil ) {
        return nil;
    }
    Shop *shopInfo = [RMMapper objectWithClass:[Shop class] fromDictionary:shopJsondDic];
    return shopInfo;
}

+ (NSMutableArray *)readJsonStrToArticleArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *artJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( artJsonArray == nil || [artJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *arts = [RMMapper mutableArrayOfClass:[Article class] fromArrayOfDictionary:artJsonArray];
    return arts;
}

+ (NSMutableArray *)readJsonStrToCommercials:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *commercialJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( commercialJsonArray == nil || [commercialJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *commercialArray = [RMMapper mutableArrayOfClass:[Commercial class] fromArrayOfDictionary:commercialJsonArray];
    return commercialArray;
}

+ (NSMutableArray *)readJsonStrToCitys:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *cityJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( cityJsonArray == nil || [cityJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *cityArray = [RMMapper mutableArrayOfClass:[Citys class] fromArrayOfDictionary:cityJsonArray];
    return cityArray;
}

+ (NSMutableArray *)readJsonStrToBBSArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *bbsJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( bbsJsonArray == nil || [bbsJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *bbsArray = [RMMapper mutableArrayOfClass:[BBSModel class] fromArrayOfDictionary:bbsJsonArray];
    for (BBSModel *o in bbsArray)
    {
        NSMutableArray *reply_Array = [RMMapper mutableArrayOfClass:[BBSReplyModel class]
                                             fromArrayOfDictionary:o.reply_list];
        NSMutableString *ms = [[NSMutableString alloc] init];
        for (BBSReplyModel *r in reply_Array)
        {
            NSString *rname = @"匿名用户:";
            if ([r.nickname isEqualToString:@""] == NO)
            {
                rname = [NSString stringWithFormat:@"%@:", r.nickname];
            }
            else if ([r.name isEqualToString:@""] == NO)
            {
                rname = [NSString stringWithFormat:@"%@:", r.name];
            }
            NSString *rcontent = [NSString stringWithFormat:@"%@%@\n", rname, r.reply_content];
            [ms appendString:rcontent];
        }
        o.timeStr = [Tool intervalSinceNow:[Tool TimestampToDateStr:o.addtime andFormatterStr:@"yyyy-MM-dd HH:mm:ss"]];
        o.replyArray = reply_Array;
        o.contentHeight = [self getTextHeight:253 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:o.content];
        o.replysStr = ms;
        o.replyHeight = [self getTextHeight:253 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:ms];
    }
    return bbsArray;
}

+ (void)saveJsonStrToCommunityTel:(NSString *)cid
{
    NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_getcinfo, appkey, cid];
    NSURL *url = [ NSURL URLWithString : detailUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSData *data = [[request responseString ] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *communityJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( communityJsondDic == nil ) {
        return ;
    }
    CommunityModel *communityMInfo = [RMMapper objectWithClass:[CommunityModel class] fromDictionary:communityJsondDic];
    if (communityMInfo.tel != nil && [communityMInfo.tel length] > 0) {
        [[UserModel Instance] saveValue:communityMInfo.tel ForKey:@"CommunityTel"];
    }
}

+ (NSMutableArray *)readJsonStrToLinksArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *linkJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( linkJsonArray == nil || [linkJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *linkArray = [RMMapper mutableArrayOfClass:[OnlineLink class] fromArrayOfDictionary:linkJsonArray];
    return linkArray;
}

@end
