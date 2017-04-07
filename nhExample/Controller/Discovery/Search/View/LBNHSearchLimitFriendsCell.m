//
//  LBNHSearchLimitFriendsCell.m
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHSearchLimitFriendsCell.h"
#import "LBNHBaseImageView.h"
#import "LBNHHomeServiceDataModel.h"
#import "LBImageTitleButton.h"
#import "UIView+LBTap.h"
@interface LBNHSearchLimitFriendsCell()


@end

@implementation LBNHSearchLimitFriendsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)setModelsArray:(NSArray *)modelsArray keyWords:(NSString *)keyWords{
    //最多显示5个 上面一个 下面4个
    NSInteger count = modelsArray.count > 5 ? 5 :modelsArray.count;
    //因为不会回收这个cell  我们移除在创建  效果也可以
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    //一列显示4个  以及间距
    int column = 4;
    CGFloat itemWidth = 75;
    CGFloat itemMargin = (kScreenWidth - column*itemWidth)/(column +1);
    
    for (int i =0; i<count; i++) {
        LBNHHomeServiceDataElementGroup *group = modelsArray[i];
        //第一个显示 单独一行
        if (i ==0 ) {
            CGFloat margin = 15;
            LBNHBaseImageView *imageView = [[LBNHBaseImageView alloc] init];
            imageView.frame = CGRectMake(margin, margin, 44, 44);
            imageView.layerCornerRadius = 44/2;
            [imageView setImagePath:group.user.avatar_url];
            [imageView addTapBlock:^{
                
            }];
            [self.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + margin, margin, kScreenWidth - 44 - margin*3, 20);
            label.text = group.user.name;
            label.textColor = kCommonBlackColor;
            label.font = kFont(14);
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:label.text];
            NSRange range = [label.text rangeOfString:keyWords];
            [attributeString addAttributes:@{NSForegroundColorAttributeName : [[UIColor redColor] colorWithAlphaComponent:0.8]} range:range];
            label.attributedText = attributeString;
            [self.contentView addSubview:label];
            
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(0, 74, kScreenWidth, 0.8);
            lineLayer.backgroundColor = kCommonTintColor.CGColor;
            [self.contentView.layer addSublayer:lineLayer];
        }
        //最后一个显示的
        else if (i == count-1){
            LBImageTitleButton *button = [[LBImageTitleButton alloc] init];
            CGFloat btnX = itemMargin +(count - 1 -1)*(itemMargin + itemWidth);
            CGFloat btnY = 0;
            CGFloat btnW = itemWidth;
            CGFloat btnH = itemWidth;
            button.frame = CGRectMake(btnX, btnY, btnW, btnH);
            button.titleLabel.font = kFont(14);
            button.titleLabel.textColor = kCommonBlackColor;
            [button setImage:ImageNamed(@"morefriends") forState:UIControlStateNormal];
            [button setTitle:@"更多段友" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(moreFriends:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }else{
            LBImageTitleButton *button = [[LBImageTitleButton alloc] init];
            CGFloat btnX = itemMargin +(count - 1 -1)*(itemMargin + itemWidth);
            CGFloat btnY = 0;
            CGFloat btnW = itemWidth;
            CGFloat btnH = itemWidth;
            button.titleLabel.font = kFont(14);
            button.titleLabel.textColor = kCommonBlackColor;
            button.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:button.titleLabel.text];
            NSRange range = [button.titleLabel.text rangeOfString:keyWords];
            [attributeString addAttributes:@{NSForegroundColorAttributeName : [[UIColor redColor] colorWithAlphaComponent:0.8]} range:range];
            button.titleLabel.attributedText = attributeString;
            [button setTitle:group.user.name forState:UIControlStateNormal];
            button.tag = 100+i;
            [button addTarget:self action:@selector(friendsItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
    }
}


-(void)friendsItemClicked:(UIButton *)button{
    NSLog(@"button index is %d ",button.tag);
}


-(void)moreFriends:(UIButton *)button{
    NSLog(@"moreFriends moreFriends moreFriends");
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
