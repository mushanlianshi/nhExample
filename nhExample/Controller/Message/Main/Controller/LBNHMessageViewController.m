//
//  LBNHMessageViewController.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHMessageViewController.h"
#import "LBNHBaseImageView.h"
#import "LBNHUserInfoManager.h"
#import "LBNHUserInfoModel.h"
#import "UIView+LBTap.h"
#import "LBNHUserIconView.h"
#import "LBNHMessageModel.h"
#import "LBNHBaseTableView.h"
#import "LBNHCustomNoDataEmptyView.h"
#import "LBNHFansAndAttentionController.h"
#import "LBNHSystemMessageController.h"
#import "LBNHConversationController.h"
#import "LBUtils.h"
#import "NSFileManager+LBPath.h"
#import "NSString+Size.h"
#import "LBCustomAlertView.h"
#import "LBAnimationController.h"
#import "LBCircleAnimationController.h"
#import "LBDragCellController.h"
#import "LBCardPanoramaController.h"
#import "LBMessageViewController.h"

static NSString *messageCellID = @"LBNHMessageCell";
@interface LBNHMessageViewController ()

@property (nonatomic, copy) NSString *cachesSizeString;

@end

@implementation LBNHMessageViewController

- (void)viewDidLoad {
    
    NSLog(@"self.view frame si %@ ",NSStringFromCGRect(self.view.frame));
    [super viewDidLoad];
    [self initNaviUI];
    [self loadData];
//    self.navigationController.navigationBarHidden = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
}

-(void)viewWillLayoutSubviews{
    NSLog(@"self.view frame is %@ ",NSStringFromCGRect(self.view.frame));
}

//-(void)viewWillAppear:(BOOL)animated
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"self.view frame si %@ ",NSStringFromCGRect(self.view.frame));
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
}

-(void)initNaviUI{
    LBNHUserInfoModel *userInfo = [LBNHUserInfoManager sharedLBNHUserInfoManager].currentLoginUserInfo;
    LBNHUserIconView *iconView = [[LBNHUserIconView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    iconView.image = ImageNamed(@"digdownicon_review_press_1");
    iconView.iconUrl = userInfo.avatar_url;
    WS(weakSelf);
//    iconView.frame = CGRectMake(0, 0, 35, 35);
    iconView.tapHandler = ^(LBNHUserIconView *iv){
        [weakSelf userInfoClicked];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:iconView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"黑名单" style:UIBarButtonItemStylePlain target:self action:@selector(blackRoomClicked)];
    self.navItemTitle = @"消息";
    
}

-(void)loadData{
    NSArray *imageArray = @[@"interaction",@"messageicon_profile",@"vermicelli",@"godcomment",@"interaction",@"messageicon_profile",@"vermicelli",@"godcomment",@"interaction"];
    NSArray *titleArray = @[@"投稿互动",@"系统消息",@"粉丝互助",@"缓存大小",@"动画",@"转盘选择动画",@"可拖动的cell",@"卡片式轮播",@"信息界面"];
    int i = 0;
    for (NSString *title in titleArray){
        LBNHMessageModel *model = [[LBNHMessageModel alloc] init];
        model.title = title;
        model.iconName = imageArray[i];
        i++;
        [self.dataArray addObject:model];
    }
    [self lb_reloadData];
    LBNHCustomNoDataEmptyView *emptyView = [[LBNHCustomNoDataEmptyView alloc] initWithTitle:@"约起来吧" image:ImageNamed(@"around") desc:@"去TA的主页就可以发悄悄话了"];
    emptyView.frame = CGRectMake(0, 44*self.dataArray.count, kScreenWidth, kScreenHeight - 44*self.dataArray.count);
    [self.tableView addSubview:emptyView];
}

-(void)userInfoClicked{
    NSLog(@"cell userInfoClicked =============");
}

-(void)blackRoomClicked{
    NSLog(@"cell blackRoomClicked =============");
}


-(NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    LBNHMessageModel *model = self.dataArray[indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:messageCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCellID];
    }
    cell.imageView.image = ImageNamed(model.iconName);
    cell.textLabel.text = model.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectedBackgroundView = [UIView new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 3) {
        UILabel *label = [cell viewWithTag:101];
        if (!label) {
            label = [[UILabel alloc] init];
            label.font = kFont(13);
            label.tag = 101;
            label.textColor = kCommonTintColor;
            label.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:label];
        }
        CGFloat cacheSize = [LBUtils folderSizeAtPath:[NSFileManager cachesPath]];
//        CGFloat librarySize = [LBUtils folderSizeAtPath:[NSFileManager libraryPath]];
        //判断不是nan数据
        if(!isnan(cacheSize)){
            label.text = [NSString stringWithFormat:@"缓存 %.2f M",cacheSize];
        }else{
            label.text = [NSString stringWithFormat:@"缓存 0 M"];
        }
        
        self.cachesSizeString = label.text;
        NSLog(@"===== %p ",self.cachesSizeString);
        NSLog(@"==label.text=== %p ",label.text);
        CGFloat width = [label.text widhtWithLimitHeight:30 fontSize:13];
        label.frame = CGRectMake(kScreenWidth - width - 40, 7, width, 30);
    }
    
    return cell;
}

-(CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    NSLog(@"cell selected =============");
    switch (indexPath.row) {
        case 0:
            {
                LBNHConversationController *vc = [[LBNHConversationController alloc] init];
                [self pushToVc:vc];
            }
            break;
        case 1:
            {
                LBNHSystemMessageController *vc = [[LBNHSystemMessageController alloc] init];
                [self pushToVc:vc];
            }
            
            break;
        case 2:
            {
                
                LBNHFansAndAttentionController *vc = [[LBNHFansAndAttentionController alloc] initWithUserId:[LBNHUserInfoManager sharedLBNHUserInfoManager].userID attentionType:LBAttentionAndFansTypeFans];
                [self pushToVc:vc];
            }
            break;
        case 3:
            {
                LBCustomAlertView *alertView = [[LBCustomAlertView alloc] initWithTitle:@"清楚缓存" content:[NSString stringWithFormat:@"你确定要清楚%@缓存吗",self.cachesSizeString] cancel:@"取消" sure:@"确定"];
                [alertView showInSuperView:self.view];
                WS(weakSelf);
                [alertView setSureBlock:^{
                    [LBUtils clearCache:[NSFileManager cachesPath]];
                    [LBUtils clearCache:[NSFileManager libraryPath]];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            break;
        case 4:{
            LBAnimationController *vc = [[LBAnimationController alloc] init];
            [self pushToVc:vc];
            }
            break;
        case 5:
            {
                LBCircleAnimationController *vc = [[LBCircleAnimationController alloc] init];
                [self pushToVc:vc];
            }
            break;
        case 6:
        {
            LBDragCellController *vc = [[LBDragCellController alloc] init];
            [self pushToVc:vc];
        }
            break;
        case 7:
        {
            LBCardPanoramaController *vc = [[LBCardPanoramaController alloc] init];
            [self pushToVc:vc];
        }
            break;
        case 8:
        {
            LBMessageViewController *vc = [[LBMessageViewController alloc] init];
            [self pushToVc:vc];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
