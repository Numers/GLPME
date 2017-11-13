//
//  UPPresentWebViewController.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/11.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <KINWebBrowser/KINWebBrowserViewController.h>
@interface UPPresentWebViewController : KINWebBrowserViewController
@property(nonatomic, copy) NSString *loadUrl;
@property(nonatomic, copy) NSString *navTitle;
@end
