//
//  LBNHDiscoveryHotController.m
//  nhExample
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHDiscoveryHotController.h"
#import "LBNHBaseTableView.h"
#import "LBNHDiscoveryHotRequest.h"
#import "LBNHDiscoveryModel.h"
#import "LBNHDiscoverHotHeaderView.h"
#import "LBNHDiscoveryHotCell.h"

@interface LBNHDiscoveryHotController ()

/** hot页的总数据 */
@property (nonatomic, strong) LBNHDiscoveryModel *discoveryModel;

@property (nonatomic, strong) LBNHDiscoverHotHeaderView *headerView;

@end

@implementation LBNHDiscoveryHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadData];
}

-(void)initUI{
    self.tableView.backgroundColor = [UIColor whiteColor];
    //显示右边的刷新按钮
    self.showRefreshIcon = YES;
    self.sepLineColor = kSeparatorColor;
    self.refreshType = LBBaseTableControllRefreshTypeBoth;
}

-(void)viewDidLayoutSubviews{
    NSLog(@"self.view frame si %@ ",NSStringFromCGRect(self.view.frame));
    //计算没有panorama的时候 tableview的位置
    self.headerView.height = self.headerView.modelsArray.count ? 180.f : 0 ;
    if (self.headerView.modelsArray.count){
        self.tableView.frame = CGRectMake(0, 180, kScreenWidth, self.view.height - 180);
    }else{
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, self.view.height);
    }
    
}

-(void)lb_refresh{
    [self loadData];
}


-(void)loadData{
    [MBProgressHUD showLoading:self.view];
    LBNHDiscoveryHotRequest *request = [LBNHDiscoveryHotRequest lb_request];
    request.lb_url = kNHDiscoverHotListAPI;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        if (success) {
            self.discoveryModel = [LBNHDiscoveryModel modelWithDictionary:response];
            [MBProgressHUD hidAllHudsInSuperView:self.view];
            self.headerView.modelsArray = self.discoveryModel.rotate_banner.banners;
            self.dataArray = self.discoveryModel.categories.category_list;
            [self lb_reloadData];
        }else{
            [MBProgressHUD showHintText:@"加载出错，稍后再试" superView:self.view];
        }
    }];
}


-(LBNHDiscoverHotHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[LBNHDiscoverHotHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
        [self.view addSubview:_headerView];
    }
    return _headerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)lb_numberOfSections{
    return 1;
}

-(NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"hotCellID";
    LBNHDiscoveryHotCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LBNHDiscoveryHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.model = self.dataArray[indexPath.row];
    cell.careBtnHandler = ^(LBNHDiscoveryHotCell *cellView,UIButton *button){
        NSLog(@"关注");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cellView removeAnimation];
            button.selected = YES;
            button.hidden = NO;
            button.layerBorderColor = [UIColor lightGrayColor];
        });
    };
    return cell;
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


@end
