//
//  StatisticsView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "StatisticsView.h"
#import "FinanceLeaseStatisticsView.h"
#import "FactoryStatisticsView.h"
#import "ColdChainsStatisticsView.h"
#import "AuthorizedLoanStatisticsView.h"
#import "InternetLoanStatisticsView.h"
#import "CrossBusinessStatisticsView.h"
#define ButtonWidth  80.0f
#define ButtonHeight 46.0f
#define ButtonScrollLeftEdge 4.0f

@interface StatisticsView()<UIScrollViewDelegate>
{
    UIButton *financeLeaseButton;
    UIButton *factoryButton;
    UIButton *coldChainsButton;
    UIButton *authorizedLoanButton;
    UIButton *internetLoanButton;
    UIButton *crossBusinessButton;
    
    UIView *lineView;
    UIScrollView *buttonScrollView;
    UIScrollView *sv;
    NSInteger selectTag;
    
    FinanceLeaseStatisticsView *financeLeaseStatisticsView;
    FactoryStatisticsView *factoryStatisticsView;
    ColdChainsStatisticsView *coldChainsStatisticsView;
    AuthorizedLoanStatisticsView *authorizedLoanStatisticsView;
    InternetLoanStatisticsView *internetLoanStatisticsView;
    CrossBusinessStatisticsView *crossBusinessStatisticsView;
}
@end
@implementation StatisticsView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [UIDevice adaptLengthWithIphone6Length:ButtonHeight] + 1)];
        buttonScrollView.delegate = self;
        [buttonScrollView setScrollEnabled:YES];
        [buttonScrollView setShowsVerticalScrollIndicator:NO];
        [buttonScrollView setShowsHorizontalScrollIndicator:NO];
        [buttonScrollView setContentInset:UIEdgeInsetsMake(0, ButtonScrollLeftEdge, 0, 0)];
        [self addSubview:buttonScrollView];
        
        financeLeaseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ButtonWidth, [UIDevice adaptLengthWithIphone6Length:ButtonHeight])];
        [financeLeaseButton setTitle:@"融资租赁" forState:UIControlStateNormal];
        [financeLeaseButton addTarget:self action:@selector(clickFinanceLeaseButton) forControlEvents:UIControlEventTouchUpInside];
        [buttonScrollView addSubview:financeLeaseButton];
        
        factoryButton = [[UIButton alloc] initWithFrame:CGRectMake(financeLeaseButton.frame.origin.x + ButtonWidth, 0, ButtonWidth, [UIDevice adaptLengthWithIphone6Length:ButtonHeight])];
        [factoryButton setTitle:@"保理" forState:UIControlStateNormal];
        [factoryButton addTarget:self action:@selector(clickFactoryButton) forControlEvents:UIControlEventTouchUpInside];
        [buttonScrollView addSubview:factoryButton];
        
        coldChainsButton = [[UIButton alloc] initWithFrame:CGRectMake(factoryButton.frame.origin.x + ButtonWidth, 0, ButtonWidth, [UIDevice adaptLengthWithIphone6Length:ButtonHeight])];
        [coldChainsButton setTitle:@"冷链" forState:UIControlStateNormal];
        [coldChainsButton addTarget:self action:@selector(clickColdChainsButton) forControlEvents:UIControlEventTouchUpInside];
        [buttonScrollView addSubview:coldChainsButton];
        
        authorizedLoanButton = [[UIButton alloc] initWithFrame:CGRectMake(coldChainsButton.frame.origin.x + ButtonWidth, 0, ButtonWidth, [UIDevice adaptLengthWithIphone6Length:ButtonHeight])];
        [authorizedLoanButton setTitle:@"委托贷款" forState:UIControlStateNormal];
        [authorizedLoanButton addTarget:self action:@selector(clickAuthorizedLoanButton) forControlEvents:UIControlEventTouchUpInside];
        [buttonScrollView addSubview:authorizedLoanButton];
        
        crossBusinessButton = [[UIButton alloc] initWithFrame:CGRectMake(authorizedLoanButton.frame.origin.x + ButtonWidth, 0, ButtonWidth, [UIDevice adaptLengthWithIphone6Length:ButtonHeight])];
        [crossBusinessButton setTitle:@"跨境电商" forState:UIControlStateNormal];
        [crossBusinessButton addTarget:self action:@selector(clickCrossBusinessButton) forControlEvents:UIControlEventTouchUpInside];
        [buttonScrollView addSubview:crossBusinessButton];
        
        internetLoanButton = [[UIButton alloc] initWithFrame:CGRectMake(crossBusinessButton.frame.origin.x + ButtonWidth, 0, ButtonWidth, [UIDevice adaptLengthWithIphone6Length:ButtonHeight])];
        [internetLoanButton setTitle:@"互联网小贷" forState:UIControlStateNormal];
        [internetLoanButton addTarget:self action:@selector(clickInternetLoanButton) forControlEvents:UIControlEventTouchUpInside];
        [buttonScrollView addSubview:internetLoanButton];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55.0f, 1)];
        [lineView setBackgroundColor:[UIColor colorFromHexString:@"#55A8FD"]];
        [buttonScrollView addSubview:lineView];
        
        [buttonScrollView setContentSize:CGSizeMake(6 * ButtonWidth, [UIDevice adaptLengthWithIphone6Length:ButtonHeight] + 1)];
        
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIDevice adaptLengthWithIphone6Length:ButtonHeight] + 1, frame.size.width, [UIDevice adaptLengthWithIphone6Length:96.0f])];
        sv.delegate = self;
        sv.pagingEnabled = YES;
        [sv setScrollEnabled:YES];
        [sv setShowsVerticalScrollIndicator:NO];
        [sv setShowsHorizontalScrollIndicator:NO];
        [self addSubview:sv];
        
        financeLeaseStatisticsView = [[FinanceLeaseStatisticsView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [UIDevice adaptLengthWithIphone6Length:96.0f])];
        [sv addSubview:financeLeaseStatisticsView];
        [financeLeaseStatisticsView makeConstrains];
        
        factoryStatisticsView = [[FactoryStatisticsView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, [UIDevice adaptLengthWithIphone6Length:96.0f])];
        [sv addSubview:factoryStatisticsView];
        [factoryStatisticsView makeConstrains];
        
        coldChainsStatisticsView = [[ColdChainsStatisticsView alloc] initWithFrame:CGRectMake(2 * frame.size.width, 0, frame.size.width, [UIDevice adaptLengthWithIphone6Length:96.0f])];
        [sv addSubview:coldChainsStatisticsView];
        [coldChainsStatisticsView makeConstrains];
        
        authorizedLoanStatisticsView = [[AuthorizedLoanStatisticsView alloc] initWithFrame:CGRectMake(3 * frame.size.width, 0, frame.size.width, [UIDevice adaptLengthWithIphone6Length:96.0f])];
        [sv addSubview:authorizedLoanStatisticsView];
        [authorizedLoanStatisticsView makeConstrains];
        
        crossBusinessStatisticsView = [[CrossBusinessStatisticsView alloc] initWithFrame:CGRectMake(4 * frame.size.width, 0, frame.size.width, [UIDevice adaptLengthWithIphone6Length:96.0f])];
        [sv addSubview:crossBusinessStatisticsView];
        [crossBusinessStatisticsView makeConstrains];
        
        internetLoanStatisticsView = [[InternetLoanStatisticsView alloc] initWithFrame:CGRectMake(5 * frame.size.width, 0, frame.size.width, [UIDevice adaptLengthWithIphone6Length:96.0f])];
        [sv addSubview:internetLoanStatisticsView];
        [internetLoanStatisticsView makeConstrains];
        
        [sv setContentSize:CGSizeMake(6 * frame.size.width, [UIDevice adaptLengthWithIphone6Length:96.0f])];
        
        selectTag = 0;
        [self selectTag:selectTag];
    }
    return self;
}

-(void)selectTag:(NSInteger)tag
{
    UIButton *selectedBtn = [self selectedButton:tag];
    if(selectTag == tag){
        [lineView setCenter:CGPointMake(selectedBtn.center.x, selectedBtn.center.y + selectedBtn.frame.size.height / 2.0f + 0.5)];
        [sv setContentOffset:CGPointMake(tag * self.frame.size.width, 0)];
    }else{
        [sv setContentOffset:CGPointMake(tag * self.frame.size.width, 0) animated:YES];
        [UIView animateWithDuration:0.3f animations:^{
            [lineView setCenter:CGPointMake(selectedBtn.center.x, selectedBtn.center.y + selectedBtn.frame.size.height / 2.0f + 0.5)];
        } completion:^(BOOL finished) {
            sv.delegate = self;
        }];
    }
    
    if(tag == 0){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
    }else if (tag == 1){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];

    }else if (tag == 2){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];

    }else if (tag == 3){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
    }else if (tag == 4){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
    }else if (tag == 5){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
    }
    selectTag = tag;
}

-(void)scrollToPage:(NSInteger)tag
{
    UIButton *selectedBtn = [self selectedButton:tag];
    if(selectTag == tag){
        [lineView setCenter:CGPointMake(selectedBtn.center.x, selectedBtn.center.y + selectedBtn.frame.size.height / 2.0f + 0.5)];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            [lineView setCenter:CGPointMake(selectedBtn.center.x, selectedBtn.center.y + selectedBtn.frame.size.height / 2.0f + 0.5)];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    CGFloat pieceDistance = (6 * ButtonWidth + ButtonScrollLeftEdge - self.frame.size.width)/5.0f;
    [buttonScrollView setContentOffset:CGPointMake(pieceDistance * tag - ButtonScrollLeftEdge, 0) animated:YES];
    
    if(tag == 0){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
    }else if (tag == 1){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
    }else if (tag == 2){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
    }else if (tag == 3){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
    }else if (tag == 4){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
    }else if (tag == 5){
        [financeLeaseButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"融资租赁" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [factoryButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"保理" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [coldChainsButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"冷链" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [authorizedLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"委托贷款" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [crossBusinessButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"跨境电商" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        
        [internetLoanButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"互联网小贷" WithColor:[UIColor colorFromHexString:@"#55A8FD"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]] forState:UIControlStateNormal];
    }
    selectTag = tag;
}

-(UIButton *)selectedButton:(NSInteger)tag
{
    if(tag == 0){
        return financeLeaseButton;
    }else if(tag == 1){
        return factoryButton;
    }else if (tag == 2){
        return coldChainsButton;
    }else if (tag == 3){
        return authorizedLoanButton;
    }else if (tag == 4){
        return crossBusinessButton;
    }else if (tag == 5){
        return internetLoanButton;
    }
    return nil;
}

#pragma -mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isEqual:sv]){
        NSInteger tempPage = floor(scrollView.contentOffset.x / self.frame.size.width);
        if(tempPage != selectTag && tempPage >= 0 && tempPage < 6){
            [self scrollToPage:tempPage];
            
        }
    }
}

#pragma -mark ButtonClickEvent
-(void)clickFinanceLeaseButton
{
    if(selectTag != 0){
        sv.delegate = nil;
        [self selectTag:0];
    }
}

-(void)clickFactoryButton
{
    if(selectTag != 1){
        sv.delegate = nil;
        [self selectTag:1];
    }
}

-(void)clickColdChainsButton
{
    if (selectTag != 2) {
        sv.delegate = nil;
        [self selectTag:2];
    }
}

-(void)clickAuthorizedLoanButton
{
    if (selectTag != 3) {
        sv.delegate = nil;
        [self selectTag:3];
    }
}

-(void)clickCrossBusinessButton
{
    if (selectTag != 4) {
        sv.delegate = nil;
        [self selectTag:4];
    }
}

-(void)clickInternetLoanButton
{
    if (selectTag != 5) {
        sv.delegate = nil;
        [self selectTag:5];
    }
}


#pragma -mark set
-(void)setFinanceLeaseTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (financeLeaseStatisticsView) {
        [financeLeaseStatisticsView setTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setFactoryTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (factoryStatisticsView) {
        [factoryStatisticsView setTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setColdChainsTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (coldChainsStatisticsView) {
        [coldChainsStatisticsView setTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setAuthorizedLoanTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (authorizedLoanStatisticsView) {
        [authorizedLoanStatisticsView setTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setCrossBusinessTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (crossBusinessStatisticsView) {
        [crossBusinessStatisticsView setTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setInternetLoanTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (internetLoanStatisticsView) {
        [internetLoanStatisticsView setTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}
@end
