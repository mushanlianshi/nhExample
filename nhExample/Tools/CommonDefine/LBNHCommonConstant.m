//
//  LBNHCommonConstant.m
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHCommonConstant.h"

@implementation LBNHCommonConstant

NSString *const KNHIsLoginFlag = @"KNHIsLoginFlag";

NSString *const KAPPLaunchTime = @"KAPPLaunchTime";

NSInteger const KAPPLaunchTimeOffset = 2*60*60;

/** 两次应用启动时间差  用来判断是否清楚SDWebimage的缓存 */
//NSString const KAPPLaunchTimeOffset;

NSString *const KAPPADInfoKey = @"KAPPADInfoKey";

NSInteger const KOneWeek = 60 * 60 * 24 * 7;
@end
