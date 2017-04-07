//
//  LBNHBaseModel.m
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseModel.h"
#import "MJExtension.h"
#import "LBNHFileCacheManager.h"

@implementation LBNHBaseModel

//添加了下面的宏定义
MJExtensionCodingImplementation

/* 实现下面的方法，说明哪些属性不需要归档和解档 */
//+ (NSArray *)mj_ignoredCodingPropertyNames{
//    return @[@"name"];
//}

/**
 key替换
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",
             @"desc":@"description",
             @"responseData" : @"data"
             };
}

-(void)archive{
    [LBNHFileCacheManager saveObjcet:self byFileName:[self description]];
}

-(id)unArchive{
    return [LBNHFileCacheManager getObjectByFileName:[self description]];
}

-(void)remove{
    [LBNHFileCacheManager removeObjectByFileName:[self description]];
}

/**
 字典数组 转模型数组的
 */
+(NSMutableArray *)modelArrayWithArray:(NSArray *)response{
    //1.进行参数判断  防止不是数组崩溃
    if ([response isKindOfClass:[NSArray class]]) {
        return [self mj_objectArrayWithKeyValuesArray:response];
    }
    return  [NSMutableArray new];
}


/**
 字典转模型的
 */
+(id)modelWithDictionary:(NSDictionary *)dictionary{
    //1.进行参数判断  防止不是字典崩溃
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        return [self mj_objectWithKeyValues:dictionary];
    }
    return [[self alloc] init];
}


/**
 *  模型包含模型数组
 */
+ (void)setUpModelClassInArrayWithContainDict:(NSDictionary *)dict{
    if (dict.allKeys.count == 0) {
        return ;
    }
    [self mj_setupObjectClassInArray:^NSDictionary *{
        return dict;
    }];
}

@end
