//
//  Tool.h
//  oschina
//
//  Created by wangjun on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonCryptor.h>
#import "RMMapper.h"
#import <ShareSDK/ShareSDK.h>
#import "LoginView.h"
#import "RegisterView.h"
#import "SettingView.h"
#import "User.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "RegionModel.h"
#import "CommunityModel.h"
#import "BuildModel.h"
#import "HouseModel.h"
#import "Advertisement.h"
#import "News.h"
#import "RepairsCate.h"
#import "RepairsList.h"
#import "RepairsItem.h"
#import "PropertyFeeInfo.h"
#import "CarFeeInfo.h"
#import "AlipayInfo.h"
#import "OutExpress.h"
#import "Shop.h"
#import "ShopsCate.h"
#import "BusinessGoods.h"
#import "Coupons.h"
#import "Goods.h"
#import "OrdersNum.h"
#import "FeeHistory.h"
#import "Article.h"
#import "MyOrder.h"
#import "MyGoods.h"
#import "ResponseCode.h"
#import "Commercial.h"
#import "Citys.h"
#import "CityInfo.h"
#import "BBSModel.h"
#import "BBSReplyModel.h"

@interface Tool : NSObject

+ (UIAlertView *)getLoadingView:(NSString *)title andMessage:(NSString *)message;

+ (NSMutableArray *)getRelativeNews:(NSString *)request;
+ (NSString *)generateRelativeNewsString:(NSArray *)array;

+ (UIColor *)getColorForCell:(int)row;
+ (UIColor *)getColorForGreen;

+ (void)clearWebViewBackground:(UIWebView *)webView;

+ (void)doSound:(id)sender;

+ (NSString *)getBBSIndex:(int)index;

+ (void)toTableViewBottom:(UITableView *)tableView isBottom:(BOOL)isBottom;

+ (void)borderView:(UIView *)view;
+ (void)roundTextView:(UIView *)txtView andBorderWidth:(int)width andCornerRadius:(float)radius;
+ (void)roundView:(UIView *)view andCornerRadius:(float)radius;

+ (void)noticeLogin:(UIView *)view andDelegate:(id)delegate andTitle:(NSString *)title;

+ (void)processLoginNotice:(UIActionSheet *)actionSheet andButtonIndex:(NSInteger)buttonIndex andNav:(UINavigationController *)nav andParent:(UIViewController *)parent;

+ (NSString *)getCommentLoginNoticeByCatalog:(int)catalog;

+ (void)playAudio:(BOOL)isAlert;

+ (NSString *)intervalSinceNow: (NSString *) theDate;

+ (BOOL)isToday:(NSString *) theDate;

+ (int)getDaysCount:(int)year andMonth:(int)month andDay:(int)day;

+ (NSString *)getAppClientString:(int)appClient;

+ (void)ReleaseWebView:(UIWebView *)webView;

+ (int)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt;
+ (int)getTextHeight:(int)width andUIFont:(UIFont *)font andText:(NSString *)txt;

+ (UIColor *)getBackgroundColor;
+ (UIColor *)getCellBackgroundColor;

+ (BOOL)isValidateEmail:(NSString *)email;

+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str;
+ (NSString *)getCache:(int)type andID:(int)_id;

+ (void)deleteAllCache;

+ (NSString *)getHTMLString:(NSString *)html;

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;
+ (void)showCustomHUD:(NSString *)text andView:(UIView *)view andImage:(NSString *)image andAfterDelay:(int)second;

+ (UIImage *) scale:(UIImage *)sourceImg toSize:(CGSize)size;

+ (CGSize)scaleSize:(CGSize)sourceSize;

+ (NSString *)getOSVersion;

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;

+ (void)CancelRequest:(ASIFormDataRequest *)request;

+ (NSDate *)NSStringDateToNSDate:(NSString *)string;
//时间戳转指定格式时间字符串
+ (NSString *)TimestampToDateStr:(NSString *)timestamp andFormatterStr:(NSString *)formatter;

+ (NSString *)GenerateTags:(NSMutableArray *)tags;

+ (void)saveCache:(NSString *)catalog andType:(int)type andID:(int)_id andString:(NSString *)str;
+ (NSString *)getCache:(NSString *)catalog andType:(int)type andID:(int)_id;
//保留数值几位小数
+ (NSString *)notRounding:(float)price afterPoint:(int)position;
+ (void)shareAction:(UIButton *)sender andShowView:(UIView *)view andContent:(NSDictionary *)shareContent;

+ (NSString *)databasePath;
+ (void)pushToSettingView:(UINavigationController *)navigationController;
+ (void)pushToMyView:(UINavigationController *)navigationController;

+ (User *)readJsonStrToUser:(NSString *)str;
+ (AlipayInfo *)readJsonStrToAliPay:(NSString *)str;
+ (NSMutableArray *)readJsonStrToRegionArray:(NSString *)str;
+ (NSMutableArray *)readJsonStrToCommunityArray:(NSString *)str;
+ (NSMutableArray *)readJsonStrToCommunityArray2:(NSString *)str;
+ (NSMutableArray *)readJsonStrToADV:(NSString *)str;
+ (NSMutableArray *)readJsonStrToNews:(NSString *)str;
+ (NSMutableArray *)readJsonStrToRepairsCate:(NSString *)str;
+ (NSMutableArray *)readJsonStrToMyRepairs:(NSString *)str;
+ (NSMutableArray *)readJsonStrToRepairItems:(NSString *)str;
+ (PropertyFeeInfo *)readJsonStrToPropertyFeeInfo:(NSString *)str;
+ (NSMutableArray *)readJsonStrToPropertyCarFeeInfo:(NSString *)str;
+ (NSMutableArray *)readJsonStrToMyOutBox:(NSString *)str;
+ (NSMutableArray *)readJsonStrToShopArray:(NSString *)str;
+ (NSMutableArray *)readJsonStrToShopsCate:(NSString *)str;
+ (BusinessGoods *)readJsonStrBusinessGoods:(NSString *)str;
+ (OrdersNum *)readJsonStrToOrdersNum:(NSString *)str;
+ (Goods *)readJsonStrToGoodsInfo:(NSString *)str;
+ (Coupons *)readJsonStrToCouponDetail:(NSString *)str;
+ (NSMutableArray *)readJsonStrToGoodsArray:(NSString *)str;
+ (Shop *)readJsonStrToShopInfo:(NSString *)str;
+ (NSMutableArray *)readJsonStrToFeeHistory:(NSString *)str;
+ (NSMutableArray *)readJsonStrToMyOrder:(NSString *)str;
+ (ResponseCode *)readJsonStrToResponseCode:(NSString *)str;
+ (NSMutableArray *)readJsonStrToArticleArray:(NSString *)str;
+ (NSMutableArray *)readJsonStrToCommercials:(NSString *)str;
+ (NSMutableArray *)readJsonStrToCitys:(NSString *)str;
+ (CityInfo *)readJsonStrToCityInfo:(NSString *)str;
+ (NSMutableArray *)readJsonStrToBBSArray:(NSString *)str;

@end
