//
//  HomeViewController.m
//  MenYa
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HomePlayerCell.h"
#import "ZFPlayer.h"
#import "AnimationView.h"
#import "ShowActView.h"
#import "KLCoverView.h"
#import "SharePopView.h"
#import "UMSocial.h"
#import "VideoCommentView.h"
#import "ChooseSpecificationsView.h"
#import "MJRefresh.h"
#import "HomeVideoModel.h"
#import "GoodsDetailViewController.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *defaultImg;
STRONG_NONATOMIC_PROPERTY NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet ShowActView *showActView;
@property (weak, nonatomic) IBOutlet UIButton *addShopCart;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
STRONG_NONATOMIC_PROPERTY AnimationView *aniView;
@property (nonatomic, strong) ZFPlayerView *playerView;
STRONG_NONATOMIC_PROPERTY KLCoverView *mask;
ASSIGN_NONATOMIC_PROPERTY __block NSInteger zanFlag;
STRONG_NONATOMIC_PROPERTY SharePopView *sharePopView;
STRONG_NONATOMIC_PROPERTY VideoCommentView *videoComment;
STRONG_NONATOMIC_PROPERTY CADisplayLink *displayLink;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) CGPoint beforePoint;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KLColor(237, 246, 246);
    [self setNavgaTitle:@"MenYaer"];
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor orangeColor]colorWithAlphaComponent:0]] forBarMetrics:UIBarMetricsDefault];
    [self initData];
    [self initView];
    //判断是否第一次登录
    NSString *path =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/animation3.plist"];
    //获取路径文件内容
    NSDictionary *fileDic = [NSDictionary dictionaryWithContentsOfFile:path];
    //判断文件内容是否为空
    if (fileDic == nil)
    {
        //是第一次打开应用程序，开启第一次进入动画
        //把文件写入
        fileDic = @{@"animation":@"YES"};
        [fileDic writeToFile:path atomically:YES];
        //不是第一次打开应用程序.默认动画
        
        _aniView = [[AnimationView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        __weak typeof(self) weakSelf = self;
        _aniView.didSelectedView = ^(AnimationView *aniview,NSInteger i){
            [weakSelf hidesAniView];
        };
//        [[[UIApplication sharedApplication] keyWindow] addSubview:_aniView];
    }
    WS(weakSelf);
    [self.mm_drawerController setGestureCompletionBlock:^(MMDrawerController *drawerController, UIGestureRecognizer *gesture) {
        [weakSelf changePlayerState];
    }];
    [self getListDataWithPage:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.mm_drawerController.openSide == MMDrawerSideNone) {
        [self pausePlayer:NO];
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self pausePlayer:YES];
    self.navigationController.navigationBarHidden = NO;
}

//获取列表数据
- (void)getListDataWithPage:(int)page
{
    //         */
    
    [SVProgressHUD showWithStatus:kLoadingData maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[NSString stringWithFormat:@"%d",_pageNo] forKey:@"page"];
    [parameter setObject:@"5" forKey:@"size"];
    [NetworkDataClient getDataWithUrl:kVideogetList parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        [self getDataSuccess:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

#pragma mark - 请求返回数据
- (void)getDataSuccess:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    if ([dic[kJson_Status] integerValue] == 1)
    {
        //        [SVProgressHUD showSuccessWithStatus:@"获取数据成功" ];
        //        [SVProgressHUD showInfoWithStatus:@"" maskType:SVProgressHUDMaskTypeGradient];
        kSVPDismiss;
        NSArray *array = dic[kJson_Data];
        if (array.count == 0) {
            [_tableView.footer noticeNoMoreData];
        }
        for (int i = 0; i < array.count;i++)
        {
            NSDictionary *dataDic = array[i];
            [_dataSource addObject:[HomeVideoModel messageWithDict:dataDic]];
        }
        if (_dataSource.count == 0) {
            _defaultImg.hidden = NO;
        }
        else
        {
            _defaultImg.hidden = YES;
        }
        [_tableView reloadData];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"msg"]];
    }
}

- (void)refreshData
{
    //加载数据
    _pageNo = 1;
    [self.tableView.footer resetNoMoreData];
    [_dataSource removeAllObjects];
    [self getListDataWithPage:_pageNo];
    [self.tableView reloadData];
}

- (void)loadMore
{
    [self getListDataWithPage:(++_pageNo)];
}

- (void)hidesAniView
{
    [_aniView removeFromSuperview];
}

- (void)initData
{
    _dataSource = [NSMutableArray array];
//    NSArray *array = @[@{@"videoUrl":@"http://www.menyaer.com/data/image/video/video.mp4",@"img":@"pic-googs-bg.jpg"},@{@"videoUrl":@"http://www.menyaer.com/data/image/video/Paintball.mp4",@"img":@"pic-googs-bg.jpg"},@{@"videoUrl":@"http://www.menyaer.com/data/image/video/coco.mp4",@"img":@"pic-googs-bg.jpg"}];
//    _dataSource = [NSMutableArray arrayWithArray:array];
}

- (void)initView{
    _tableView.tableFooterView = [UIView new];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)shoppingCarts
{
    [self pausePlayer:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)leftList
{
    [self pausePlayer:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark -抽屉滑动时改变播放器播放状态
- (void)changePlayerState
{
    if (self.mm_drawerController.openSide == MMDrawerSideNone)
    {
        [self pausePlayer:NO];
    }
    else
    {
        [self pausePlayer:YES];
    }
}

#pragma mark -停止播放还是停止
- (void)pausePlayer:(BOOL)pause
{
    [self.playerView setIsPauseByUser:pause];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    HomePlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HomePlayerCell" owner:self options:nil][0];
    }
    HomeVideoModel *model = _dataSource[indexPath.row];
    MyLog(@"%@",indexPath);
//    __block NSIndexPath *weakIndexPath = indexPath;
//    __block HomePlayerCell *weakCell     = cell;
    if (indexPath.row == 0)
    {
        NSString *price = [NSString stringWithFormat:@"￥%.2f I 加入购物车",[model.SkuPrice floatValue]];
        [_addShopCart setTitle:price forState:UIControlStateNormal];
        self.playerView = [ZFPlayerView sharedPlayerView];
        // 分辨率字典（key:分辨率名称，value：分辨率url)
        //        NSMutableDictionary *dic = @{}.mutableCopy;
        //        for (ZFPlyerResolution * resolution in model.playInfo) {
        //            [dic setValue:resolution.url forKey:resolution.name];
        //        }
        // 取出字典中的第一视频URL
//        NSURL *videoURL = [NSURL URLWithString:dic[@"videoUrl"]];
        NSURL *videoURL = [NSURL URLWithString:model.Url];
        //     设置player相关参数(需要设置imageView的tag值，此处设置的为101)
        //            [weakSelf.playerView setVideoURL:videoURL
        //                               withTableView:weakSelf.tableView
        //                                 AtIndexPath:weakIndexPath
        //                            withImageViewTag:101];
        [self.playerView resetPlayer];
        [self.playerView setImageBeginUrl:model.ImgUrl1 endImgUrl:model.ImgUrl1];
        [self.playerView setVideoURL:videoURL];
        [self.playerView addPlayerToCellImageView:cell.avatarImageView];
        
        // 下载功能
        self.playerView.hasDownload   = NO;
        [self.playerView.controlView hideAllControll];
        // 赋值分辨率字典
        //weakSelf.playerView.resolutionDic = dic;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeight;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (_dataSource.count == 0||fabs(offset.y-_beforePoint.y)<kHeight) {
        return;
    }
    _beforePoint = offset;
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:offset];
    HomeVideoModel *model = _dataSource[indexPath.row];
    _showActView.hidden = YES;
    NSString *price = [NSString stringWithFormat:@"￥%.2f l 加入购物车",[model.SkuPrice floatValue]];
    [_addShopCart setTitle:price forState:UIControlStateNormal];
    HomePlayerCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    WS(weakSelf);
    
//    weakSelf.playerView = [ZFPlayerView sharedPlayerView];
    // 分辨率字典（key:分辨率名称，value：分辨率url)
    //        NSMutableDictionary *dic = @{}.mutableCopy;
    //        for (ZFPlyerResolution * resolution in model.playInfo) {
    //            [dic setValue:resolution.url forKey:resolution.name];
    //        }
    // 取出字典中的第一视频URL
    NSURL *videoURL = [NSURL URLWithString:model.Url];
    
    //     设置player相关参数(需要设置imageView的tag值，此处设置的为101)
    //            [weakSelf.playerView setVideoURL:videoURL
    //                               withTableView:weakSelf.tableView
    //                                 AtIndexPath:weakIndexPath
    //                            withImageViewTag:101];
    [self.playerView resetPlayer];
    [self.playerView setImageBeginUrl:model.ImgUrl1 endImgUrl:model.ImgUrl1];
    [weakSelf.playerView setVideoURL:videoURL];
    [weakSelf.playerView addPlayerToCellImageView:cell.avatarImageView];
    
    // 下载功能
    weakSelf.playerView.hasDownload   = NO;
    [self.playerView.controlView hideAllControll];
    // 赋值分辨率字典
    //weakSelf.playerView.resolutionDic = dic;
    //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
    weakSelf.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
}

- (IBAction)btnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            //左边侧栏
            [self leftList];
            break;
        }
        case 1:
        {
            //购物车
            [self shoppingCarts];
            break;
        }
        case 2:
        {
            //商品详情
            [self pushToDetail];
            break;
        }
        case 3:
        {
            //添加购物车
            [self.view addSubview:self.mask];
            //把点赞记录为0
            _zanFlag = 0;
            ChooseSpecificationsView *specifiView = [[ChooseSpecificationsView alloc]initWithFrame:CGRectMake(10, kHeight, kWidth-2*10, 340)];
            WS(weakSelf);
            specifiView.closeView = ^(ChooseSpecificationsView *shooseView){
                [weakSelf hiddenMask];
            };
            specifiView.dataDic = @{@"price":@"129",@"icon":@"i"};
            specifiView.superVC = self;
            break;
        }
        case 4:
        {
            //other 操作
            
            if (!_showActView.hidden) {
                [_showActView showOrHiddenWithAnim];
            }
            else
            {
                _showActView.datas = @[@{@"icon":@"icon-comment",@"num":@0},@{@"icon":@"icon-share",@"num":@0},@{@"icon":@"icon-keep",@"num":@0},@{@"icon":@"icon-favor",@"num":@10}];
            }
            WS(ws);
            _showActView.didClick = ^(ShowActView *showView,NSInteger index){
                _zanFlag = index;
                switch (index) {
                    case 1:
                    {
                        //评论
                        [ws.view addSubview:self.mask];
                        [ws showVideoCommentView];
                        break;
                    }
                    case 2:
                    {
                        //分享
                        [ws.view addSubview:self.mask];
                        [ws showSharePopView];
                        break;
                    }
                    case 3:
                    {
                        //收藏
                        
                        break;
                    }
                    case 4:
                    {
                        //点赞
                        [self beiginSanHua];
                        break;
                    }
                    default:
                        break;
                }
            };
            break;
        }
        default:
            break;
    }
}

- (void)transitionPush{
    
    
    CATransition *tran = [CATransition animation];
    tran.duration =1;
    tran.type =@"suckEffect";
//    tran.type = kCATransitionMoveIn;
    tran.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; /* 动画的开始与结束的快慢*/
    //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"@"cameraIrisHollowOpen"@"cameraIrisHollowClose"
    tran.subtype =kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:tran forKey:nil];
}

//按钮的点击时间，实现push动画效果
- (void)pushToDetail{
    [self transitionPush];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
//    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController pushViewController:vc animated:YES];
}

- (KLCoverView *)mask
{
    if (!_mask) {
        _mask = [[KLCoverView alloc]initWithFrame:self.view.bounds];
        [_mask setTarget:self action:@selector(hiddenMask)];
    }
    return _mask;
}

- (void)hiddenMask
{
    if (_zanFlag == 1) {
        //评论
        [self showVideoCommentView];
    }
    else if (_zanFlag == 2)
    {
        //分享
        [self showSharePopView];
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        _mask.alpha = 0;
    } completion:^(BOOL finished) {
        _mask = nil;
//        [_mask removeFromSuperview];
    }];
}

- (SharePopView *)sharePopView
{
    if (!_sharePopView) {
        _sharePopView = [SharePopView createView];
        _sharePopView.frame = CGRectMake(10, kHeight+156, kWidth-20, 156);
        _sharePopView.layer.cornerRadius = 10;
        _sharePopView.clipsToBounds = YES;
        WS(ws);
        _sharePopView.didClick = ^(SharePopView *share, NSInteger index){
            switch (index) {
                case 0:
                {
                    //评论
                    [ws hiddenMask];
                    break;
                }
                case 1:
                {
                    //分享朋友圈
                    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                        @"http://www.baidu.com/img/bdlogo.gif"];
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:ws completion:^(UMSocialResponseEntity *shareResponse){
                        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                            NSLog(@"分享成功！");
                        }
                    }];
                    break;
                }
                case 2:
                {
                    //
                    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                        @"http://www.baidu.com/img/bdlogo.gif"];
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:ws completion:^(UMSocialResponseEntity *shareResponse){
                        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                            NSLog(@"分享成功！");
                        }
                    }];
                    break;
                }
                case 3:
                {
                    //
                    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                        @"http://www.baidu.com/img/bdlogo.gif"];
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:ws completion:^(UMSocialResponseEntity *shareResponse){
                        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                            NSLog(@"分享成功！");
                        }
                    }];

                    break;
                }
                default:
                    break;
            }
        };
    }
    return _sharePopView;
}

#pragma mark - 显示隐藏分享view
- (void)showSharePopView
{
    [self.view addSubview:self.sharePopView];
    if (_sharePopView.top > kHeight) {
        [UIView animateWithDuration:0.35 animations:^{
            //
            _sharePopView.frame = CGRectMake(10, kHeight-156-10, kWidth-20, 156);
        } completion:^(BOOL finished) {
            //
        }];
    }
    else
    {
        [UIView animateWithDuration:0.35 animations:^{
            //
            _sharePopView.frame = CGRectMake(10, kHeight+156, kWidth-20, 156);
        } completion:^(BOOL finished) {
            //
        }];
    }
}

#pragma mark - 显示隐藏视频评论view
- (void)showVideoCommentView
{
    [self.view addSubview:self.videoComment];
    if (_videoComment.top >= kHeight) {
        [UIView animateWithDuration:0.35 animations:^{
            //
            _videoComment.frame = CGRectMake(0, 0, kWidth, kHeight);
        } completion:^(BOOL finished) {
            //
        }];
    }
    else
    {
        [UIView animateWithDuration:0.35 animations:^{
            //
            _videoComment.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        } completion:^(BOOL finished) {
            //
            _videoComment = nil;
        }];
    }
}

- (VideoCommentView *)videoComment
{
    if (!_videoComment) {
        _videoComment = [[VideoCommentView alloc]init];
        _videoComment.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        WS(ws);
        _videoComment.closeView = ^(VideoCommentView *share){
            [ws hiddenMask];
        };
    }
    return _videoComment;
}

#pragma mark --点赞
- (void)beiginSanHua{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleAction:)];
    //
//    self.displayLink.frameInterval = 0.5;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.displayLink invalidate];
        self.displayLink = nil;
    });
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)handleAction:(CADisplayLink *)displayLink{
    
    UIImage *image = [UIImage imageNamed:@"icon-zan"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat scale = arc4random_uniform(60) / 40.0;
    imageView.transform = CGAffineTransformMakeScale(scale, scale);
    CGSize winSize = self.view.bounds.size;
    CGFloat x = arc4random_uniform(winSize.width);
    CGFloat y = - imageView.frame.size.height;
    imageView.center = CGPointMake(x, y);
    
    [self.view addSubview:imageView];
    [UIView animateWithDuration:arc4random_uniform(10) animations:^{
        CGFloat toX = arc4random_uniform(winSize.width);
        CGFloat toY = imageView.frame.size.height * 0.5 + winSize.height;
        
        imageView.center = CGPointMake(toX, toY);
        imageView.transform = CGAffineTransformRotate(imageView.transform, arc4random_uniform(M_PI * 2));
        
        imageView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
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
