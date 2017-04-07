//
//  LBNHDiscoveryViewController.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDiscoveryViewController.h"
#import "LBNHSegmentView.h"
#import "LBNHDiscoveryBookController.h"
#import "LBNHDiscoveryHotController.h"
#import "LBNHSearchController.h"
@interface LBNHDiscoveryViewController ()

@property (nonatomic, strong) LBNHDiscoveryHotController *hotController;

@property (nonatomic, strong) LBNHDiscoveryBookController *bookController;

@end

@implementation LBNHDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    [self setupNaviItems];
}

-(void)setupNaviItems{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"nearbypeople") style:UIBarButtonItemStylePlain target:self action:@selector(locationClicked)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"foundsearch") style:UIBarButtonItemStylePlain target:self action:@selector(searchClicked)];

    LBNHSegmentView *segementView = [[LBNHSegmentView alloc] initWithItemTitles:@[@"热吧",@"订阅"]];
    segementView.frame = CGRectMake(0, 0, 140, 35);
    segementView.SegmentItemSelected = ^(LBNHSegmentView *segView, NSInteger index, NSString *title){
        self.bookController.view.hidden = index ? NO : YES;
        self.hotController.view.hidden = index ? YES : NO;
    };
    [segementView clickDefaultIndex:0];
    self.navigationItem.titleView = segementView;
}


#pragma mark naviItem的点击事件

-(void)searchClicked{
    LBNHSearchController *searchVC = [[LBNHSearchController alloc] init];
    [self pushToVc:searchVC];
}

-(void)locationClicked{
    
}

-(LBNHDiscoveryHotController *)hotController{
    if (!_hotController) {
        _hotController = [[LBNHDiscoveryHotController alloc] init];
        [self addChildVc:_hotController];
    }
    return _hotController;
}

-(LBNHDiscoveryBookController *)bookController{
    if (!_bookController) {
        _bookController = [[LBNHDiscoveryBookController alloc] init];
        [self addChildVc:_bookController];
    }
    return _bookController;
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
