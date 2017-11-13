//
//  UPPresentWebViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/11.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPPresentWebViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UINavigationController+NavigationBar.h"

#import "UPPresentWebViewJavascriptBridge.h"
#import "CustomerTabBarItem.h"

#import "AppStartManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UPLoginManager.h"
#import <MediaPlayer/MediaPlayer.h>

#import "UPFilePreviewerViewController.h"
#import "MiPushSDK.h"
#import "HooDatePicker.h"

@interface UPPresentWebViewController ()<WKNavigationDelegate,UPPresentWebViewJavascriptBridgeProtocol,UITabBarDelegate,HooDatePickerDelegate>
{
    id popViewData;
    id datePickerData;
    
    BOOL canOpenMenu;
    BOOL hasMenuItem;
}
@property(nonatomic, strong) UITabBar *tabBar;
@property(nonatomic, strong) UPPresentWebViewJavascriptBridge *bridge;
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) HooDatePicker *datePicker;
@end

@implementation UPPresentWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    
    canOpenMenu = NO;
    hasMenuItem = NO;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setRightBarButtonItem:nil];
    [self.navigationController setNavigationViewColor:[UIColor whiteColor]];
    [self setTintColor:[UIColor colorFromHexString:ThemeHexColor]];
    [self.progressView setTrackTintColor:[UIColor whiteColor]];
    [self.progressView setProgressTintColor:[UIColor colorFromHexString:@"#02AF00"]];
    [self.navigationController setNavigationViewColor:[UIColor whiteColor]];
    
    self.bridge = [UPPresentWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    self.bridge.delegate = self;
    [self.bridge setWebViewDelegate:self];
    [self.bridge registerEvent];
    
    if ([AppUtils isNetworkURL:_loadUrl]) {
        [self webViewLoadUrl];
    }
    
    if (![AppUtils isNullStr:_navTitle]) {
        self.title = _navTitle;
    }
    self.showsPageTitleInNavigationBar = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
     [self.bridge addKeyboardObserver];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.bridge removeKeyboardObserver];
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
            if ([AppUtils isNetworkURL:_loadUrl]) {
                [self webViewLoadUrl];
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

#pragma -mark private functions
-(void)initToolBarItems
{
    [self.navigationController setToolbarHidden:NO];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e66f", 20, [UIColor colorFromHexString:ThemeHexColor])] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackItem)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clickRefreshItem)];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:@[item1,item3,item2] animated:NO];
}

-(void)selectMenuMode
{
    if (canOpenMenu && hasMenuItem) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    }else{
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }
}

-(void)setLoadUrl:(NSString *)loadUrl
{
    if ([AppUtils isNetworkURL:loadUrl]) {
        _loadUrl = loadUrl;
    }
}

-(void)webViewLoadUrl
{
    if ([AppUtils isNetworkURL:_loadUrl]){
        [self loadURL:[NSURL URLWithString:_loadUrl]];
    }
}


-(void)clickBackItem
{
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }
}

-(void)clickRefreshItem
{
    [self.wkWebView reload];
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
//    [self initToolBarItems];
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
#pragma -mark UPPresentWebViewJavascriptBridgeProtocol
-(void)closeWebView:(void (^)(BOOL))callback
{
    [self.navigationController popViewControllerAnimated:YES];
    callback(YES);
}

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

-(void)presentWebView:(id)data
{
    if (data) {
        NSString *url = [data objectForKey:@"url"];
        NSString *title = [data objectForKey:@"title"];
        UPPresentWebViewController *presentWebVC = [[UPPresentWebViewController alloc] init];
        presentWebVC.loadUrl = url;
        presentWebVC.navTitle = title;
        [self.navigationController pushViewController:presentWebVC animated:YES];
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

-(void)goHome
{
    [self.navigationController popViewControllerAnimated:YES];
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


-(void)filePreviewer:(id)data
{
    if (data) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UPFilePreviewerViewController *filePreviewerVC = [storyboard instantiateViewControllerWithIdentifier:@"UPFilePreviewerViewIdentify"];
        filePreviewerVC.detailsMaterials = [NSMutableArray arrayWithArray:data];
        [self.navigationController pushViewController:filePreviewerVC animated:YES];
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
                    Member *host = [[AppStartManager shareManager] currentMember];
                    if (host) {
                        [MiPushSDK unsetAccount:host.memberId];
                    }
                    [[AppStartManager shareManager] loginout];
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
                Member *host = [[AppStartManager shareManager] currentMember];
                if (host) {
                    [MiPushSDK unsetAccount:host.memberId];
                }
                [[AppStartManager shareManager] loginout];
            }else{
                callback(NO);
            }
        }];
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

-(void)showDatePicker:(id)data
{
    if (data) {
        NSDate *selectedDate = [NSDate date];
        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
        [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
        
        id year  = [data objectForKey:@"year"];
        id month = [data objectForKey:@"month"];
        if (year != nil && month != nil) {
            id day = [data objectForKey:@"day"];
            if (day == nil) {
                day = @(1);
            }
            NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            selectedDate = [dateFormatter dateFromString:dateStr];
        }
        
        NSDate *maxDate = [NSDate date];
        NSDate *minDate = [dateFormatter dateFromString:@"1990-01-01"];
        NSDictionary *rangeDate = [data objectForKey:@"range"];
        if (rangeDate) {
            NSString *beginDate = [rangeDate objectForKey:@"beginDate"];
            if (beginDate) {
                minDate = [dateFormatter dateFromString:beginDate];
            }
            NSString *endDate = [rangeDate objectForKey:@"endDate"];
            if (endDate) {
                maxDate = [dateFormatter dateFromString:endDate];
            }
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
