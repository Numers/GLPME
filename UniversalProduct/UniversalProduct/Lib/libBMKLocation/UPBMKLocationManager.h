//
//  UPBMKLocationManager.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/9.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

#define LocationHasUpdatingNotification @"LocationHasUpdatingNotification"

@interface UPBMKLocationManager : NSObject<BMKLocationServiceDelegate>
{
    BMKLocationService *locationManager;
    BMKUserLocation *curLocation;
}
+(instancetype)shareManager;
-(void)startUpdatingLocation;
-(NSDictionary *)locationInfo;
@end
