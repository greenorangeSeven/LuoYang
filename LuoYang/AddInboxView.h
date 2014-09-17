//
//  AddInboxView.h
//  BeautyLife
//
//  Created by Seven on 14-8-20.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInboxView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate>
{
    NSArray *expComData;
    NSString *expComName;
    NSString *expComCode;
    
    NSArray *typeData;
    NSString *typeStr;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *expComBtn;
@property (weak, nonatomic) IBOutlet UITextField *expNumLb;
@property (weak, nonatomic) IBOutlet UIButton *expTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *telBg;

- (IBAction)expComAction:(id)sender;
- (IBAction)expTypeAction:(id)sender;
- (IBAction)addAction:(id)sender;

@end
