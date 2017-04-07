//
//  AppDelegate.m
//  nhExample
//
//  Created by liubin on 17/3/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "AppDelegate.h"
#import "LBNHTabbarViewController.h"
#import "NSFileManager+LBPath.h"
#import "SDImageCache.h"
#import "YYWebImageManager.h"
#import "YYDiskCache.h"
#import "YYMemoryCache.h"

#import "NSArray+LBCalculate.h"

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
    return YES;
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
    self.window.rootViewController = [[LBNHTabbarViewController alloc] init];
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
