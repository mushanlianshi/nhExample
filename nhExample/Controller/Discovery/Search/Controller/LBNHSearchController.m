//
//  LBNHSearchController.m
//  nhExample
//
//  Created by liubin on 17/4/6.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHSearchController.h"
#import "LBCustomTextField.h"
#import "LBNHCustomNoDataEmptyView.h"
#import "LBNHSearchRequest.h"
#import "LBNHUserInfoModel.h"
#import "LBNHHomeServiceDataModel.h"
#import "LBNHDiscoveryModel.h"
#import "LBNHSearchFriendsCell.h"
#import "LBNHBaseTableView.h"
#import "LBNHDiscoveryHotCell.h"
#import "LBNHSearchPostsCell.h"
#import "LBNHSearchLimitFriendsCell.h"

@interface LBNHSearchController ()<UITextFieldDelegate>

@property (nonatomic, copy) NSString *keyWords;

@property (nonatomic, strong) LBCustomTextField *leftTextField;

@property (nonatomic, strong) LBNHCustomNoDataEmptyView  *emptyView;

/** 热吧栏目搜索的结果 */
@property (nonatomic, strong) NSMutableArray *hotColumnsArray;

/** 搜索到的文字帖子数组 */
@property (nonatomic, strong) NSMutableArray *textPostsArray;

/** 搜索到的图片帖子数组 */
@property (nonatomic, strong) NSMutableArray *imagePostsArray;

/** 搜索到的视频帖子数组 */
@property (nonatomic, strong) NSMutableArray *videoPostsArray;

/** 好友是否展开   如果展开只显示他自己  否则都显示 */
@property (nonatomic, assign) BOOL isFirendLineExpand;

@end

@implementation LBNHSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviItems];
    [self showNoDataView];
    [self addObserverNotifications];
}





-(void)initNaviItems{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftTextField];
    WS(weakSelf);
    [self setRightNaviItemTitle:@"取消" rightHandler:^(NSString *titleString) {
        [weakSelf pop];
    }];
}

-(void)showNoDataView{
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.emptyView.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.centerY.equalTo(self.emptyView).offset(-self.emptyView.imageView.image.size.height/2 - 10);
    }];
    
    [self.emptyView.bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.centerY.equalTo(self.emptyView).offset(20);
        make.width.mas_lessThanOrEqualTo(kScreenWidth - 100);
    }];
}

-(void)searchWithText:(NSString *)searchText{
    self.keyWords = searchText;
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
    [self showLoadingView];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    //段友搜索
    LBNHSearchRequest *personRequest = [LBNHSearchRequest lb_request];
    personRequest.lb_url = kNHDiscoverSearchUserListAPI;
    personRequest.keyword = searchText;
    [personRequest lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        NSLog(@"LBLog search 段友搜索结束");
        if (success) {
            [self.dataArray removeAllObjects];
            self.dataArray = [LBNHUserInfoModel modelArrayWithArray:response];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    //帖子搜索
    LBNHSearchRequest *contentRequest = [LBNHSearchRequest lb_request];
    contentRequest.lb_url = kNHDiscoverSearchDynamicListAPI;
    contentRequest.keyword = searchText;
    [contentRequest lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        NSLog(@"LBLog search 段友帖子结束");
        if (success) {
            [self clearArrays];
            self.textPostsArray = [LBNHHomeServiceDataElementGroup modelArrayWithArray:response[@"text"]];
            self.imagePostsArray = [LBNHHomeServiceDataElementGroup modelArrayWithArray:response[@"image"]];
            self.videoPostsArray = [LBNHHomeServiceDataElementGroup modelArrayWithArray:response[@"video"]];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    //栏目搜索 热吧的cell
    LBNHSearchRequest *columnRequest = [[LBNHSearchRequest alloc] init];
    columnRequest.lb_url = kNHDiscoverSearchHotDraftListAPI;
    columnRequest.keyword = searchText;
    [columnRequest lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        NSLog(@"LBLog search 段友栏目结束");
        if (success) {
            self.hotColumnsArray = [LBNHDiscoveryCategoryElement modelArrayWithArray:message];
        }
        dispatch_group_leave(group);
    }];
    
    //请求都结束了  处理数据结果
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"LBLog search 所有ALL搜索结束");
        [self hiddenLoadingView];
        [self lb_reloadData];
    });
}


/** 清除帖子所有数组中的内容 */
-(void)clearArrays{
    [self.textPostsArray removeAllObjects];
    [self.imagePostsArray removeAllObjects];
    [self.videoPostsArray removeAllObjects];
}



#pragma mark cell的数据源

-(NSInteger)lb_numberOfSections{
    if (self.isFirendLineExpand) {
        return 1;
    }
    //利用三目运算符来计算有多少sections  也可以都算上  高度的时候在=0一样的效果
//    NSInteger sections = self.hotColumnsArray.count ? 1 :0 +self.dataArray.count ? 1 : 0 +self.textPostsArray.count ? 1 :0 +self.imagePostsArray.count ? 1 : 0 +self.videoPostsArray.count ? 1 : 0;
//    return sections;
    return 5;
}

/** 某个分组的cell数量*/
- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section{
    if (self.isFirendLineExpand) {
        return self.dataArray.count;
    }
    if (section == 0) {
        return self.hotColumnsArray.count;
    }
    //缩略显示好友的个数 只显示一个
    if (section ==1) {
        return 1;
    }
    
#warning 可能存在bug 当数组为0 时  section少1 导致对齐错乱  所以用三目来算下是否有 没有返回下一个  //不用这种方式  用高度来控制
    if (section == 2) {
//        return self.textPostsArray.count ? self.textPostsArray.count:(self.imagePostsArray.count ? self.imagePostsArray.count :self.videoPostsArray.count);
        return self.textPostsArray.count;
    }
    if (section == 3) {
//        return self.imagePostsArray.count ? self.imagePostsArray.count :self.videoPostsArray.count;
        return self.imagePostsArray.count;
    }
    if (section == 4) {
        return self.imagePostsArray.count;
    }
    return 0;
}

/** 某行的cell*/
- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFirendLineExpand) {
        LBNHSearchFriendsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"friendsCell"];
        if (!cell) {
            cell = [[LBNHSearchFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendsCell"];
        }
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    //热门栏目的cell
    if (indexPath.section == 0) {
        LBNHDiscoveryHotCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        if (!cell) {
            cell = [[LBNHDiscoveryHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
        }
        cell.model = self.hotColumnsArray[indexPath.row];
        return cell;
    }
    
    //缩略段友的cell
    if (indexPath.section == 1) {
        LBNHSearchLimitFriendsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"limitCell"];
        if (!cell) {
            cell = [[LBNHSearchLimitFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"limitCell"];
        }
        [cell setModelsArray:self.dataArray keyWords:self.keyWords];
    }
    
    LBNHSearchPostsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell"];
    if (!cell) {
        cell = [[LBNHSearchPostsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"postCell"];
    }
    if (indexPath.section == 2) {
        cell.group = self.textPostsArray[indexPath.row];
    }else if (indexPath.section ==3){
        cell.group = self.imagePostsArray[indexPath.row];
    }else if (indexPath.section == 4){
        cell.group = self.videoPostsArray[indexPath.row];
    }
    return cell;
}

/** 点击某行*/
- (void)lb_didSelectedCellAtIndexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)tableViewCell{
    
}

- (CGFloat)lb_heightAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFirendLineExpand) {
        return 75;
    }
    if (indexPath.section == 0) {
        return 75;
    }
    if (indexPath.section == 1) {
        if (self.dataArray.count ==1) {
            return 75;
        }else{
            return 150;
        }
    }
    
    
    
    return 0;
}

/** 某个组头*/
- (UIView *)lb_headerAtSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    label.backgroundColor = kCommonGrayTextColor;
    label.textColor = kCommonBlackColor;
    label.font = kFont(14);
    if (self.isFirendLineExpand) {
        label.text = @"段友搜索";
    }
    if (section == 0) {
        label.text = @" 热门栏目";
    }
    if (section ==1) {
        label.text = @" 段友";
    }
    if (section == 2) {
        label.text = @"文字帖子";
    }
    if (section == 3) {
        label.text = @"图片帖子";
    }
    if(section == 4){
        label.text = @"视频帖子";
    }
    return label;
    return [UIView new];
}

/** 某个组头高度*/
- (CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section{
    if (self.isFirendLineExpand) {
        return 44;
    }
    if (section == 0) {
        return self.hotColumnsArray.count ? 44 :0;
    }
    if (section == 1) {
        return self.dataArray.count ? 44 :0;
    }
    if (section == 2) {
        return self.textPostsArray.count ? 44 :0;
    }
    if (section == 3) {
        return self.imagePostsArray.count ? 44 :0;
    }
    if (section == 4) {
        return self.videoPostsArray.count ? 44 :0;
    }
    
    return 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(LBCustomTextField *)leftTextField{
    if (!_leftTextField) {
        _leftTextField = [[LBCustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 80, 30) pleaceHolder:@"输入内容" pleaceHolderColor:kCommonGrayTextColor textColor:kCommonBlackColor leftImage:nil rightImage:nil leftMargin:10.f];
        _leftTextField.delegate = self;
    }
    return _leftTextField;
}

-(LBNHCustomNoDataEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[LBNHCustomNoDataEmptyView alloc] initWithTitle:@"" image:ImageNamed(@"searchmore") desc:@"动动麒麟臂，搜段友，搜更多精彩内容"];
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

#pragma mark textField的代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self searchWithText:textField.text];
    return YES;
}

-(void)textFiledChanged:(NSNotification *)notification{
    //根据textField是不是第一响应来判断
    if ([self.leftTextField isFirstResponder]) {
        [self.leftTextField showRightImageView:self.leftTextField.text.length > 0 ? YES : NO];
    }
}

#pragma mark 添加 移除textField改变通知
-(void)addObserverNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)removeObserverNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


-(void)dealloc{
    [self removeObserverNotifications];
}

@end
