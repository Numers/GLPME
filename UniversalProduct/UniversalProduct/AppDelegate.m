//
//  AppDelegate.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/4/24.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "AppDelegate.h"
#import "AppStartManager.h"
#import "LaunchAnimateView.h"

#import "MiPushSDK.h"

#import "PushMessageManager.h"
#import "GeneralManager.h"
#import "HomeForCustomerViewController.h"
#import "HomeForStaffViewController.h"
#import "UPPresentWebViewController.h"

@interface AppDelegate ()<
MiPushSDKDelegate,
UIApplicationDelegate,
UNUserNotificationCenterDelegate
>
{
    LaunchAnimateView *view;
    BOOL didClickPushBar;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [TBCityIconFont setFontName:@"iconfont"];
    self.needShowUpdateAlert = YES;
    didClickPushBar = NO;
    // 处理点击通知打开app的逻辑
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){//推送信息
        [self receivePushMessage:userInfo isLaunched:NO];
    }
    
    [[AppStartManager shareManager] startApp];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor colorFromHexString:ThemeHexColor];
//    [self startUpAnimateView];
    
    [MiPushSDK registerMiPush:self];
    return YES;
}

-(void)startUpAnimateView
{
    //开始
    view = [[LaunchAnimateView alloc] initWithFrame:self.window.bounds];
    [self.window addSubview:view];
    [self.window bringSubviewToFront:view];  //放到最顶层;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: view cache:YES];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
        view.alpha = 0.f;
        [UIView commitAnimations];
    });
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [view removeFromSuperview];
}

-(void)receivePushMessage:(id)data isLaunched:(BOOL)isLaunched
{
    NSDictionary *dic = [AppUtils objectWithJsonString:data];
    if (dic) {
        NSInteger flag = [[dic objectForKey:@"flag"] integerValue];
        switch (flag) {
            case 1:
            {
                
            }
                break;
            case 2:
            {
                NSString *url = [dic objectForKey:@"url"];
                [[PushMessageManager shareManager] addPushMessage:[dic objectForKey:@"data"] platformUrl:url withType:PushMessage];
                if (isLaunched) {
                    if (didClickPushBar) {
                        didClickPushBar = NO;
                        UIViewController *vc = [[AppStartManager shareManager] topViewController];
                        
                        if ([vc isKindOfClass:[HomeForStaffViewController class]]) {
                            HomeForStaffViewController *homeVC = (HomeForStaffViewController *)vc;
                            [homeVC pushPlatformPageWithAnimated:YES];
                        }
                        
                        if ([vc isKindOfClass:[HomeForCustomerViewController class]]) {
                            HomeForCustomerViewController *homeVC = (HomeForCustomerViewController *)vc;
                            [homeVC pushPlatformPageWithAnimated:YES];
                        }
                    }else{
                        
                    }
                }
            }
                break;
            case 3:
            {
                NSString *url = [dic objectForKey:@"url"];
                NSString *title = [dic objectForKey:@"title"];
                if (isLaunched) {
                    if (didClickPushBar) {
                        didClickPushBar = NO;
                        UIViewController *vc = [[AppStartManager shareManager] topViewController];
                        if ([vc isKindOfClass:[HomeForCustomerViewController class]]) {
                            UPPresentWebViewController *presentWebVC = [[UPPresentWebViewController alloc] init];
                            presentWebVC.loadUrl = url;
                            presentWebVC.navTitle = title;
                            [vc.navigationController pushViewController:presentWebVC animated:YES];
                        }
                        
                        if ([vc isKindOfClass:[HomeForStaffViewController class]]) {
                            UPPresentWebViewController *presentWebVC = [[UPPresentWebViewController alloc] init];
                            presentWebVC.loadUrl = url;
                            presentWebVC.navTitle = title;
                            [vc.navigationController pushViewController:presentWebVC animated:YES];
                        }
                    }else{
                        
                    }
                    
                }else{
                    NSDictionary *mDic = nil;
                    if (title) {
                         mDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", nil];
                    }
                    [[PushMessageManager shareManager] addPushMessage:mDic platformUrl:url withType:WebViewMessage];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark 注册push服务.
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    // 注册APNS失败.
    // 自行处理.
}

#pragma mark MiPushSDKDelegate

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
    // 可在此获取regId
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        NSLog(@"regid = %@", data[@"regid"]);
        _regId = data[@"regid"];
//        [[GeneralManager defaultManager] sendRegID];
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    // 请求失败
}

#pragma mark Local And Push Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 当同时启动APNs与内部长连接时, 把两处收到的消息合并. 通过miPushReceiveNotification返回
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
}

- ( void )miPushReceiveNotification:( NSDictionary *)data
{
    // 长连接收到的消息。消息格式跟APNs格式一样
    [self receivePushMessage:data isLaunched:YES];
}

// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        didClickPushBar = NO;
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    //    completionHandler(UNNotificationPresentationOptionAlert);
}

// 应用在后台收到通知,点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        didClickPushBar = YES;
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
    if (self.needShowUpdateAlert) {
        [[GeneralManager defaultManager] getNewAppVersion];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    return YES;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //透传信息
}
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"UniversalProduct"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
