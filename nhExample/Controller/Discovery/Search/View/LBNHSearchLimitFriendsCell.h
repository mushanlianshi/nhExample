//
//  LBNHSearchLimitFriendsCell.h
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 缩略段友显示的cell
 */
@interface LBNHSearchLimitFriendsCell : UITableViewCell

/** 设置数据 以及要高亮的keywords */
-(void) setModelsArray:(NSArray *)modelsArray  keyWords:(NSString *)keyWords;

@end
