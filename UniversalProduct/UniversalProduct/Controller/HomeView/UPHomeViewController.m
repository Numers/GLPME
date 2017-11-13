//
//  UPHomeViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/4/24.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPHomeViewController.h"
#import "UPDrawerViewController.h"
#import "UPFirstBasicInfoViewController.h"
#import "UPPresentWebViewController.h"
#import "UPHomeCollectionViewCell.h"

#import "PushMessageManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MiPushSDK.h"
#import "UINavigationController+NavigationBar.h"

#import "AppDelegate.h"
#import "AppStartManager.h"
#import "UPLoginManager.h"
#import "UPHomeManager.h"
#import <WZLBadge/UIView+WZLBadge.h>

#import "SystemInfo.h"

#define CellMargin 0.5f
#define CellItemCount 3
static NSString *homeCollectionCellIdentify = @"UPHomeCollectionCellIdentify";
@interface UPHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPageViewControllerDelegate,UIPageViewControllerDataSource,UPFirstBasicInfoViewProtocol>
{
    NSMutableArray *platformList;
    NSMutableArray *systemExtraInfoList;
    NSString *pushUrl;
    BOOL isFirstLoad;
    
    NSTimer *timer;
    NSInteger currentPage;
}
@property(nonatomic, strong) IBOutlet UIView *dashView;
@property(nonatomic, strong) IBOutlet UIImageView *imgHeadView;
@property(nonatomic, strong) IBOutlet UIView *containerView;
@property(nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property(nonatomic, strong) IBOutlet UIView *noDataBackgroundView;
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) UIPageViewController *pageVC;
@end

@implementation UPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    
    Member *host = [[AppStartManager shareManager] currentMember];
    if (_needAutoLogin) {
        [self login:host];
    }
    
    [_collectionView registerClass:[UPHomeCollectionViewCell class] forCellWithReuseIdentifier:homeCollectionCellIdentify];
    
    if ([[PushMessageManager shareManager] hasMessage]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            id lastMessage = [[PushMessageManager shareManager] lastPushMessage];
            MessageType type = (MessageType)[[lastMessage objectForKey:@"messageType"] integerValue];
            switch (type) {
                case PushMessage:
                {
                    [self pushPlatformPageWithAnimated:NO];
                }
                    break;
                case PlatformMessage:
                {
                    
                }
                    break;
                case WebViewMessage:
                {
                    NSString *url = [lastMessage objectForKey:@"url"];
                    id message = [lastMessage objectForKey:@"message"];
                    NSString *title;
                    if (message) {
                        title = [message objectForKey:@"title"];
                    }
                    if ([AppUtils isNetworkURL:url]) {
                        [self pushWebViewPage:url title:title WithAnimated:NO];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        });
    }
    
    //pageView 初始化
    _pageVC = [self.childViewControllers firstObject];
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    
    UIScrollView *pageScrollView = [self findScrollView];
    if (pageScrollView) {
        [pageScrollView setScrollEnabled:NO];
    }
    
    currentPage = 0;
    isFirstLoad = YES;

    [_dashView setHidden:YES];
    [_containerView setHidden:YES];
    [_collectionView setHidden:YES];
    [_noDataBackgroundView setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:YES];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.title = @"平台列表";
    [self requestData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [AppUtils drawDashLine:_dashView lineLength:3 lineSpacing:1 lineColor:[UIColor colorFromHexString:@"#e5e5e5"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark privateFunction
-(void)inilizedPageView
{
    UPFirstBasicInfoViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    if (initialViewController) {
        initialViewController.delegate = self;
        currentPage = 0;
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [_pageVC setViewControllers:viewControllers
                          direction:UIPageViewControllerNavigationDirectionReverse
                           animated:NO
                         completion:nil];
//        [self timerStart];
    }
    
    [_pageControl setNumberOfPages:systemExtraInfoList.count];
    [_pageControl setCurrentPage:currentPage];
    if (systemExtraInfoList.count < 2) {
        [_pageControl setHidden:YES];
    }else{
        [_pageControl setHidden:NO];
    }
}

-(void)timerStart
{
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)timerCount
{
    static BOOL add = YES;
    if (currentPage == (systemExtraInfoList.count - 1)) {
        add = NO;
    }
    
    if (currentPage == 0) {
        add = YES;
    }
    
    if (add) {
        [self setPageView:currentPage + 1];
    }else{
        [self setPageView:currentPage - 1];
    }
}

-(void)setPageView:(NSInteger)page
{
    currentPage = page;
    UPFirstBasicInfoViewController *initialViewController = [self viewControllerAtIndex:page];// 得到第一页
    if (initialViewController) {
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [_pageVC setViewControllers:viewControllers
                          direction:UIPageViewControllerNavigationDirectionForward
                           animated:YES
                         completion:nil];
        [_pageControl setCurrentPage:currentPage];
    }
}

-(void)dowithSystemInfoData:(id)data
{
    if (data) {
        pushUrl = [data objectForKey:@"statUrl"];
        if (platformList) {
            [platformList removeAllObjects];
        }else{
            platformList = [NSMutableArray array];
        }
        
//        if (systemExtraInfoList) {
//            [systemExtraInfoList removeAllObjects];
//        }else{
//            systemExtraInfoList = [NSMutableArray array];
//        }
        NSArray *applications = [data objectForKey:@"application"];
        if (applications && applications.count > 0) {
            for (NSDictionary *dic in applications) {
                SystemInfo *info = [[SystemInfo alloc] initWithDictionary:dic];
                [platformList addObject:info];
//                [systemExtraInfoList addObjectsFromArray:info.systemExtraInfos];
            }
            
//            [self inilizedPageView];
            NSString *jsonStr = [AppUtils stringFromJsonData:data];
            if (jsonStr) {
                [AppUtils localUserDefaultsValue:jsonStr forKey:[AppUtils keyBindMember:@"PlatformData"]];
            }
        }
        [_collectionView reloadData];
    }
    
    if (platformList && platformList.count > 0) {
        [_dashView setHidden:NO];
        [_containerView setHidden:NO];
        [_collectionView setHidden:NO];
        [_noDataBackgroundView setHidden:YES];
        [_imgHeadView setHidden:NO];
        self.view.layer.contents = (id)[UIImage imageNamed:@"backgroundImage_home"].CGImage;
    }else{
        [_dashView setHidden:YES];
        [_containerView setHidden:YES];
        [_collectionView setHidden:YES];
        [_imgHeadView setHidden:YES];
        [_noDataBackgroundView setHidden:NO];
        self.view.layer.contents = nil;
    }
}

-(void)dowithExtractInfoData:(id)data
{
    if (data) {
        if (systemExtraInfoList) {
            [systemExtraInfoList removeAllObjects];
        }else{
            systemExtraInfoList = [NSMutableArray array];
        }
        
        if ([data isKindOfClass:[NSArray class]]) {
            SystemExtraInfo *extraInfo = [[SystemExtraInfo alloc] initWithArray:data];
            [systemExtraInfoList addObject:extraInfo];
        }
        [self inilizedPageView];
        
        NSString *jsonStr = [AppUtils stringFromJsonData:data];
        if (jsonStr) {
            [AppUtils localUserDefaultsValue:jsonStr forKey:[AppUtils keyBindMember:@"ReportData"]];
        }
    }
}

-(void)requestData
{
    if (isFirstLoad) {
        [AppUtils showLoadingInView:self.view];
    }
    [[UPHomeManager shareManager] requestSystemInfo:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if (data) {
            [self dowithSystemInfoData:data];
        }else{
            NSString *localJsonStr = [AppUtils localUserDefaultsForKey:[AppUtils keyBindMember:@"PlatformData"]];
            if (localJsonStr) {
                id localData = [AppUtils objectWithJsonString:localJsonStr];
                [self dowithSystemInfoData:localData];
            }else{
                [self dowithSystemInfoData:nil];
            }
        }
    }];
    
    [[UPHomeManager shareManager] requestReport:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if (isFirstLoad) {
            [AppUtils hiddenLoadingInView:self.view];
            isFirstLoad = NO;
        }
        
        if (data) {
            [self dowithExtractInfoData:data];
        }else{
            NSString *localJsonStr = [AppUtils localUserDefaultsForKey:[AppUtils keyBindMember:@"ReportData"]];
            if (localJsonStr) {
                id localData = [AppUtils objectWithJsonString:localJsonStr];
                [self dowithExtractInfoData:localData];
            }else{
                [self dowithExtractInfoData:nil];
            }
        }
    }];
}

-(void)login:(Member *)host
{
    if (host) {
        [[UPLoginManager shareManager] loginWithName:host.loginName withPassword:host.password withSource:host.source isNotify:NO callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
            if (data) {
                Member *member = [[Member alloc] init];
                member.memberId = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                member.name = [data objectForKey:@"name"];
                member.loginName = [data objectForKey:@"loginName"];
                member.password = host.password;
                member.token = [data objectForKey:@"token"];
                member.source = [data objectForKey:@"source"];
                member.headIcon = [data objectForKey:@"portrait"];
                member.ip = [data objectForKey:@"ip"];
                member.time = [[data objectForKey:@"time"] doubleValue];
                member.userInfo = data;
                [[AppStartManager shareManager] setMember:member];
                [AppUtils localUserDefaultsValue:@"1" forKey:KMY_AutoLogin];
                [MiPushSDK setAccount:member.memberId];
            }
        }];
    }
}


-(UIScrollView *)findScrollView{
    
    UIScrollView*scrollView;
    
    for(id subview in _pageVC.view.subviews){
        
        if([subview isKindOfClass:UIScrollView.class]){
            
            scrollView=subview;
            
            break;
            
        }}
    
    return scrollView;
    
}

#pragma mark - 根据index得到对应的UIViewController

- (UPFirstBasicInfoViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([systemExtraInfoList count] == 0) || (index >= [systemExtraInfoList count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    UPFirstBasicInfoViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UPFirstBasicInfoViewIdentify"];
    contentVC.info = [systemExtraInfoList objectAtIndex:index];
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(UPFirstBasicInfoViewController *)viewController {
    return [systemExtraInfoList indexOfObject:viewController.info];
}


#pragma -mark public function
-(void)pushPlatformPageWithName:(NSString *)platformName
{
    UPDrawerViewController *drawerVC = [[UPDrawerViewController alloc] initWithPlatformName:platformName];
    [self.navigationController pushViewController:drawerVC animated:YES];
}

-(void)pushPlatformPageWithAnimated:(BOOL)animated
{
    UPDrawerViewController *drawerVC = [[UPDrawerViewController alloc] init];
    [self.navigationController pushViewController:drawerVC animated:animated];
}

-(void)pushWebViewPage:(NSString *)url title:(NSString *)title WithAnimated:(BOOL)animated
{
    UPPresentWebViewController *presentWebVC = [[UPPresentWebViewController alloc] init];
    presentWebVC.loadUrl = url;
    presentWebVC.navTitle = title;
    [self.navigationController pushViewController:presentWebVC animated:animated];
}

-(void)reloadData
{
    [self requestData];
}

#pragma -mark ButtonEvent
-(IBAction)clickDetailsInfoBtn:(id)sender
{
    [self pushReportWebView];
}

-(void)pushReportWebView
{
    if ([AppUtils isNetworkURL:pushUrl]) {
        [self pushWebViewPage:pushUrl title:@"统计报表" WithAnimated:YES];
    }
}
#pragma mark - LewReorderableLayoutDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UPHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCollectionCellIdentify forIndexPath:indexPath];
    SystemInfo *info = [platformList objectAtIndex:indexPath.item];
    [cell setupCellWithSystemInfo:info];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return platformList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (CellItemCount >= 1) {
        CGFloat collectionViewWidth = CGRectGetWidth(collectionView.bounds)-0.5;
        CGFloat perPieceWidth = collectionViewWidth / (CellItemCount * 1.0f) - ((CellMargin / (CellItemCount * 1.0f)) * (CellItemCount - 1));
//        CGFloat perPieceHeight = perPieceWidth + 10;
//        return CGSizeMake(perPieceWidth, perPieceHeight);
        if (IS_IPHONE_6P) {
            return CGSizeMake(perPieceWidth, 110.0f);
        }
        return CGSizeMake(perPieceWidth, 100.0f);
    }
    return CGSizeMake(0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return CellMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return CellMargin;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, CellMargin, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SystemInfo *info = [platformList objectAtIndex:indexPath.item];
    NSString *url = info.appUrl;
    if ([AppUtils isNetworkURL:url]) {
        [[PushMessageManager shareManager] addPushMessage:nil platformUrl:url withType:PlatformMessage];
        [self pushPlatformPageWithName:info.name];
    }else{
        [AppUtils showInfo:@"功能尚未开放，敬请期待"];
    }
}

#pragma -mark UIPageViewControllerDelegate |  UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UPFirstBasicInfoViewController *)viewController];
    [_pageControl setCurrentPage:index];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    [_pageControl setCurrentPage:index];
    return [self viewControllerAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UPFirstBasicInfoViewController *)viewController];
    [_pageControl setCurrentPage:index];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [systemExtraInfoList count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        
    }
}

#pragma -mark UPFirstBasicInfoViewProtocol
-(void)pushToWebView
{
    [self pushReportWebView];
}
@end
