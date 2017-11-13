//
//  UPWebViewJavascriptBridge.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/5.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPWebViewJavascriptBridge.h"
#import "AppStartManager.h"
#import "UPBMKLocationManager.h"

static BOOL isLogout = NO;
@implementation UPWebViewJavascriptBridge
-(void)registerEvent
{
    [self registerHandler:@"setTabBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            if ([self.delegate respondsToSelector:@selector(showTabBar:)]) {
                [self.delegate showTabBar:dic];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"willSelectTabBarItem" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            if ([self.delegate respondsToSelector:@selector(selectTabBarItem:)]) {
                [self.delegate selectTabBarItem:dic];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"presentWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            if ([self.delegate respondsToSelector:@selector(presentWebView:)]) {
                [self.delegate presentWebView:dic];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"setNavigationItem" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            if ([self.delegate respondsToSelector:@selector(setNavigationItem:)]) {
                [self.delegate setNavigationItem:dic];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"setMenuItemData" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSArray *arr = [self objectFromJsonString:data];
        if (arr) {
            if ([self.delegate respondsToSelector:@selector(setMenuItemData:)]) {
                [self.delegate setMenuItemData:arr];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"filePreviewer" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSArray *arr = [self objectFromJsonString:data];
        if (arr) {
            if ([self.delegate respondsToSelector:@selector(filePreviewer:)]) {
                [self.delegate filePreviewer:arr];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"playVideo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            if ([self.delegate respondsToSelector:@selector(playVideo:)]) {
                [self.delegate playVideo:dic];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    isLogout = NO;
    [self registerHandler:@"loginout" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (isLogout) {
            return;
        }
        isLogout = YES;
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            id alert = [dic objectForKey:@"alert"];
            if (alert && [alert boolValue]) {
                if ([self.delegate respondsToSelector:@selector(loginout:callback:)]) {
                    [self.delegate loginout:[alert boolValue] callback:^(BOOL success) {
                        if (success) {
                            [self callbackSuccess:@"退出登录成功" data:nil callback:responseCallback];
                        }else{
                            isLogout = NO;
                            [self callbackFailed:@"退出登录失败" callback:responseCallback];
                        }
                    }];
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(loginout:callback:)]) {
                    [self.delegate loginout:NO callback:^(BOOL success) {
                        if (success) {
                            [self callbackSuccess:@"退出登录成功" data:nil callback:responseCallback];
                        }else{
                            isLogout = NO;
                            [self callbackFailed:@"退出登录失败" callback:responseCallback];
                        }
                    }];
                }
            }
        }
        
        
    }];
    
    [self registerHandler:@"showMsg" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            NSString *msg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]];
            if (![AppUtils isNullStr:msg]) {
                [AppUtils showInfo:msg];
                [self callbackSuccess:@"成功" data:nil callback:responseCallback];
            }else{
                [self callbackFailed:@"提示信息为空" callback:responseCallback];
            }
        }else{
            [self callbackFailed:@"json数据有问题" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"goHome" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([self.delegate respondsToSelector:@selector(goHome)]) {
            [self.delegate goHome];
        }
        [self callbackSuccess:nil data:nil callback:responseCallback];
    }];
    
    [self registerHandler:@"callPlatform" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            if ([self.delegate respondsToSelector:@selector(callPlatform:)]) {
                [self.delegate callPlatform:dic];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"getVersionInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *version = [AppUtils appVersion];
        NSDictionary *responseDic = [NSDictionary dictionaryWithObjectsAndKeys:version,@"version",@"ios",@"deviceInfo", nil];
        [self callbackSuccess:nil data:responseDic callback:responseCallback];
    }];
    
    [self registerHandler:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        Member *host = [[AppStartManager shareManager] currentMember];
        if (host && host.userInfo) {
            NSDictionary *responseDic = [NSDictionary dictionaryWithObjectsAndKeys:host.userInfo,@"userInfo", nil];
            [self callbackSuccess:nil data:responseDic callback:responseCallback];
        }else{
            [self callbackFailed:@"无相关用户信息" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"getLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *locationInfo = [[UPBMKLocationManager shareManager] locationInfo];
        if (locationInfo) {
            [self callbackSuccess:nil data:locationInfo callback:responseCallback];
        }else{
            [self callbackFailed:@"未获取位置信息" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"setProgress" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            if ([self.delegate respondsToSelector:@selector(setProgress:)]) {
                [self.delegate setProgress:dic];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"setBadgeDot" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            if ([self.delegate respondsToSelector:@selector(setBadgeDot:)]) {
                [self.delegate setBadgeDot:dic];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
    
    [self registerHandler:@"getCalendar" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = [self objectFromJsonString:data];
        if (dic) {
            if ([self.delegate respondsToSelector:@selector(showDatePicker:)]) {
                [self.delegate showDatePicker:dic];
            }
            [self callbackSuccess:nil data:nil callback:responseCallback];
        }else{
            [self callbackFailed:@"json格式有误" callback:responseCallback];
        }
    }];
}

-(void)setPopViewItemData:(id)data
{
    NSString *jsonStr = [self jsonStringFromObject:data];
    [self callHandler:@"setPopViewItemData" data:jsonStr responseCallback:^(id responseData) {
        
    }];
}

-(void)addKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)removeKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardDidShow:(NSNotification *)notify
{
    NSDictionary *userInfo = [notify userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:height],@"height", nil];
    NSString *jsonStr = [self jsonStringFromObject:dic];
    [self callHandler:@"keyboardShow" data:jsonStr responseCallback:^(id responseData) {
        NSLog(@"%@",responseData);
    }];
}

-(void)keboardDidHidden:(NSNotification *)notify
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.f],@"height", nil];
    NSString *jsonStr = [self jsonStringFromObject:dic];
    [self callHandler:@"keyboardHidden" data:jsonStr responseCallback:^(id responseData) {
        NSLog(@"%@",responseData);
    }];
}

-(void)goback
{
    [self callHandler:@"goBack" data:nil responseCallback:^(id responseData) {

    }];
}

-(void)selectMenuItem:(id)data
{
    if (data) {
        NSString *jsonStr = [self jsonStringFromObject:data];
        [self callHandler:@"selectMenuItem" data:jsonStr responseCallback:^(id responseData) {
            
        }];
    }
}

-(void)selectTabBarItem:(id)data
{
    if (data) {
        NSString *jsonStr = [self jsonStringFromObject:data];
        [self callHandler:@"selectTabBarItem" data:jsonStr responseCallback:^(id responseData) {
            
        }];
    }
}

-(void)setPushInfo:(id)data
{
    if (data) {
        NSString *jsonStr = [self jsonStringFromObject:data];
        [self callHandler:@"setPushInfo" data:jsonStr responseCallback:^(id responseData) {
            
        }];
    }
}

-(void)setListData:(id)data
{
    if (data) {
        NSString *jsonStr = [self jsonStringFromObject:data];
        [self callHandler:@"setListData" data:jsonStr responseCallback:^(id responseData) {
            
        }];
    }
}

-(void)setCalendar:(id)data
{
    if (data) {
        NSString *jsonStr = [self jsonStringFromObject:data];
        [self callHandler:@"setCalendar" data:jsonStr responseCallback:^(id responseData) {
            
        }];
    }
}
#pragma -mark private functions
-(id)objectFromJsonString:(NSString *)jsonString
{
    if (!jsonString)
    {
        return nil;
    }
    
    if (![jsonString isKindOfClass:[NSString class]]) {
        return jsonString;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id params = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:NSJSONReadingMutableContainers
                                                  error:&err];
    
    if (err)
    {
        return nil;
    }
    return params;
}

-(NSString *)jsonStringFromObject:(id)obj
{
    if (!obj) {
        return nil;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(void)callbackSuccess:(NSString *)msg data:(id)data callback:(WVJBResponseCallback)callback
{
    NSMutableDictionary *statusDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"status", nil];
    if (msg) {
        [statusDic setObject:msg forKey:@"msg"];
    }
    
    if (data) {
        [statusDic setObject:data forKey:@"data"];
    }
    NSString *jsonStr = [self jsonStringFromObject:statusDic];
    callback(jsonStr);
}

-(void)callbackFailed:(NSString *)msg callback:(WVJBResponseCallback)callback
{
    NSMutableDictionary *statusDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"status", nil];
    if (msg) {
        [statusDic setObject:msg forKey:@"msg"];
    }
    NSString *jsonStr = [self jsonStringFromObject:statusDic];
    callback(jsonStr);
}
@end
