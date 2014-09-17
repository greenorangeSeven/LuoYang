//
//  NewsDetailView.h
//  BeautyLife
//
//  Created by Seven on 14-8-15.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailView : UIViewController<UIActionSheetDelegate>
{
    UIWebView *phoneCallWebView;
}

@property (weak, nonatomic) News *news;
@property int catalog;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *pointsBtn;
@property (weak, nonatomic) IBOutlet UIButton *baomingBtn;

- (IBAction)pointsAction:(id)sender;
- (IBAction)baoming:(id)sender;
- (IBAction)telAction:(id)sender;

@end
