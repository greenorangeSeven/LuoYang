//
//  ArticleDetailView.h
//  NanNIng
//
//  Created by Seven on 14-9-4.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolnDetailView : UIViewController<UIActionSheetDelegate>
{
    MBProgressHUD *hud;
}

@property (weak, nonatomic) Citys *art;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
