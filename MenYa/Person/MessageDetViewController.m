//
//  MessageDetViewController.m
//  MenYa
//
//  Created by 李冬强 on 15/10/29.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "MessageDetViewController.h"

@interface MessageDetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *content;

@end

@implementation MessageDetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = _model.title;
    _content.text = _model.content;
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
