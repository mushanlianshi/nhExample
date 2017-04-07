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

static NSString *messageCellID = @"LBNHMessageCell";
@interface LBNHMessageViewController ()

@end

@implementation LBNHMessageViewController

- (void)viewDidLoad {
    NSLog(@"self.view frame si %@ ",NSStringFromCGRect(self.view.frame));
    [super viewDidLoad];
    [self initNaviUI];
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"self.view frame si %@ ",NSStringFromCGRect(self.view.frame));
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
    NSArray *imageArray = @[@"interaction",@"messageicon_profile",@"vermicelli"];
    NSArray *titleArray = @[@"投稿互动",@"系统消息",@"粉丝互助"];
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
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
