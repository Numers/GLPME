//
//  HomeForStaffViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/19.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "HomeForStaffViewController.h"
#import "HomeHeaderView.h"
#import "HomeMiddleForStaffView.h"
#import "HomeFooterView.h"

#import "UPHomeManager.h"
#import "SystemInfo.h"
#import "PushMessageManager.h"
#import "UPDrawerViewController.h"
#import "UPPresentWebViewController.h"
#import "ReportDetails.h"
#import "RankInfo.h"
#import "Calculator.h"

@interface HomeForStaffViewController ()<HomeMiddleForStaffViewProtocol,HomeFooterViewProtocol>
{
    HomeHeaderView *headerView;
    HomeMiddleForStaffView *middleForStaffView;
    HomeFooterView *footerView;
    UIView *noDataBackgroundView;
    
    UILabel *titleLabel;
    UIButton *rightItemButton;
    
    NSMutableArray *platformList;
    NSMutableArray *reportDetailsList;
    NSMutableArray *rankList;
    NSString *pushUrl;
    BOOL isFirstLoad;
}
@end

@implementation HomeForStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    noDataBackgroundView = [[UIView alloc] init];
    [noDataBackgroundView setHidden:YES];
    [noDataBackgroundView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:noDataBackgroundView];
    UIImageView *noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoDataBackgroundImage"]];
    [noDataBackgroundView addSubview:noDataImageView];
    UILabel *noDataDescLabel = [[UILabel alloc] init];
    [noDataDescLabel setText:@"不用看了，啥都没有~"];
    [noDataDescLabel setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
    [noDataDescLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [noDataDescLabel setTextAlignment:NSTextAlignmentCenter];
    [noDataBackgroundView addSubview:noDataDescLabel];
    [noDataDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noDataBackgroundView);
        make.trailing.equalTo(noDataBackgroundView);
        make.bottom.equalTo(noDataBackgroundView);
        make.height.equalTo(@(17));
    }];
    
    [noDataImageView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noDataBackgroundView);
        make.trailing.equalTo(noDataBackgroundView);
        make.top.equalTo(noDataBackgroundView);
        make.bottom.equalTo(noDataDescLabel.top).offset(-35);
    }];
    [noDataBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];

    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#F6F6F6"]];
    headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, GDeviceWidth, [UIDevice adaptLengthWithIphone6Length:174.0f])];
    [self.view addSubview:headerView];
    [headerView makeConstraints];
    
    middleForStaffView = [[HomeMiddleForStaffView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, GDeviceWidth, [UIDevice adaptLengthWithIphone6Length:307.0f])];
    middleForStaffView.delegate = self;
    [self.view addSubview:middleForStaffView];
    
    footerView = [[HomeFooterView alloc] initWithFrame:CGRectMake(0, middleForStaffView.frame.origin.y + middleForStaffView.frame.size.height + [UIDevice adaptLengthWithIphone6Length:8.0f], GDeviceWidth, [UIDevice adaptLengthWithIphone6Length:178.0f])];
    footerView.delegate = self;
    [self.view addSubview:footerView];
    [footerView makeConstraints];
    
    titleLabel = [[UILabel alloc] init];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:17.0f needFixed:NO]]];
    [titleLabel setText:@"首页"];
    [self.view addSubview:titleLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(33.0f);
        make.centerX.equalTo(self.view.centerX);
    }];
    
    rightItemButton = [[UIButton alloc] init];
    [rightItemButton setImage:[UIImage imageNamed:@"rightItemImage"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(clickReportButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightItemButton];
    [rightItemButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.top);
        make.trailing.equalTo(self.view);
        make.width.equalTo(@(45));
    }];
    
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
    
    isFirstLoad = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark custom functions
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
    
    NSString *financialYear = [AppUtils returnCurrentFinancialYear];
    [[UPHomeManager shareManager] requestProjectReport:financialYear callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if(data){
            [self dowithReportDetailsData:data];
        }else{
            NSString *localJsonStr = [AppUtils localUserDefaultsForKey:[AppUtils keyBindMember:@"ReportForStaffData"]];
            if (localJsonStr) {
                id localData = [AppUtils objectWithJsonString:localJsonStr];
                [self dowithReportDetailsData:localData];
            }else{
                [self dowithReportDetailsData:nil];
            }
        }
    }];
    
    [[UPHomeManager shareManager] requestRankReport:financialYear month:[AppUtils returnCurrentMonth] callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if (isFirstLoad) {
            [AppUtils hiddenLoadingInView:self.view];
            isFirstLoad = NO;
        }
        
        if(data){
            [self dowithRankReportsData:data];
        }else{
            NSString *localJsonStr = [AppUtils localUserDefaultsForKey:[AppUtils keyBindMember:@"RankForStaffData"]];
            if (localJsonStr) {
                id localData = [AppUtils objectWithJsonString:localJsonStr];
                [self dowithRankReportsData:localData];
            }else{
                [self dowithRankReportsData:nil];
            }
        }
    }];
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
        
        NSArray *applications = [data objectForKey:@"application"];
        if (applications && applications.count > 0) {
            for (NSDictionary *dic in applications) {
                SystemInfo *info = [[SystemInfo alloc] initWithDictionary:dic];
                [platformList addObject:info];
            }
            if(footerView){
                [footerView setPlatformList:platformList];
            }
            NSString *jsonStr = [AppUtils stringFromJsonData:data];
            if (jsonStr) {
                [AppUtils localUserDefaultsValue:jsonStr forKey:[AppUtils keyBindMember:@"PlatformData"]];
            }
        }
    }
    
//    if (platformList && platformList.count > 0) {
//        [headerView setHidden:NO];
//        [middleForStaffView setHidden:NO];
//        [footerView setHidden:NO];
//        [titleLabel setHidden:NO];
//        [rightItemButton setHidden:NO];
//        [noDataBackgroundView setHidden:YES];
//    }else{
//        [headerView setHidden:YES];
//        [middleForStaffView setHidden:YES];
//        [footerView setHidden:YES];
//        [titleLabel setHidden:YES];
//        [rightItemButton setHidden:YES];
//        [noDataBackgroundView setHidden:NO];
//    }
}

-(void)dowithReportDetailsData:(id)data
{
    if (data) {
        if (reportDetailsList) {
            [reportDetailsList removeAllObjects];
        }else{
            reportDetailsList = [NSMutableArray array];
        }
        
        NSArray *arr = (NSArray *)data;
        for (NSDictionary *dic in arr) {
            ReportDetails *details = [[ReportDetails alloc] initWithDictionary:dic];
            [reportDetailsList addObject:details];
        }
        NSString *jsonStr = [AppUtils stringFromJsonData:data];
        if (jsonStr) {
            [AppUtils localUserDefaultsValue:jsonStr forKey:[AppUtils keyBindMember:@"ReportForStaffData"]];
        }
        
        NSArray *currentMonthAllPlatforms = [AppUtils fiterArray:reportDetailsList fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double sumCredit = [Calculator sum:currentMonthAllPlatforms fieldName:@"totalCreditAmount"] / UnitDivisor;  //累计授信
        double sumUseCredit = [Calculator sum:currentMonthAllPlatforms fieldName:@"totalUseAmount"] / UnitDivisor;  //累计用信
        if (headerView) {
            [headerView setTotalCredit:sumCredit totalUseCredit:sumUseCredit];
        }
        
        NSArray *financeLeaseReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1002"];
        double totalFinanceLeaseUseCredit = [Calculator sum:financeLeaseReports fieldName:@"useAmount"] / UnitDivisor;  //融资租赁总用信
        NSArray *currentMonthFinanceLeaseReports = [AppUtils fiterArray:financeLeaseReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalCurrentMonthFinanceLeaseUseCredit = [Calculator sum:currentMonthFinanceLeaseReports fieldName:@"useAmount"]/UnitDivisor;  //当月总用信
        double totalFinanceLeaseOverdueAmount = [Calculator sum:currentMonthFinanceLeaseReports fieldName:@"totalOverdueAmount"]/UnitDivisor; //逾期总额
        if (middleForStaffView) {
            [middleForStaffView setFinanceLeaseTotalUseCredit:totalFinanceLeaseUseCredit totalCurrentMonthUseCredit:totalCurrentMonthFinanceLeaseUseCredit totalOverdueAmount:totalFinanceLeaseOverdueAmount];
        }
        
        NSArray *factoryReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1003"];
        double totalFactoryUseCredit = [Calculator sum:factoryReports fieldName:@"useAmount"]/UnitDivisor;  //保理总用信
        NSArray *currentMonthFactoryReports = [AppUtils fiterArray:factoryReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalCurrentMonthFactoryUseCredit = [Calculator sum:currentMonthFactoryReports fieldName:@"useAmount"]/UnitDivisor;  //当月总用信
        double totalFactoryOverdueAmount = [Calculator sum:currentMonthFactoryReports fieldName:@"totalOverdueAmount"]/UnitDivisor; //逾期总额
        if (middleForStaffView) {
            [middleForStaffView setFactoryTotalUseCredit:totalFactoryUseCredit totalCurrentMonthUseCredit:totalCurrentMonthFactoryUseCredit totalOverdueAmount:totalFactoryOverdueAmount];
        }
        
        NSArray *coldChainsReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1001"];
        double totalColdChainsUseCredit = [Calculator sum:coldChainsReports fieldName:@"useAmount"]/UnitDivisor;  //冷链总用信
        NSArray *currentMonthColdChainsReports = [AppUtils fiterArray:coldChainsReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalCurrentMonthColdChainsUseCredit = [Calculator sum:currentMonthColdChainsReports fieldName:@"useAmount"]/UnitDivisor;  //当月总用信
        double totalColdChainsOverdueAmount = [Calculator sum:currentMonthColdChainsReports fieldName:@"totalOverdueAmount"]/UnitDivisor; //逾期总额
        if (middleForStaffView) {
            [middleForStaffView setColdChainsTotalUseCredit:totalColdChainsUseCredit totalCurrentMonthUseCredit:totalCurrentMonthColdChainsUseCredit totalOverdueAmount:totalColdChainsOverdueAmount];
        }
        
        NSArray *authorizedLoanReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1004"];
        double totalAuthorizedLoanUseCredit = [Calculator sum:authorizedLoanReports fieldName:@"useAmount"]/UnitDivisor;  //委托贷款总用信
        NSArray *currentMonthAuthorizedLoanReports = [AppUtils fiterArray:authorizedLoanReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalCurrentMonthAuthorizedLoanUseCredit = [Calculator sum:currentMonthAuthorizedLoanReports fieldName:@"useAmount"]/UnitDivisor;  //当月总用信
        double totalAuthorizedLoanOverdueAmount = [Calculator sum:currentMonthAuthorizedLoanReports fieldName:@"totalOverdueAmount"]/UnitDivisor; //逾期总额
        if (middleForStaffView) {
            [middleForStaffView setAuthorizedLoanTotalUseCredit:totalAuthorizedLoanUseCredit totalCurrentMonthUseCredit:totalCurrentMonthAuthorizedLoanUseCredit totalOverdueAmount:totalAuthorizedLoanOverdueAmount];
        }
        
        NSArray *crossBusinessReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1005"];
        double totalCrossBusinessUseCredit = [Calculator sum:crossBusinessReports fieldName:@"useAmount"]/UnitDivisor;  //跨境电商总用信
        NSArray *currentMonthCrossBusinessReports = [AppUtils fiterArray:crossBusinessReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalCurrentMonthCrossBusinessUseCredit = [Calculator sum:currentMonthCrossBusinessReports fieldName:@"useAmount"]/UnitDivisor;  //当月总用信
        double totalCrossBusinessOverdueAmount = [Calculator sum:currentMonthCrossBusinessReports fieldName:@"totalOverdueAmount"]/UnitDivisor; //逾期总额
        if (middleForStaffView) {
            [middleForStaffView setCrossBusinessTotalUseCredit:totalCrossBusinessUseCredit totalCurrentMonthUseCredit:totalCurrentMonthCrossBusinessUseCredit totalOverdueAmount:totalCrossBusinessOverdueAmount];
        }
        
        NSArray *internetLoanReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1006"];
        double totalInternetLoanUseCredit = [Calculator sum:internetLoanReports fieldName:@"useAmount"]/UnitDivisor;  //互联网小贷总用信
        NSArray *currentMonthInternetLoanReports = [AppUtils fiterArray:internetLoanReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalCurrentMonthInternetLoanUseCredit = [Calculator sum:currentMonthInternetLoanReports fieldName:@"useAmount"]/UnitDivisor;  //当月总用信
        double totalInternetLoanOverdueAmount = [Calculator sum:currentMonthInternetLoanReports fieldName:@"totalOverdueAmount"]/UnitDivisor; //逾期总额
        if (middleForStaffView) {
            [middleForStaffView setInternetLoanTotalUseCredit:totalInternetLoanUseCredit totalCurrentMonthUseCredit:totalCurrentMonthInternetLoanUseCredit totalOverdueAmount:totalInternetLoanOverdueAmount];
        }

    }

}

-(void)dowithRankReportsData:(id)data
{
    if (data) {
        if (rankList) {
            [rankList removeAllObjects];
        }else{
            rankList = [NSMutableArray array];
        }
        
        NSArray *arr = (NSArray *)data;
        for (NSDictionary *dic in arr) {
            RankInfo *info = [[RankInfo alloc] initWithDictionary:dic];
            [rankList addObject:info];
        }
        [rankList sortUsingComparator:^NSComparisonResult(RankInfo*  _Nonnull obj1, RankInfo*  _Nonnull obj2) {
            if (obj1.rank > obj2.rank) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        NSString *jsonStr = [AppUtils stringFromJsonData:data];
        if (jsonStr) {
            [AppUtils localUserDefaultsValue:jsonStr forKey:[AppUtils keyBindMember:@"RankForStaffData"]];
        }
        
        if (middleForStaffView) {
            [middleForStaffView setSortList:rankList];
        }
    }
}
#pragma -mark pushView
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

-(void)pushReportWebView
{
    if ([AppUtils isNetworkURL:pushUrl]) {
        [self pushWebViewPage:pushUrl title:@"" WithAnimated:YES];
    }
}

#pragma -mark buttonEvent
-(void)clickReportButton
{
    [self pushReportWebView];
}

#pragma -mark HomeMiddleForStaffViewProtocol
-(void)pushToWebPage
{
    if ([AppUtils isNetworkURL:pushUrl]) {
        [self pushWebViewPage:pushUrl title:@"" WithAnimated:YES];
    }
}

#pragma -mark HomeFooterViewProtocol
-(void)pushToPlatformPageWithName:(NSString *)name
{
    [self pushPlatformPageWithName:name];
}
@end
