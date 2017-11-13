//
//  UPPresentWebViewJavascriptBridge.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/22.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>
@protocol UPPresentWebViewJavascriptBridgeProtocol <NSObject>
-(void)closeWebView:(void(^)(BOOL success))callback;
-(void)setNavigationItem:(id)data;
-(void)showTabBar:(id)data;
-(void)selectTabBarItem:(id)data;
-(void)presentWebView:(id)data;
-(void)filePreviewer:(id)data;
-(void)playVideo:(id)data;
-(void)loginout:(BOOL)alert callback:(void(^)(BOOL success))callback;
-(void)goHome;
-(void)callPlatform:(id)data;
-(void)setProgress:(id)data;
-(void)showDatePicker:(id)data;
@end
@interface UPPresentWebViewJavascriptBridge : WKWebViewJavascriptBridge
@property(nonatomic, assign) id<UPPresentWebViewJavascriptBridgeProtocol> delegate;

-(void)registerEvent;

-(void)addKeyboardObserver;
-(void)removeKeyboardObserver;
-(void)setPopViewItemData:(id)data;
-(void)goback;
-(void)selectTabBarItem:(id)data;
-(void)setCalendar:(id)data;
@end
