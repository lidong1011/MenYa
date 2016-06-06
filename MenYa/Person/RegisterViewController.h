//
//  RegisterViewController.h
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *yanZhengMTF;
@property (weak, nonatomic) IBOutlet UIButton *yanZhengBtn;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *paswordTF;
@end
