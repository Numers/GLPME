//
//  UPWebViewJavascriptBridge.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/5.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>
@protocol UPWebViewJavascriptBridgeProtocol <NSObject>
-(void)showTabBar:(id)data;
-(void)selectTabBarItem:(id)data;
-(void)setNavigationItem:(id)data;
-(void)presentWebView:(id)data;
-(void)setMenuItemData:(id)data;
-(void)filePreviewer:(id)data;
-(void)playVideo:(id)data;
-(void)loginout:(BOOL)alert callback:(void(^)(BOOL success))callback;
-(void)goHome;
-(void)callPlatform:(id)data;
-(void)setProgress:(id)data;
-(void)setBadgeDot:(id)data;
-(void)showDatePicker:(id)data;
@end
@interface UPWebViewJavascriptBridge : WKWebViewJavascriptBridge
@property(nonatomic,assign) id<UPWebViewJavascriptBridgeProtocol> delegate;

-(void)registerEvent;

-(void)addKeyboardObserver;
-(void)removeKeyboardObserver;
-(void)setPopViewItemData:(id)data;
-(void)goback;
-(void)selectMenuItem:(id)data;
-(void)selectTabBarItem:(id)data;
-(void)setPushInfo:(id)data;
-(void)setListData:(id)data;
-(void)setCalendar:(id)data;
@end
