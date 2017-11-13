//
//  UPWebBrowserViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/5.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPWebBrowserViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UPFilePreviewerViewController.h"


#import "CustomerTabBarItem.h"

#import "UPWebViewJavascriptBridge.h"

#import "PushMessageManager.h"
#import "UPLoginManager.h"
#import "AppStartManager.h"

#import "UINavigationController+NavigationBar.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <WZLBadge/UITabBarItem+WZLBadge.h>

#import <MediaPlayer/MediaPlayer.h>
#import "HooDatePicker.h"


@interface UPWebBrowserViewController ()<UPWebViewJavascriptBridgeProtocol,UIWebViewDelegate,WKNavigationDelegate,PushMessageManagerProtocol,UITabBarDelegate,HooDatePickerDelegate>
{
    id popViewData;
    id datePickerData;
    id tapBarData;
    BOOL firstLoad;
    
    BOOL canOpenMenu;
    BOOL hasMenuItem;
}
@property(nonatomic, strong) UITabBar *tabBar;
@property(nonatomic, strong) HooDatePicker *datePicker;
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UPWebViewJavascriptBridge *bridge;
@end

@implementation UPWebBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    firstLoad = YES;
    canOpenMenu = NO;
    hasMenuItem = NO;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setRightBarButtonItem:nil];
    [self.navigationController setNavigationViewColor:[UIColor whiteColor]];
    [self setTintColor:[UIColor colorFromHexString:ThemeHexColor]];
    [self.progressView setTrackTintColor:[UIColor whiteColor]];
    [self.progressView setProgressTintColor:[UIColor colorFromHexString:@"#02AF00"]];
    if (_platformName) {
        self.title = _platformName;
    }else{
        self.title = @"首页";
    }
    self.showsPageTitleInNavigationBar = NO;
    
    self.bridge = [UPWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    self.bridge.delegate = self;
    [self.bridge setWebViewDelegate:self];
    [self.bridge registerEvent];
    
    
    if ([[PushMessageManager shareManager] hasMessage]) {
        [self loadMessage];
    }else{
        if ([AppUtils isNetworkURL:_url]) {
            [self loadURL:[NSURL URLWithString:_url]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    [[PushMessageManager shareManager] bind:self];
    [self.bridge addKeyboardObserver];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.bridge removeKeyboardObserver];
    [[PushMessageManager shareManager] unBind];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UIDesigner
-(void)loadSuccess:(BOOL)success
{
    if (success) {
        if (self.wkWebView) {
            [self.wkWebView setHidden:NO];
        }
        if (_bgView) {
            [_bgView setHidden:YES];
        }
    }else{
        if (self.wkWebView) {
            [self.wkWebView setHidden:YES];
        }
        if (_bgView) {
            [_bgView setHidden:NO];
        }else{
            [self addNoNetworkBackgroundView];
        }
    }
}

-(void)refreshWebView
{
    if (_bgView) {
        [_bgView setHidden:YES];
    }
    
    if (self.wkWebView) {
        [self.wkWebView setHidden:NO];
        if (![AppUtils isNullStr:self.wkWebView.URL.absoluteString]) {
            [self.wkWebView reload];
        }else{
            if ([AppUtils isNetworkURL:_url]) {
                [self loadURL:[NSURL URLWithString:_url]];
            }
        }
        
    }
}

-(void)addNoNetworkBackgroundView
{
    if (_bgView == nil) {
        UIImage *bgimage = [UIImage imageNamed:@"NoNetworkBackgroundImage"];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgimage.size.width, bgimage.size.height + 2 + 20 + 35 + 30)];
        {
            UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgimage.size.width, bgimage.size.height)];
            [bgImageView setImage:bgimage];
            [_bgView addSubview:bgImageView];
        }
        
        {
            UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, bgimage.size.height + 0.67, bgimage.size.width, 20.0f)];
            [lblDesc setFont:[UIFont systemFontOfSize:14.0f]];
            [lblDesc setTextAlignment:NSTextAlignmentCenter];
            [lblDesc setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
            [lblDesc setText:@"网络正在开小差..."];
            [_bgView addSubview:lblDesc];
        }
        
        {
            UIButton *refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 106.f, 30.0f)];
            [refreshBtn addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
            NSAttributedString *attrTitle = [[NSAttributedString alloc]initWithString:@"点击刷新" attributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#55A8FD"],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
            [refreshBtn setAttributedTitle:attrTitle forState:UIControlStateNormal];
            [refreshBtn.layer setCornerRadius:15.0f];
            [refreshBtn.layer setMasksToBounds:YES];
            [refreshBtn.layer setBorderWidth:1.0f];
            [refreshBtn.layer setBorderColor:[UIColor colorFromHexString:@"#55A8FD"].CGColor];
            [refreshBtn setCenter:CGPointMake(_bgView.frame.size.width / 2.0f, _bgView.frame.size.height - 15)];
            [_bgView addSubview:refreshBtn];
        }
        [_bgView setCenter:CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f)];
        [self.view insertSubview:_bgView atIndex:0];
    }
}

#pragma -mark private function
-(void)loadMessage
{
    id message = [[PushMessageManager shareManager] lastPushMessage];
    if (message) {
        NSString *url = [message objectForKey:@"url"];
        [self setUrl:url];
    }
}

-(void)selectMenuMode
{
    if (canOpenMenu && hasMenuItem) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    }else{
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }
}

-(void)setUrl:(NSString *)url
{
    if ([AppUtils isNetworkURL:url]) {
        _url = url;
        [self loadURL:[NSURL URLWithString:url]];
    }
}

-(void)addTabBar:(NSArray *)items
{
    if (items && items.count > 0) {
        _tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 49)];
        [_tabBar setBackgroundColor:[UIColor whiteColor]];
        _tabBar.delegate = self;
        [self.view addSubview:_tabBar];
        
        NSMutableArray *itemList = [NSMutableArray array];
        for (NSDictionary *dic in items) {
            CustomerTabBarItem *tabBarItem = [[CustomerTabBarItem alloc] initWithDictionary:dic];
            if (tabBarItem) {
                [itemList addObject:tabBarItem];
            }
        }
        [_tabBar setItems:itemList];
        
        if (itemList.count > 0) {
            [_tabBar setSelectedItem:[itemList objectAtIndex:0]];
            [self tabBar:_tabBar didSelectItem:[itemList objectAtIndex:0]];
        }
        [self showTabBar];
    }
}

-(void)showTabBar
{
    if (_tabBar) {
        [UIView animateWithDuration:0.5f animations:^{
            [_tabBar setFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)];
        } completion:^(BOOL finished) {
            if (self.wkWebView) {
                [self.wkWebView setFrame:CGRectMake(self.wkWebView.frame.origin.x, self.wkWebView.frame.origin.y, self.wkWebView.frame.size.width, self.view.bounds.size.height - 49)];
            }
        }];
    }
}

-(void)hideTabBar
{
    if (_tabBar) {
        [UIView animateWithDuration:0.5f animations:^{
            [_tabBar setFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 49)];
            if (self.wkWebView) {
                [self.wkWebView setFrame:CGRectMake(self.wkWebView.frame.origin.x, self.wkWebView.frame.origin.y, self.wkWebView.frame.size.width, self.view.bounds.size.height)];
            }

        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma -mark Notification
-(void)didReceivePushMessage
{
//    [self loadMessage];
    [[PushMessageManager shareManager] sync];
}

#pragma -mark bridge Function
-(UITabBarItem *)searchTabBarItem:(NSInteger)tag
{
    UITabBarItem *item = nil;
    if (_tabBar) {
        NSArray *items = _tabBar.items;
        if (items && items.count > 0) {
            for (UITabBarItem *bar in items) {
                if (bar.tag == tag) {
                    item = bar;
                    break;
                }
            }
        }
    }
    return item;
}

-(void)selectMenuItem:(id)data
{
    if (data) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:data,@"defaultField", nil];
        [self.bridge selectMenuItem:dic];
    }
}

- (void)playVideoWithUrl:(NSString *)url
{
    if (url && [AppUtils isNetworkURL:url]) {
        NSURL *link = [NSURL URLWithString:url];
        MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:link];
        [self presentMoviePlayerViewControllerAnimated:playerVC];
    }
}
#pragma -mark Action
-(void)leftDrawerButtonPress:(id)sender{
    if (canOpenMenu) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

-(void)clickPopViewItem
{
    [self.bridge setPopViewItemData:popViewData];
}

-(void)clickGobackBtn
{
    [self.bridge goback];
}
#pragma -mark UPWebViewJavascriptBridgeProtocol
-(void)selectTabBarItem:(id)data
{
    if (data) {
        NSInteger tag = [[data objectForKey:@"tag"] integerValue];
        UITabBarItem *item = [self searchTabBarItem:tag];
        if (item) {
            [_tabBar setSelectedItem:item];
        }
    }
}

-(void)showTabBar:(id)data
{
    if (data) {
        BOOL isShow = [[data objectForKey:@"isShow"] boolValue];
        if (isShow) {
            if (_tabBar) {
                [self showTabBar];
            }else{
                NSArray *items = [data objectForKey:@"items"];
                [self addTabBar:items];
            }
        }else{
            if (_tabBar) {
                [self hideTabBar];
            }
        }
    }
}

-(void)presentWebView:(id)data
{
    if (data) {
        NSString *url = [data objectForKey:@"url"];
        NSString *title = [data objectForKey:@"title"];
        if ([self.myDelegate respondsToSelector:@selector(pushWebView:withTitle:)]) {
            [self.myDelegate pushWebView:url withTitle:title];
        }
    }
}

-(void)setNavigationItem:(id)data
{
    if (data) {
        hasMenuItem = NO;
        BOOL isShow = [[data objectForKey:@"isShow"] boolValue];
        if (!isShow) {
            [self.navigationController setNavigationBarHidden:YES];
        }
        
        NSString *title = [data objectForKey:@"pageTitle"];
        [self setTitle:title];
        
        NSDictionary *leftItemDic = [data objectForKey:@"leftItem"];
        if (leftItemDic) {
            NSString *type = [leftItemDic objectForKey:@"type"];
            id content = [leftItemDic objectForKey:@"content"];
            NSString *action = [leftItemDic objectForKey:@"action"];
            SEL sel = nil;
            if ([@"popview" isEqualToString:action]) {
                sel = @selector(clickPopViewItem);
                popViewData = [leftItemDic objectForKey:@"data"];
            }
            
            if ([@"goback" isEqualToString:action]) {
                sel = @selector(clickGobackBtn);
            }
            
            UIBarButtonItem *leftItem;
            if ([@"text" isEqualToString:type]) {
                leftItem = [[UIBarButtonItem alloc] initWithTitle:content style:UIBarButtonItemStyleDone target:self action:sel];
            }else if ([@"image" isEqualToString:type]){
                if ([@"menu" isEqualToString:action]) {
                    Member *host = [[AppStartManager shareManager] currentMember];
                    UIImageView *leftHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                    [leftHeadImageView sd_setImageWithURL:[NSURL URLWithString:host.headIcon] placeholderImage:[UIImage imageNamed:@"DefaultUserHeadIcon"]];
                    [leftHeadImageView.layer setCornerRadius:leftHeadImageView.frame.size.width/2.0f];
                    [leftHeadImageView.layer setMasksToBounds:YES];
                    [leftHeadImageView setUserInteractionEnabled:NO];
                    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
                    [leftHeadImageView addGestureRecognizer:tapGestureRecognizer];
                    leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftHeadImageView];
                    hasMenuItem = YES;
                }else{
                    UIImage *image;
                    if ([AppUtils isNetworkURL:content]) {
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:content]];
                        if (imageData) {
                            image = [UIImage imageWithData:imageData scale:2.5];
                        }else{
                            image = [UIImage new];
                        }
                    }else{
                        image = [UIImage iconWithInfo:TBCityIconInfoMake([AppUtils unicodeIconWithHexint:[content intValue]], IconfontGoBackDefaultSize, [UIColor colorFromHexString:ThemeHexColor])];
                    }
                    leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:sel];
                }
            }
            [self.navigationItem setLeftBarButtonItem:leftItem];
        }else{
            [self.navigationItem setLeftBarButtonItem:nil];
        }
        
        [self selectMenuMode];

        NSDictionary *rightItemDic = [data objectForKey:@"rightItem"];
        if (rightItemDic) {
            NSString *type = [rightItemDic objectForKey:@"type"];
            id content = [rightItemDic objectForKey:@"content"];
            NSString *action = [rightItemDic objectForKey:@"action"];
            SEL sel = nil;
            if ([@"popview" isEqualToString:action]) {
                sel = @selector(clickPopViewItem);
                popViewData = [rightItemDic objectForKey:@"data"];
            }
            
            if ([@"goback" isEqualToString:action]) {
                sel = @selector(clickGobackBtn);
            }
            
            UIBarButtonItem *rightItem;
            if ([@"text" isEqualToString:type]) {
                rightItem = [[UIBarButtonItem alloc] initWithTitle:content style:UIBarButtonItemStyleDone target:self action:sel];
            }else if ([@"image" isEqualToString:type]){
                UIImage *image;
                if ([AppUtils isNetworkURL:content]) {
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:content]];
                    if (imageData) {
                        image = [UIImage imageWithData:imageData scale:2.5];
                    }else{
                        image = [UIImage new];
                    }
                }else{
                    image = [UIImage iconWithInfo:TBCityIconInfoMake([AppUtils unicodeIconWithHexint:[content intValue]], IconfontGoBackDefaultSize, [UIColor colorFromHexString:ThemeHexColor])];
                }
                rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:sel];
            }
            [self.navigationItem setRightBarButtonItem:rightItem];
        }else{
            [self.navigationItem setRightBarButtonItem:nil];
        }
    }
}

-(void)setMenuItemData:(id)data
{
    if (data) {
        canOpenMenu = YES;
        if ([self.myDelegate respondsToSelector:@selector(setMenuItemData:)]) {
            [self.myDelegate setMenuItemData:data];
        }
        
        [self selectMenuMode];
    }
}

-(void)filePreviewer:(id)data
{
    if (data) {
        if ([self.myDelegate respondsToSelector:@selector(previewerFile:)]) {
            [self.myDelegate previewerFile:data];
        }
    }
}

-(void)playVideo:(id)data
{
    if (data) {
        NSString *url = [data objectForKey:@"url"];
        [self playVideoWithUrl:url];
    }
}


-(void)loginout:(BOOL)alert callback:(void(^)(BOOL success))callback
{
    if (alert) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定退出登录吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancelAction];
        
        UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [AppUtils showLoadingInView:self.view];
            [[UPLoginManager shareManager] loginoutCallback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
                [AppUtils hiddenLoadingInView:self.view];
                if (code && [code integerValue] == 200) {
                    callback(YES);
                    if ([self.myDelegate respondsToSelector:@selector(loginout)]) {
                        [self.myDelegate loginout];
                    }
                }else{
                    callback(NO);
                }
            }];
        }];
        [alertVC addAction:comfirmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [AppUtils showLoadingInView:self.view];
        [[UPLoginManager shareManager] loginoutCallback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
            [AppUtils hiddenLoadingInView:self.view];
            if (code && [code integerValue] == 200) {
                callback(YES);
                if ([self.myDelegate respondsToSelector:@selector(loginout)]) {
                    [self.myDelegate loginout];
                }
            }else{
                callback(NO);
            }
        }];
    }
}

-(void)goHome
{
    if ([self.myDelegate respondsToSelector:@selector(goHome)]) {
        [self.myDelegate goHome];
    }
}

-(void)callPlatform:(id)data
{
    if (data) {
        NSString *type = [data objectForKey:@"type"];
        if ([@"tel" isEqualToString:type]) {
            NSString *phone = [data objectForKey:@"value"];
            if (phone) {
                NSString *str=[[NSString alloc] initWithFormat:@"tel:%@",phone];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
        }
    }
}

-(void)setProgress:(id)data
{
    if (data) {
        id progressNum = [data objectForKey:@"progress"];
        if (progressNum) {
            if (self.progressView) {
                if ([progressNum floatValue] >= 100.0f) {
                    [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self.progressView setAlpha:0.0f];
                    } completion:^(BOOL finished) {
                        [self.progressView setProgress:0.0f animated:NO];
                    }];
                }else{
                    [self.progressView setAlpha:1.0f];
                    [self.progressView setProgress:([progressNum floatValue] / 100.0f) animated:NO];
                }
            }
        }
    }
}

-(void)setBadgeDot:(id)data
{
    if (data) {
        BOOL isShow = [[data objectForKey:@"isShow"] boolValue];
        NSInteger tag = [[data objectForKey:@"tag"] integerValue];
        UITabBarItem *item = [self searchTabBarItem:tag];
        if (isShow) {
            if (item) {
                id valueNum = [data objectForKey:@"value"];
                if (valueNum) {
                    if ([valueNum isKindOfClass:[NSNumber class]]) {
                        int value = [valueNum intValue];
                        [item setBadgeMaximumBadgeNumber:100];
                        [item showBadgeWithStyle:WBadgeStyleNumber value:value animationType:WBadgeAnimTypeNone];
                        [item setBadgeCenterOffset:CGPointMake(0, 2)];
                    }else if ([valueNum isKindOfClass:[NSString class]]){
                        if ([AppUtils isPureInt:valueNum]) {
                            int value = [valueNum intValue];
                            [item setBadgeMaximumBadgeNumber:100];
                            [item showBadgeWithStyle:WBadgeStyleNumber value:value animationType:WBadgeAnimTypeNone];
                            [item setBadgeCenterOffset:CGPointMake(0, 2)];
                        }
                    }
                }else{
                    [item showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
                }
            }
        }else{
            if (item) {
                [item clearBadge];
            }
        }
    }
}

-(void)showDatePicker:(id)data
{
    if (data) {
        id year  = [data objectForKey:@"year"];
        id month = [data objectForKey:@"month"];
        id day = [data objectForKey:@"day"];
        if (day == nil) {
            day = @(1);
        }
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
        [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
        NSDate *selectedDate = [dateFormatter dateFromString:dateStr];
        
        NSDate *maxDate = [dateFormatter dateFromString:@"2050-01-01"];
        NSDate *minDate = [dateFormatter dateFromString:@"1990-01-01"];
        NSDictionary *rangeDate = [data objectForKey:@"range"];
        if (rangeDate) {
            maxDate = [dateFormatter dateFromString:[rangeDate objectForKey:@"endDate"]];
            minDate = [dateFormatter dateFromString:[rangeDate objectForKey:@"beginDate"]];
        }
        
        datePickerData = [data objectForKey:@"data"];
        BOOL hasDay = [[data objectForKey:@"hasDay"] boolValue];
        if (hasDay) {
            if (self.datePicker) {
                [self.datePicker removeFromSuperview];
                self.datePicker = nil;
            }
            self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
            self.datePicker.delegate = self;
            self.datePicker.datePickerMode = HooDatePickerModeDate;
            self.datePicker.minimumDate = minDate;
            self.datePicker.maximumDate = maxDate;
            
            [self.datePicker show];
            [self.datePicker setDate:selectedDate animated:NO];
        }else{
            if (self.datePicker) {
                [self.datePicker removeFromSuperview];
                self.datePicker = nil;
            }
            self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
            self.datePicker.delegate = self;
            self.datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
            self.datePicker.minimumDate = minDate;
            self.datePicker.maximumDate = maxDate;
            
            [self.datePicker show];
            [self.datePicker setDate:selectedDate animated:NO];
        }
    }
}

#pragma -mark WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (firstLoad) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePushMessage) name:MessageDidPushedNotification object:nil];
        [[PushMessageManager shareManager] bind:self];
        [[PushMessageManager shareManager] sync];
        firstLoad = NO;
//        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    [self loadSuccess:YES];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self loadSuccess:NO];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self loadSuccess:NO];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma -mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (firstLoad) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePushMessage) name:MessageDidPushedNotification object:nil];
        [[PushMessageManager shareManager] bind:self];
        [[PushMessageManager shareManager] sync];
        firstLoad = NO;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma -mark PushMessageManagerProtocol
-(void)sendPushMessages:(NSArray *)list completion:(NotifyCompletion)compeletion
{
    @synchronized (self) {
        NSArray *messageArr = [NSArray arrayWithArray:list];
        for (id message in messageArr) {
            MessageType type = (MessageType)[[message objectForKey:@"messageType"] integerValue];
            id data = [message objectForKey:@"message"];
            switch (type) {
                case PushMessage:
                {
                    [self.bridge setPushInfo:data];
                    break;
                }
                case PlatformMessage:
                {
                    [self.bridge setListData:data];
                    break;
                }
                default:
                    break;
            }
            compeletion(YES,message);
        }
    }
}

#pragma -mark UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item isKindOfClass:[CustomerTabBarItem class]]) {
        CustomerTabBarItem *cTabBarItem = (CustomerTabBarItem *)item;
        [self.bridge selectTabBarItem:cTabBarItem.defaultField];
    }
}

#pragma -mark HooDatePickerDelegate
- (void)datePicker:(HooDatePicker *)datePicker dateDidChange:(NSDate *)date
{
    
}
- (void)datePicker:(HooDatePicker *)datePicker didCancel:(UIButton *)sender
{
    
}
- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:date];
    NSInteger year = comp.year;
    NSInteger month = comp.month;
    NSInteger day = comp.day;
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(year),@"year",@(month),@"month",@(day),@"day", nil];
        if (datePickerData) {
            [dic setObject:datePickerData forKey:@"data"];
        }
        if ([self.bridge respondsToSelector:@selector(setCalendar:)]) {
            [self.bridge setCalendar:dic];
        }
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(year),@"year",@(month),@"month", nil];
        if (datePickerData) {
            [dic setObject:datePickerData forKey:@"data"];
        }
        if ([self.bridge respondsToSelector:@selector(setCalendar:)]) {
            [self.bridge setCalendar:dic];
        }
    } else {
        
    }
}

@end
