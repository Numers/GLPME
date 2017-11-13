//
//  UPBMKLocationManager.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/9.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPBMKLocationManager.h"

@implementation UPBMKLocationManager
+(instancetype)shareManager
{
    static UPBMKLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UPBMKLocationManager alloc] init];
    });
    return manager;
}

-(void)startUpdatingLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        //初始化BMKLocationService
        locationManager = [[BMKLocationService alloc]init];
        locationManager.delegate = self;
        //指定精确度
        [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //指定位移触发定位距离
        [locationManager setDistanceFilter:10.0f];
        [locationManager startUserLocationService];
    }
}

-(NSDictionary *)locationInfo
{
    NSDictionary *dic = nil;;
    if (locationManager.userLocation) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@(locationManager.userLocation.location.coordinate.latitude),@"lat",@(locationManager.userLocation.location.coordinate.longitude),@"lng", nil];
    }
    return dic;
}

#pragma -mark CLLocaitonManagerDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    curLocation = userLocation;
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationHasUpdatingNotification object:nil];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
    [locationManager stopUserLocationService];
}
@end
