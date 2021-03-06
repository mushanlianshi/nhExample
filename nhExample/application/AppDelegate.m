//
//  AppDelegate.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "AppDelegate.h"
#import "LBBaseNavigationViewController.h"
#import "LBNHTabbarViewController.h"
#import "NSFileManager+LBPath.h"
#import "SDImageCache.h"
#import "YYWebImageManager.h"
#import "YYDiskCache.h"
#import "YYMemoryCache.h"

#import "NSArray+LBCalculate.h"
#import "LBUtils.h"
#import "LBNHFileCacheManager.h"
#import "LBNHBaseRequest.h"
#import "LBSDImageCache.h"
#import "LBCustomADView.h"
#import "LBWebViewController.h"
#import "LBGCDUtils.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setHomeBarController];
    
    NSLog(@"Path caches is %@ ",[NSFileManager cachesPath]);
    NSLog(@"Path caches is %@ ",[NSFileManager cachesURL]);
    NSLog(@"library caches is %@ ",[NSFileManager libraryPath]);
    NSLog(@"library caches is %@ ",[NSFileManager libraryURL]);
    NSLog(@"document caches is %@ ",[NSFileManager documentsURL]);
    NSLog(@"document caches is %@ ",[NSFileManager documentsPath]);
    NSLog(@"avalibale caches is %f ",[NSFileManager availableDiskSpace]);
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:@"" forKey:@"hha"];
//    [dic setValue:nil forKey:@"hha"];
//    [dic setValue:@"dd" forKey:@"hha"];

    
    NSLog(@"LBLog idfa ======== %@ ",[LBUtils idfa]);
    NSLog(@"LBLog idfv ======== %@ ",[LBUtils idfv]);
    NSLog(@"LBLog UUID ======== %@ ",[LBUtils uuid]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"LBLog idfa ======== %@ ",[LBUtils idfa]);
        NSLog(@"LBLog idfv ======== %@ ",[LBUtils idfv]);
        NSLog(@"LBLog UUID ======== %@ ",[LBUtils uuid]);
    });
    
    
    //每次启动清楚sdWebimage的缓存
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    //1.记录启动的时间 当下次启动的时间差大于2小时  清楚SDImageCache的缓存  
//    NSDate *date = [NSDate date];
//    long dateTimerInterval = [date timeIntervalSince1970];
//    [LBNHFileCacheManager saveUserData:@(dateTimerInterval) forKey:KAPPLaunchTime];
//    id lastDate = [LBNHFileCacheManager readUserDataForKey:KAPPLaunchTime];
//    if (lastDate) {
//        long lastTime = [lastDate longValue];
//        if (dateTimerInterval - lastTime > KAPPLaunchTimeOffset) {
//            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
//        }
//    }
    [self requestADAndShow];
    [LBUtils saveLastLaunchAPPTime];
    return YES;
}

-(void)requestADAndShow{
    //判断下 两次启动时间间隔如果大于一星期  就先不显示   以免显示的广告是过期的
    id object = [LBNHFileCacheManager readUserDataForKey:KAPPADInfoKey];
    NSDictionary *adDic ;
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        adDic = (NSDictionary *)object;
    }
    MyLog(@"read ad info is %@ %@ ",[object description],adDic);
    if (adDic) {
        BOOL result = [adDic[@"isOpenAds"] boolValue];
        NSString *imagePath = adDic[@"image"];
        UIImage *image = [LBSDImageCache imageFromDiskCacheForKey:imagePath];
        if (result) {
            NSLog(@"launch timeoffset is %ld ",[LBUtils lastLauchAPPToNow]);
            if (image && [LBUtils lastLauchAPPToNow] < KOneWeek) {
                //显示广告图片
                LBCustomADView *adView = [[LBCustomADView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                WS(weakSelf);
                [adView showADViewImage:image superView:self.window limitTime:5.f clickBlock:^{
                    LBWebViewController *webViewVC = [[LBWebViewController alloc] initWithURLString:adDic[@"adUrl"] title:adDic[@"title"]];
                    //设置模态跳转的动画
                    [webViewVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//                    [weakSelf.window.rootViewController presentViewController:webViewVC animated:NO completion:nil];
                    [weakSelf.window.rootViewController presentViewController:webViewVC animated:YES completion:nil];
                }];
            }
            else{
                //下载图片
                [LBSDImageCache downLoadImageWithUrl:imagePath progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    NSLog(@"广告图片下载成功  下次启动可以显示");
                }];
            }
        }
    }
    // 每次都请求看是否有数据更新
    LBNHBaseRequest *request = [LBNHBaseRequest lb_request];
    request.lb_url = KNHADInfoAPI;
    [request lb_sendRequestWithHandler:^(BOOL success, id response, NSString *message) {
        if (success) {
//            BOOL result = [response[@"isOpenAds"] boolValue];
//            NSString *imagePath = response[@"image"];
//            NSDictionary *adDic = (NSDictionary *)response;
//            [[NSUserDefaults standardUserDefaults] setObject:adDic forKey:KAPPADInfoKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:KAPPADInfoKey];
//            NSLog(@"dic i s %@ ",dic);
            [LBNHFileCacheManager saveUserData:response forKey:KAPPADInfoKey];
//            [LBNHFileCacheManager saveUserData:response forKey:KAPPADInfoKey];
        }
    }];
}


-(void)testGCDGroup{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("currentThread", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        //        NSLog(@"1===== start ");
        //        [NSThread sleepForTimeInterval:2.f];
        //        NSLog(@"1===== end ");
        [self testMoniRequest:^{
            NSLog(@"1======END");
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        //        NSLog(@"1===== start ");
        //        [NSThread sleepForTimeInterval:2.f];
        //        NSLog(@"1===== end ");
        [self testMoniRequest:^{
            NSLog(@"2======END");
            dispatch_group_leave(group);
        }];
    });
    
//    dispatch_group_async(group, queue, ^{
//        [self testMoniRequest:^{
//            NSLog(@"2======END");
//        }];
////        NSLog(@"2===== start ");
////        [NSThread sleepForTimeInterval:2.f];
////        NSLog(@"2===== end ");
//    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"group is end ======");
    });
    
}

-(void)testMoniRequest:(dispatch_block_t)block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1 testMoniRequest = ======= start");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"1 testMoniRequest = ======= end");
        block();
        
    });
}

-(void)setHomeBarController{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    LBNHTabbarViewController *tabbarVC = [[LBNHTabbarViewController alloc] init];
//    LBBaseNavigationViewController *navi = [[LBBaseNavigationViewController alloc] initWithRootViewController:tabbarVC];
    self.window.rootViewController = tabbarVC;
    [self.window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[[YYWebImageManager sharedManager] cache].diskCache removeAllObjects];
    [[[YYWebImageManager sharedManager] cache].memoryCache removeAllObjects];
}

@end

//add for 状态栏方向调整
@implementation UINavigationController (Rotation)

- (BOOL)shouldAutorotate
{
    NSLog(@"LBLog shouldAutorotate %d ",[[self.viewControllers lastObject] shouldAutorotate]);
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"LBLog supportedInterfaceOrientations count i s %ld ",(unsigned long)[[self.viewControllers lastObject] supportedInterfaceOrientations]);
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
@end

//add for 状态栏方向调整
@implementation UITabBarController (Rotation)

- (BOOL)shouldAutorotate
{
    NSLog(@"LBLog shouldAutorotate %d ",[[self.viewControllers lastObject] shouldAutorotate]);
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"LBLog supportedInterfaceOrientations count i s %ld ",(unsigned long)[[self.viewControllers lastObject] supportedInterfaceOrientations]);
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
@end
