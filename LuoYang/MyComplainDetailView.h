//
//  MyComplainDetailView.h
//  LuoYang
//
//  Created by Seven on 14-10-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Complain.h"

@interface MyComplainDetailView : UIViewController

@property (weak, nonatomic) Complain *complain;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
