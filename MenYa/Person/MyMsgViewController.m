//
//  MyMsgViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "MyMsgViewController.h"
#import "MyAddressViewController.h"
#import "MessageViewController.h"
#import "OrderViewController.h"
//#import "GoodsViewController.h"
#import "CustNavigationViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface MyMsgViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myIcon;
@property (weak, nonatomic) IBOutlet UILabel *myNum;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSString *iconString;
@end

@implementation MyMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"我";
    _myIcon.layer.cornerRadius = 30;
    _myIcon.clipsToBounds = YES;
    [self initData];
    [self addView];
    [self getMyMessageRequest];
}

- (void)back
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)initData
{
    _titles = @[@"我的消息",@"我的订单",@"我的地址"];
    _imgs = @[@"message_my.png",@"order_my.png",@"poistion_my.png"];
    NSDictionary *myMessage = [[NSUserDefaults standardUserDefaults]dictionaryForKey:kUserMsg];
    _myNum.text = myMessage[@"tel"];
}

- (void)addView
{
    UIView *tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 80)];
    UIButton *signOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signOutBtn setBackgroundImage:[UIImage imageWithName:@"querenbtn_bg.png"] forState:UIControlStateNormal];
    [signOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    signOutBtn.frame = CGRectMake(0, 0, 250, 42);
    signOutBtn.center = tableFootView.center;
    [signOutBtn addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchUpInside];
    [tableFootView addSubview:signOutBtn];
    
    _tableView.tableFooterView = tableFootView;
}

- (void)signOut
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kuserId];
//    GoodsViewController *vc = [[GoodsViewController alloc]init];
//    CustNavigationViewController *nvc = [[CustNavigationViewController alloc]initWithRootViewController:vc];
//    [self.mm_drawerController setCenterViewController:nvc];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titles[indexPath.row];
    UIImage *icon = [UIImage imageNamed:_imgs[indexPath.row]];
    CGSize iconSize = CGSizeMake(18, 18);
    UIGraphicsBeginImageContextWithOptions(iconSize, NO, 0.0);
    CGRect rect = CGRectMake(0, 0, iconSize.width, iconSize.height);
    [icon drawInRect:rect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            MessageViewController *vc = [[MessageViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            OrderViewController *vc = [[OrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            MyAddressViewController *vc = [[MyAddressViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)showAction
{
//    UIImagePickerController *imgPickerC = [[UIImagePickerController alloc]init];
//    imgPickerC.editing = YES;
//    imgPickerC.allowsEditing = YES;
//    imgPickerC.delegate = self;
//    imgPickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:imgPickerC animated:YES completion:nil];
    
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [actionSheet addButtonWithTitle:@"拍照"];
        [actionSheet addButtonWithTitle:@"从手机相册选择"];
        // 同时添加一个取消按钮
        [actionSheet addButtonWithTitle:@"取消"];
        // 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
        [actionSheet showInView:self.view];
}


#pragma mark - 判断设备是否有摄像头

- (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *imgPickerC = [[UIImagePickerController alloc]init];
            imgPickerC.editing = YES;
            imgPickerC.allowsEditing = YES;
            imgPickerC.delegate = self;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imgPickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imgPickerC animated:YES completion:nil];
            }
            break;
        }
        case 1:
        {
            UIImagePickerController *imgPickerC = [[UIImagePickerController alloc]init];
            imgPickerC.editing = YES;
            imgPickerC.allowsEditing = YES;
            imgPickerC.delegate = self;
            imgPickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imgPickerC animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

//照相，选图片的delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *_selectedImage = [[UIImage alloc] init];
    _selectedImage = info[@"UIImagePickerControllerEditedImage"];
    NSData *data = UIImageJPEGRepresentation(_selectedImage, 0.3);
    // 这里base64Encoding 要修改
    _iconString = [data base64Encoding];
    [self dismissViewControllerAnimated:YES completion:^{
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要把该图片设置为背景图" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        [alert show];
        //        alertContent(@"nigjsldg");
        //        kAlertView(@"确定把该图设置为头像", @"取消", @"确定");
        alertContent(@"确定把该图设置为头像", @"取消",@"确定");
        //        alertContentWithTag(@"确定把该图设置为头像", @"取消",@"确定", 1);
    }];
    //    [self performSelector:@selector(saveImage:) withObject:_selectedImage afterDelay:0.5];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self changeMyIconRequest];
    }
}

#pragma mark - 修改信息
- (void)changeMyIconRequest
{
    [SVProgressHUD showWithStatus:@"修改信息中..."];

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:kuserId];
    [parameter setObject:userId forKey:@"userid"];
    [parameter setObject:_iconString forKey:@"bitmap"];
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
//        [self getGoodsCartsuccess:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];

}

//#pragma mark - 请求返回数据
//- (void)changeMyMesssuccess:(id)response
//{
//    //    [SVProgressHUD dismiss];
//    NSDictionary *dic = (NSDictionary *)response;
//    MyLog(@"%@",dic);
//    if ([dic[@"code"] intValue]==1)
//    {
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:kGetDataSuccess];
//
//    }
//    else
//    {
//        [SVProgressHUD showInfoWithStatus:dic[@"message"] maskType:SVProgressHUDMaskTypeGradient];
//    }
//}
//

//- (void)changeMyIconRequest
//{
//    [SVProgressHUD showWithStatus:@"修改信息中..."];
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:kuserId];
//    [parameter setObject:userId forKey:@"userid"];
//    //    [parameter setObject:_iconfile forKeyedSubscript:@"file"];
//    
//    AFHTTPRequestSerializer *serial = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request = [serial multipartFormRequestWithMethod:@"POST" URLString:kpostsetuserlogoUrl parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//        // 要解决此问题，
//        // 可以在上传时使用当前的系统事件作为文件名
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        // 设置时间格式
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//        
//        /*
//         32          此方法参数
//         33          1. 要上传的[二进制数据]
//         34          2. 对应网站上[upload.php中]处理文件的[字段"file"]
//         35          3. 要保存在服务器上的[文件名]
//         36          4. 上传文件的[mimeType]
//         37          */
//        [formData appendPartWithFileData:_iconfile name:@"file" fileName:fileName mimeType:@"image/png"];
//    } error:nil];
//    
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    __weak typeof(self) weakSelf = self;
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //
//        [weakSelf changeMyMesssuccess:responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//        MyLog(@"%@",error);
//    }];
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//    [manager.operationQueue addOperation:op];
//    
//    //    [manager POST:kpostsetuserlogoUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    //        [weakSelf changeMyMesssuccess:responseObject];
//    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    //        MyLog(@"%@",error);
//    //
//    //    }];
//}

#pragma mark - 请求返回数据
- (void)changeMyMesssuccess:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@"头像上传成功"] status:kGetDataSuccess];
        [self getMyMessageRequest];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"] maskType:SVProgressHUDMaskTypeGradient];
    }
}

#pragma mark -
- (void)getMyMessageRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:kuserId];
    if (!userid)
    {
        LoginViewController *vc = [[LoginViewController alloc]init];
        CustNavigationViewController *nvc = [[CustNavigationViewController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
        return;
    }
    [parameter setObject:userid forKey:@"id"];
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
        [self success:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

#pragma mark - 请求返回数据
- (void)success:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults]setObject:dic[@"user"] forKey:kUserMsg];
        {
            NSString *logoPath = [kUrl stringByAppendingPathComponent:dic[@"user"][@"avatar"]];
            [_myIcon sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:kDefaultImg_Z]];
            _myNum.text = dic[@"user"][@"login_name"];
        }
        
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
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

- (IBAction)uploadIcon:(UIButton *)sender
{
    [self showAction];
}
@end
