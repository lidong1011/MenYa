//
//  GoodsViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/13.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsListViewController.h"
#import "CustNavigationViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UIButton+WebCache.h"

@interface GoodsViewController ()<ViewPagerDelegate,ViewPagerDataSource>
@property (nonatomic,strong) NSArray *titleArray;
STRONG_NONATOMIC_PROPERTY UIButton *rightBtn;
STRONG_NONATOMIC_PROPERTY UILabel *shjLab;
@end

@implementation GoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"宝贝中心";
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(66, 0, 34, 34);
    _rightBtn.layer.cornerRadius = 17;
    _rightBtn.clipsToBounds = YES;
    NSString *string = [[NSUserDefaults standardUserDefaults] stringForKey:@"SHJICON"];
    [_rightBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:kDefaultImg_Z]];
    [_rightBtn addTarget:self action:@selector(shoppingCarts) forControlEvents:UIControlEventTouchUpInside];
    _shjLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 66, 35)];
    _shjLab.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"SHJNAME"];
    _shjLab.font = [UIFont systemFontOfSize:12];
    _shjLab.textColor = [UIColor whiteColor];
    _shjLab.textAlignment = NSTextAlignmentRight;
    _shjLab.numberOfLines = 2;
    [rightBarView addSubview:_rightBtn];
    [rightBarView addSubview:_shjLab];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarView];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"售货机" style:UIBarButtonItemStyleDone target:self action:@selector(selectSHJ)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"list.png" highlightIcon:nil imageScale:1 target:self action:@selector(leftList)];
    self.view.backgroundColor = KLColor(246, 246, 246);
    _titleArray = @[@"热销",@"食材",@"日用品"];
    self.delegate = self;
    self.dataSource = self;
    //    [self selectTabAtIndex:_flag];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor orangeColor]colorWithAlphaComponent:0]] forBarMetrics:UIBarMetricsDefault];
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
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)leftList
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _titleArray.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = [NSString stringWithFormat:@"%@", _titleArray[index]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [label sizeToFit];
    
    return label;
}



#pragma mark - ViewPagerDataSource
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    GoodsListViewController *vc = [[GoodsListViewController alloc]init];
    vc.machineid = _machineid;
    vc.flag = index;
    return vc;
    //    switch (index)
    //    {
    //        case 0:
    //        {
    //            AllViewController *allVC = [[AllViewController alloc]init];
    //            NSLog(@"%lu",(unsigned long)index);
    //            allVC.view.backgroundColor = KLColor(224, 202, 202);
    //            return allVC;
    //            break;
    //        }
    //        case 1:
    //        {
    //            ForEvaluationViewController *payVC = [[ForEvaluationViewController alloc]init];
    //            payVC.vcFlag = index;
    //            NSLog(@"%lu",(unsigned long)index);
    //            payVC.view.backgroundColor = KLColor(224, 202, 202);
    //            return payVC;
    //            break;
    //        }
    //        case 2:
    //        {
    ////            ForServiceViewController *serviVC = [[ForServiceViewController alloc]init];
    ////            NSLog(@"%lu",(unsigned long)index);
    ////            serviVC.view.backgroundColor = KLColor(224, 202, 202);
    ////            return serviVC;
    //            break;
    //        }
    //        case 3:
    //        {
    //            ForEvaluationViewController *evaluatVC = [[ForEvaluationViewController alloc]init];
    //            NSLog(@"%lu",(unsigned long)index);
    //            evaluatVC.view.backgroundColor = KLColor(224, 202, 202);
    //            return evaluatVC;
    //            break;
    //        }
    //        case 4:
    //        {
    //            ForEvaluationViewController *payVC = [[ForEvaluationViewController alloc]init];
    //            NSLog(@"%lu",(unsigned long)index);
    //            payVC.view.backgroundColor = KLColor(224, 202, 202);
    //            return payVC;
    //            break;
    //        }
    //        default:
    //        {
    //            AllViewController *allVC = [[AllViewController alloc]init];
    //            NSLog(@"%lu",(unsigned long)index);
    //            allVC.view.backgroundColor = KLColor(224, 202, 202);
    //            return allVC;
    //            break;
    //        }
    //    }
    
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    
    // Do something useful
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 40.0;
        case ViewPagerOptionTabOffset:
            return 0.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 20 : kWidth/3;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions://自动修正在后
            return 0.0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [kZhuTiColor colorWithAlphaComponent:0.64];
        case ViewPagerTabsView:
            
            //            return [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
        case ViewPagerContent:
            return [UIColor whiteColor];
            //            return [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
