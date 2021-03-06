//
//  AppStartManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "AppStartManager.h"
#import "AppDelegate.h"
#import "MiPushSDK.h"
#import "GeneralManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AppLaunchManager.h"
#import "PushMessageManager.h"
#import "UPBMKLocationManager.h"

#import "UPLoginScrollViewController.h"
#import "HomeForCustomerViewController.h"
#import "HomeForStaffViewController.h"
#import "UPGuidIntroViewController.h"
#import "UINavigationController+NavigationBar.h"
#import "UIColor+HexString.h"

#import "UPDrawerViewController.h"

#define HostProfilePlist @"PersonProfile.plist"
@implementation AppStartManager
+(instancetype)shareManager
{
    static AppStartManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppStartManager alloc] init];
    });
    return manager;
}


/**
 返回当前登录的用户
 
 @return 登录用户
 */
-(Member *)currentMember
{
    if (host == nil) {
        host = [self getProfileFromPlist];
    }
    return host;
}

/**
 设置记录当前登录的用户
 
 @param member 登录用户
 */
-(void)setMember:(Member *)member
{
    if (member) {
        host = member;
        [self saveProfileToPlist];
    }
}


/**
 移除本地用户数据
 */
-(void)removeLocalHostMemberData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    host = nil;
}


/**
 将登录用户信息保存本地
 */
-(void)saveProfileToPlist
{
    NSDictionary *dic = [host dictionaryInfo];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    [dic writeToFile:selfInfoPath atomically:YES];
}


/**
 获取本地登录用户信息

 @return 在本地登录过的用户信息
 */
-(Member *)getProfileFromPlist
{
    Member *member = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:selfInfoPath];
        if (dic != nil) {
            member = [[Member alloc] initWithDictionary:dic];
        }
    }
    return member;
}

/**
 app启动时处理事件
 */
-(void)startApp
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
//                [AppUtils showInfo:@"未知网络类型"];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
//                [AppUtils showInfo:@"网络正在开小差"];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e621", IconfontGoBackDefaultSize, [UIColor colorFromHexString:ThemeHexColor])]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e621", IconfontGoBackDefaultSize, [UIColor colorFromHexString:ThemeHexColor])]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[GeneralManager defaultManager] getGlovalVarWithVersion];
    [[UPBMKLocationManager shareManager] startUpdatingLocation];
    [self currentMember];
    if (host) {
        NSString *autoLogin = [AppUtils localUserDefaultsForKey:KMY_AutoLogin];
        if ([autoLogin isEqualToString:@"1"]) {
            [self setHomeView];
        }else{
            [self setLoginView];
        }
    }else{
        [self setGuidView];
    }
}

-(void)navColor
{
    if (_navigationController) {
        [_navigationController setNavigationViewColor:[UIColor whiteColor]];
    }
}

/**
 返回当前navigationController的最上面的ViewController
 
 @return ViewController
 */
-(UIViewController *)topViewController
{
    return _navigationController?_navigationController.topViewController:nil;
}

-(void)setHomeView
{
    if (host.role == StaffRole) {
        HomeForStaffViewController *homeVC = [[HomeForStaffViewController alloc] init];
        _navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    }else if(host.role == CustomerRole){
        HomeForCustomerViewController *homeVC = [[HomeForCustomerViewController alloc] init];
        _navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    }else{
        [self setLoginView];
    }
    
    [self navColor];
}

-(void)pushHomeView
{
    if (host.role == StaffRole) {
        HomeForStaffViewController *homeVC = [[HomeForStaffViewController alloc] init];
        [_navigationController pushViewController:homeVC animated:YES];
    }else if(host.role == CustomerRole){
        HomeForCustomerViewController *homeVC = [[HomeForCustomerViewController alloc] init];
        [_navigationController pushViewController:homeVC animated:YES];
    }
}

-(void)setGuidView
{
    UPGuidIntroViewController *guidIntroVC = [[UPGuidIntroViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:guidIntroVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    
    [self navColor];
}

-(void)setLoginView
{
    UPLoginScrollViewController *loginScrollVC = [[UPLoginScrollViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:loginScrollVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    
    [self navColor];
}

-(void)pushDrawerView
{
    UPDrawerViewController *drawerVC = [[UPDrawerViewController alloc] init];
    [self.navigationController pushViewController:drawerVC animated:YES];
}

-(void)setDrawerView
{
    UPDrawerViewController *drawerVC = [[UPDrawerViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:drawerVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    
    [self navColor];
}


/**
 app退出登录时处理事件
 */
-(void)loginout
{
    if (_navigationController) {
        [_navigationController popToRootViewControllerAnimated:NO];
        _navigationController = nil;
    }
    [AppUtils localUserDefaultsValue:@"0" forKey:KMY_AutoLogin];
    [self setLoginView];
}
@end
