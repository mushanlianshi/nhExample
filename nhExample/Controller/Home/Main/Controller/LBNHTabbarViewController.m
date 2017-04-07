//
//  LBNHTabbarViewController.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHTabbarViewController.h"
#import "LBNHHomeViewController.h"
#import "LBNHDiscoveryViewController.h"
#import "LBNHCheckViewController.h"
#import "LBNHMessageViewController.h"
#import "LBBaseNavigationViewController.h"
#import "LBNHHomeTitleRequest.h"
#import "LBNHHomeTitleModel.h"

@interface LBNHTabbarViewController ()

@end

@implementation LBNHTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabbar];
    [self addChildViewControllers];
    [self requestTitlesData];
    
}

-(void)requestTitlesData{
    LBNHHomeTitleRequest *request = [[LBNHHomeTitleRequest alloc] init];
    request.lb_url = kNHHomeServiceListAPI;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        if (success) {
            LBBaseNavigationViewController *navi = (LBBaseNavigationViewController *)self.childViewControllers.firstObject;
            LBNHHomeViewController *homeVC = (LBNHHomeViewController *)navi.viewControllers.firstObject;
            homeVC.modelsArray = [LBNHHomeTitleModel modelArrayWithArray:response];
        }else{
            [LBTips showTips:@"获取数据失败"];
        }
    }];
}

/**
 设置tabbar显示的样式
 */
-(void)initTabbar{
    //1.获取全局的tabbat
    UITabBar *tabbar = [UITabBar appearance];
    // 设置为不透明
    [tabbar setTranslucent:NO];
    //主题颜色
    tabbar.barTintColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    //2.拿到整个显示的tabbarItem // 拿到整个导航控制器的外观
    UITabBarItem * item = [UITabBarItem appearance];
    item.titlePositionAdjustment = UIOffsetMake(0, 1.5);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize: 13],NSForegroundColorAttributeName:[UIColor colorWithRed:0.62f green:0.62f blue:0.63f alpha:1.00f]};
    //3.设置普通的状态
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *selectDic = @{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f]};
    //4.设置选中的状态
    [item setTitleTextAttributes:selectDic forState:UIControlStateSelected];
}

-(void)addChildViewControllers{
    [self addChildViewController:[LBNHHomeViewController description] title:@"首页" image:@"home"];
    [self addChildViewController:[LBNHDiscoveryViewController description] title:@"发现" image:@"Found"];
    [self addChildViewController:[LBNHCheckViewController description] title:@"查找" image:@"audit"];
    [self addChildViewController:[LBNHMessageViewController description] title:@"消息" image:@"newstab"];
}

-(void)addChildViewController:(NSString *)viewController title:(NSString *)title image:(NSString *)image{
    LBBaseNavigationViewController *navi = [[LBBaseNavigationViewController alloc] initWithRootViewController:[[NSClassFromString(viewController) alloc] init]];
    navi.tabBarItem.title = title;
    navi.tabBarItem.image = ImageNamed(image);
    //不使用系统默认的染色方式  UIImageRenderingModeAlwaysOriginal 使用原来的
    navi.tabBarItem.selectedImage = [ImageNamed([image stringByAppendingString:@"_press"]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:navi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return NO;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
