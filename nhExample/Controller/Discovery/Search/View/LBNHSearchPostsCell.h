//
//  LBNHSearchPostsCell.h
//  nhExample
//
//  Created by liubin on 17/4/7.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeTableViewCell.h"
@class LBNHHomeServiceDataElementGroup;

/**
 * 搜索界面的cell  集成home界面的cell
 */
@interface LBNHSearchPostsCell : LBNHHomeTableViewCell

@property (nonatomic, strong) LBNHHomeServiceDataElementGroup *group;

@end
