//
//  UPWebBrowserViewController.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/5.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <KINWebBrowser/KINWebBrowserViewController.h>
@protocol UPWebBrowserViewProtocol <NSObject>
-(void)setMenuItemData:(id)data;
-(void)loginout;
-(void)goHome;
-(void)previewerFile:(id)data;
-(void)pushWebView:(NSString *)url withTitle:(NSString *)title;
@end
@interface UPWebBrowserViewController : KINWebBrowserViewController
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *platformName;
@property(nonatomic, assign) id<UPWebBrowserViewProtocol> myDelegate;

-(void)selectMenuItem:(id)data;
@end
