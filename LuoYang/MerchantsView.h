//
//  MerchantsView.h
//  LuoYang
//
//  Created by Seven on 14-10-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantsView : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTf;
@property (weak, nonatomic) IBOutlet UITextField *companyProductTf;
@property (weak, nonatomic) IBOutlet UITextField *contactsTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextView *remarkTv;
- (IBAction)submitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
