//
//  WuLiuWebViewController.m
//  MenYa
//
//  Created by 李冬强 on 15/12/12.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "WuLiuWebViewController.h"

@interface WuLiuWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webVIew;

@end

@implementation WuLiuWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"物流信息";
    _webVIew.delegate = self;
    //查看物流 http://m.kuaidi100.com/index_all.html?type=全峰&postid=123456
    NSString *url = [NSString stringWithFormat:@"%@type=%@&poistid=%@",kBaseUrl,_express_company,_waybill_code];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webVIew loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    kSVPShowWithText(@"加载中");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    kSVPDismiss;
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
