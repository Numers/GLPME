//
//  HomeForCustomerViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "HomeForCustomerViewController.h"
#import "HomeHeaderView.h"
#import "HomeMiddleForCustomerView.h"
#import "HomeFooterView.h"

#import "UPHomeManager.h"
#import "SystemInfo.h"
#import "PushMessageManager.h"
#import "UPDrawerViewController.h"
#import "UPPresentWebViewController.h"
#import "ReportDetails.h"
#import "Calculator.h"

@interface HomeForCustomerViewController ()<HomeFooterViewProtocol>
{
    HomeHeaderView *headerView;
    HomeMiddleForCustomerView *middleForCustomerView;
    HomeFooterView *footerView;
    UIView *noDataBackgroundView;
    
    UILabel *titleLabel;
    UIButton *rightItemButton;
    
    
    NSMutableArray *platformList;
    NSMutableArray *reportDetailsList;
    NSString *pushUrl;
    BOOL isFirstLoad;
}
@end

@implementation HomeForCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
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
    
    middleForCustomerView = [[HomeMiddleForCustomerView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, GDeviceWidth, [UIDevice adaptLengthWithIphone6Length:300.0f])];
    [self.view addSubview:middleForCustomerView];
    
    footerView = [[HomeFooterView alloc] initWithFrame:CGRectMake(0, middleForCustomerView.frame.origin.y + middleForCustomerView.frame.size.height + [UIDevice adaptLengthWithIphone6Length:8.0f], GDeviceWidth, [UIDevice adaptLengthWithIphone6Length:185.0f])];
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
    [rightItemButton addTarget:self action:@selector(clickReportButton) forControlEvents:UIControlEventTouchUpInside];
    [rightItemButton setImage:[UIImage imageNamed:@"rightItemImage"] forState:UIControlStateNormal];
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
    
    if (!isFirstLoad) {
        if (middleForCustomerView) {
            [middleForCustomerView startTimer];
        }
    }
    [self requestData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (middleForCustomerView) {
        [middleForCustomerView stopTimer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.d
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
    [[UPHomeManager shareManager] requestCustomerReport:financialYear callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if (isFirstLoad) {
            [AppUtils hiddenLoadingInView:self.view];
            isFirstLoad = NO;
        }
        
        if(data){
            [self dowithReportDetailsData:data];
        }else{
            NSString *localJsonStr = [AppUtils localUserDefaultsForKey:[AppUtils keyBindMember:@"ReportForCustomerData"]];
            if (localJsonStr) {
                id localData = [AppUtils objectWithJsonString:localJsonStr];
                [self dowithReportDetailsData:localData];
            }else{
                [self dowithReportDetailsData:nil];
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
//        [middleForCustomerView setHidden:NO];
//        [footerView setHidden:NO];
//        [titleLabel setHidden:NO];
//        [rightItemButton setHidden:NO];
//        [noDataBackgroundView setHidden:YES];
//    }else{
//        [headerView setHidden:YES];
//        [middleForCustomerView setHidden:YES];
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
            [AppUtils localUserDefaultsValue:jsonStr forKey:[AppUtils keyBindMember:@"ReportForCustomerData"]];
        }
        NSArray *currentMonthAllPlatforms = [AppUtils fiterArray:reportDetailsList fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double sumCredit = [Calculator sum:currentMonthAllPlatforms fieldName:@"totalCreditAmount"] / UnitDivisor;  //累计授信
        double sumUseCredit = [Calculator sum:currentMonthAllPlatforms fieldName:@"totalUseAmount"] / UnitDivisor;  //累计用信
        if (headerView) {
            [headerView setTotalCredit:sumCredit totalUseCredit:sumUseCredit];
        }
        
        NSArray *financeLeaseReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1002"];
        double totalFinanceLeaseUseCredit = [Calculator sum:financeLeaseReports fieldName:@"useAmount"] / UnitDivisor;  //融资租赁总用信
        double totalFinanceLeaseCredit = [Calculator sum:financeLeaseReports fieldName:@"creditAmount"] / UnitDivisor;  //融资租赁总授信
        double financeLeaseRadio = 0;
        if (totalFinanceLeaseCredit > 0) {
            financeLeaseRadio = totalFinanceLeaseUseCredit / totalFinanceLeaseCredit;  //贷授比
        }
        NSArray *currentMonthFinanceLeaseReports = [AppUtils fiterArray:financeLeaseReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalFinanceLeaseLoanPrincipleBalance = [Calculator sum:currentMonthFinanceLeaseReports fieldName:@"loanPrincipleBalance"] / UnitDivisor; //待还总额
        double totalFinanceLeaseRefundPrincipal = [Calculator sum:currentMonthFinanceLeaseReports fieldName:@"totalRefundPrincipal"] / UnitDivisor; //已还总额
        double totalFinanceLeaseOverdueAmount = [Calculator sum:currentMonthFinanceLeaseReports fieldName:@"totalOverdueAmount"] / UnitDivisor; //逾期总额
        if(middleForCustomerView){
            [middleForCustomerView setFinanceLeaseUseCredit:totalFinanceLeaseUseCredit credit:totalFinanceLeaseCredit totalLoanPrincipleBalance:totalFinanceLeaseLoanPrincipleBalance totalRefundPrincipal:totalFinanceLeaseRefundPrincipal totalOverdueAmount:totalFinanceLeaseOverdueAmount radio:financeLeaseRadio];
        }
        
        NSArray *factoryReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1003"];
        double totalFactoryUseCredit = [Calculator sum:factoryReports fieldName:@"useAmount"] / UnitDivisor;  //保理总用信
        double totalFactoryCredit = [Calculator sum:factoryReports fieldName:@"creditAmount"] / UnitDivisor;  //保理总授信
        double factoryRadio = 0;
        if (totalFactoryCredit > 0) {
            factoryRadio = totalFactoryUseCredit / totalFactoryCredit;  //贷授比
        }
        NSArray *currentMonthFactoryReports = [AppUtils fiterArray:factoryReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalFactoryLoanPrincipleBalance = [Calculator sum:currentMonthFactoryReports fieldName:@"loanPrincipleBalance"] / UnitDivisor; //待还总额
        double totalFactoryRefundPrincipal = [Calculator sum:currentMonthFactoryReports fieldName:@"totalRefundPrincipal"] / UnitDivisor; //已还总额
        double totalFactoryOverdueAmount = [Calculator sum:currentMonthFactoryReports fieldName:@"totalOverdueAmount"] / UnitDivisor; //逾期总额
        if (middleForCustomerView) {
            [middleForCustomerView setFactoryUseCredit:totalFactoryUseCredit credit:totalFactoryCredit totalLoanPrincipleBalance:totalFactoryLoanPrincipleBalance totalRefundPrincipal:totalFactoryRefundPrincipal totalOverdueAmount:totalFactoryOverdueAmount radio:factoryRadio];
        }

        NSArray *coldChainsReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1001"];
        double totalColdChainsUseCredit = [Calculator sum:coldChainsReports fieldName:@"useAmount"] / UnitDivisor;  //冷链总用信
        double totalColdChainsCredit = [Calculator sum:coldChainsReports fieldName:@"creditAmount"] / UnitDivisor;  //冷链总授信
        double coldChainsRadio = 0;
        if (totalColdChainsCredit > 0) {
            coldChainsRadio = totalColdChainsUseCredit / totalColdChainsCredit;  //贷授比
        }
        NSArray *currentMonthColdChainsReports = [AppUtils fiterArray:coldChainsReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalColdChainsLoanPrincipleBalance = [Calculator sum:currentMonthColdChainsReports fieldName:@"loanPrincipleBalance"] / UnitDivisor; //待还总额
        double totalColdChainsRefundPrincipal = [Calculator sum:currentMonthColdChainsReports fieldName:@"totalRefundPrincipal"] / UnitDivisor; //已还总额
        double totalColdChainsOverdueAmount = [Calculator sum:currentMonthColdChainsReports fieldName:@"totalOverdueAmount"] / UnitDivisor; //逾期总额
        if (middleForCustomerView) {
            [middleForCustomerView setColdChainsUseCredit:totalColdChainsUseCredit credit:totalColdChainsCredit totalLoanPrincipleBalance:totalColdChainsLoanPrincipleBalance totalRefundPrincipal:totalColdChainsRefundPrincipal totalOverdueAmount:totalColdChainsOverdueAmount radio:coldChainsRadio];
        }
        
        NSArray *authorizedLoanReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1004"];
        double totalAuthorizedLoanUseCredit = [Calculator sum:authorizedLoanReports fieldName:@"useAmount"] / UnitDivisor;  //冷链总用信
        double totalAuthorizedLoanCredit = [Calculator sum:authorizedLoanReports fieldName:@"creditAmount"] / UnitDivisor;  //冷链总授信
        double authorizedLoanRadio = 0;
        if (totalAuthorizedLoanCredit > 0) {
            authorizedLoanRadio = totalAuthorizedLoanUseCredit / totalAuthorizedLoanCredit;  //贷授比
        }
        NSArray *currentMonthAuthorizedLoanReports = [AppUtils fiterArray:authorizedLoanReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalAuthorizedLoanLoanPrincipleBalance = [Calculator sum:currentMonthAuthorizedLoanReports fieldName:@"loanPrincipleBalance"] / UnitDivisor; //待还总额
        double totalAuthorizedLoanRefundPrincipal = [Calculator sum:currentMonthAuthorizedLoanReports fieldName:@"totalRefundPrincipal"] / UnitDivisor; //已还总额
        double totalAuthorizedLoanOverdueAmount = [Calculator sum:currentMonthAuthorizedLoanReports fieldName:@"totalOverdueAmount"] / UnitDivisor; //逾期总额
        if (middleForCustomerView) {
            [middleForCustomerView setAuthorizedLoanUseCredit:totalAuthorizedLoanUseCredit credit:totalAuthorizedLoanCredit totalLoanPrincipleBalance:totalAuthorizedLoanLoanPrincipleBalance totalRefundPrincipal:totalAuthorizedLoanRefundPrincipal totalOverdueAmount:totalAuthorizedLoanOverdueAmount radio:authorizedLoanRadio];
        }
        
        NSArray *crossBusinessReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1005"];
        double totalCrossBusinessUseCredit = [Calculator sum:crossBusinessReports fieldName:@"useAmount"] / UnitDivisor;  //冷链总用信
        double totalCrossBusinessCredit = [Calculator sum:crossBusinessReports fieldName:@"creditAmount"] / UnitDivisor;  //冷链总授信
        double crossBusinessRadio = 0;
        if (totalCrossBusinessCredit > 0) {
            crossBusinessRadio = totalCrossBusinessUseCredit / totalCrossBusinessCredit;  //贷授比
        }
        NSArray *currentMonthCrossBusinessReports = [AppUtils fiterArray:crossBusinessReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalCrossBusinessLoanPrincipleBalance = [Calculator sum:currentMonthCrossBusinessReports fieldName:@"loanPrincipleBalance"] / UnitDivisor; //待还总额
        double totalCrossBusinessRefundPrincipal = [Calculator sum:currentMonthCrossBusinessReports fieldName:@"totalRefundPrincipal"] / UnitDivisor; //已还总额
        double totalCrossBusinessOverdueAmount = [Calculator sum:currentMonthCrossBusinessReports fieldName:@"totalOverdueAmount"] / UnitDivisor; //逾期总额
        if (middleForCustomerView) {
            [middleForCustomerView setCrossBusinessUseCredit:totalCrossBusinessUseCredit credit:totalCrossBusinessCredit totalLoanPrincipleBalance:totalCrossBusinessLoanPrincipleBalance totalRefundPrincipal:totalCrossBusinessRefundPrincipal totalOverdueAmount:totalCrossBusinessOverdueAmount radio:crossBusinessRadio];
        }

        NSArray *internetLoanReports = [AppUtils fiterArray:reportDetailsList fieldName:@"projectId" value:@"1006"];
        double totalInternetLoanUseCredit = [Calculator sum:internetLoanReports fieldName:@"useAmount"] / UnitDivisor;  //冷链总用信
        double totalInternetLoanCredit = [Calculator sum:internetLoanReports fieldName:@"creditAmount"] / UnitDivisor;  //冷链总授信
        double internetLoanRadio = 0;
        if (totalInternetLoanCredit > 0) {
            internetLoanRadio = totalInternetLoanUseCredit / totalInternetLoanCredit;  //贷授比
        }
        NSArray *currentMonthInternetLoanReports = [AppUtils fiterArray:internetLoanReports fieldName:@"statisticsMonth" value:[AppUtils returnCurrentMonth]];
        double totalInternetLoanLoanPrincipleBalance = [Calculator sum:currentMonthInternetLoanReports fieldName:@"loanPrincipleBalance"] / UnitDivisor; //待还总额
        double totalInternetLoanRefundPrincipal = [Calculator sum:currentMonthInternetLoanReports fieldName:@"totalRefundPrincipal"] / UnitDivisor; //已还总额
        double totalInternetLoanOverdueAmount = [Calculator sum:currentMonthInternetLoanReports fieldName:@"totalOverdueAmount"] / UnitDivisor; //逾期总额
        if (middleForCustomerView) {
            [middleForCustomerView setInternetLoanUseCredit:totalInternetLoanUseCredit credit:totalInternetLoanCredit totalLoanPrincipleBalance:totalInternetLoanLoanPrincipleBalance totalRefundPrincipal:totalInternetLoanRefundPrincipal totalOverdueAmount:totalInternetLoanOverdueAmount radio:internetLoanRadio];
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

#pragma -mark HomeFooterViewProtocol
-(void)pushToPlatformPageWithName:(NSString *)name
{
    [self pushPlatformPageWithName:name];
}
@end
