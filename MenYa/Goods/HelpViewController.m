//
//  HelpViewController.m
//  MenYa
//
//  Created by 李冬强 on 15/11/23.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet UIView *leadView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
ASSIGN_NONATOMIC_PROPERTY NSInteger flag;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助信息";
}

- (IBAction)leadBtnAction:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        _leadView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (_flag++ == 2) {
            _leadView.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
        _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"scanLead%d",_flag+1]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
