//
//  BBSPostedView.h
//  NanNIng
//
//  Created by Seven on 14-9-14.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSPostedView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImage *picimage;
}

@property (weak, nonatomic) NSString *cid;

@property (weak, nonatomic) IBOutlet UITextView *contentTv;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
- (IBAction)photoAction:(id)sender;

@end
