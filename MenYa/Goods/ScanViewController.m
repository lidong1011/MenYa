//
//  ScanViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/15.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "ScanViewController.h"
#import "HelpViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LeftViewController.h"
#import "GoodsViewController.h"
#import "CustNavigationViewController.h"
#import "MMDrawerController.h"
static const CGFloat kBorderW = 60;
static const CGFloat kMargin = 15;

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, weak) UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *leadView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
ASSIGN_NONATOMIC_PROPERTY NSInteger flag;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(help)];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMiss)]];
    self.view.clipsToBounds = YES;
    
//    [self setupMaskView];

//    [self setupBottomBar];
    
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)help
{
    HelpViewController *vc = [[HelpViewController alloc]init];
    [self.navigationController pushViewController:vc  animated:YES];
}

- (void)setupMaskView
{
    UIView *mask = [[UIView alloc] init];
    _maskView = mask;
    
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    mask.layer.borderWidth = kBorderW;
    
    mask.bounds = CGRectMake(0, 0, kWidth + kBorderW + kMargin * 2, kHeight * 0.9);
    mask.center = CGPointMake(kWidth * 0.5, kHeight * 0.5);
    mask.top = 0;
    
    [self.view addSubview:mask];
}

- (void)setupBottomBar
{
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight * 0.9, self.view.width, kHeight * 0.1)];
    bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:bottomBar];
}

- (void)setupScanWindowView
{
    CGFloat scanWindowH = kWScare(182);
    UIImageView *scanWindow = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth-scanWindowH)/2 , 60, scanWindowH, scanWindowH)];
    scanWindow.clipsToBounds = YES;
    scanWindow.image = [UIImage imageNamed:@"scan_kuang.png"];
    [self.view addSubview:scanWindow];
    
    CGFloat scanNetImageViewH = 8;
    CGFloat scanNetImageViewW = scanWindow.width;
    UIImageView *scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanLine.png"]];
    scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanWindowH, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(scanWindowH);
    scanNetAnimation.duration = 2.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    
//    CGFloat buttonWH = 18;
//    
//    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
//    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
//    [scanWindow addSubview:topLeft];
//    
//    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindowW - buttonWH, 0, buttonWH, buttonWH)];
//    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
//    [scanWindow addSubview:topRight];
//    
//    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH, buttonWH, buttonWH)];
//    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
//    [scanWindow addSubview:bottomLeft];
//    
//    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.right, bottomLeft.top, buttonWH, buttonWH)];
//    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
//    [scanWindow addSubview:bottomRight];
}

- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest = CGRectMake(0.1, 0, 0.9, 1);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:metadataObject.stringValue delegate:self cancelButtonTitle:@"确认扫描" otherButtonTitles:@"再次扫描", nil];
        [alert show];
    }
}

- (void)disMiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (!parent) {
        self.navigationController.navigationBar.hidden = NO;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self gotShouJi];
    } else if (buttonIndex == 1) {
        [_session startRunning];
    }
}

- (void)gotShouJi
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"shjid"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"SHJNAME"];
//    [[NSUserDefaults standardUserDefaults]setObject:model.userid forKey:@"SHJICON"];
    GoodsViewController *goodsVC = [[GoodsViewController alloc]init];
    goodsVC.machineid = @"1";
    CustNavigationViewController *goodsNVC = [[CustNavigationViewController alloc]initWithRootViewController:goodsVC];
    
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    //    CustNavigationViewController *leftDrawer = [[CustNavigationViewController alloc]initWithRootViewController:leftVC];
    
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:goodsNVC
                                             leftDrawerViewController:leftVC
                                             rightDrawerViewController:nil];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setMaximumLeftDrawerWidth:(150)];
    //    [drawerController setShowsShadow:NO];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self presentViewController:drawerController animated:YES completion:nil];
}

- (IBAction)leadBtnAction:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        _leadView.hidden = YES;
        [self setupScanWindowView];
        
        [self beginScanning];
    }
    else
    {
        if (_flag++ == 2) {
            _leadView.hidden = YES;
            [self setupScanWindowView];
            
            [self beginScanning];
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
