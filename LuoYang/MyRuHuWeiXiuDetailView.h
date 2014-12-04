//
//  MyRuHuWeiXiuDetailView.h
//  LuoYang
//
//  Created by Seven on 14-11-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Complain.h"

@interface MyRuHuWeiXiuDetailView : UIViewController

@property (weak, nonatomic) Complain *complain;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
