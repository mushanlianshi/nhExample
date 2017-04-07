//
//  LBNHDetailViewController.h
//  nhExample
//
//  Created by liubin on 17/3/24.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHHomeCellFrame.h"
#import "LBBaseTableViewController.h"


/**
 * 详细内容的controller
 */
@interface LBNHDetailViewController : LBBaseTableViewController


/** 通过cellframe来实例化 因为cellframe里有数据模型 */
-(instancetype)initWithCellFrame:(LBNHHomeCellFrame *)cellFrame;

@end
