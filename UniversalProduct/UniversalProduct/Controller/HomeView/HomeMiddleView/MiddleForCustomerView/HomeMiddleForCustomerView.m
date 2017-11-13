//
//  HomeMiddleForCustomerView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "HomeMiddleForCustomerView.h"
#import "FinanceLeaseView.h"
#import "FactoryView.h"
#import "ColdChainsView.h"
#import "AuthorizedLoanView.h"
#import "InternetLoanView.h"
#import "CrossBusinessView.h"
@interface HomeMiddleForCustomerView()<UIScrollViewDelegate>
{
    FinanceLeaseView *financeLeaseView;
    FactoryView *factoryView;
    ColdChainsView *coldChainsView;
    AuthorizedLoanView *authorizedLoanView;
    InternetLoanView *internetLoanView;
    CrossBusinessView *crossBusinessView;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    NSInteger current;
    NSTimer *timer;
}
@end

@implementation HomeMiddleForCustomerView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        [scrollView setScrollEnabled:YES];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:scrollView];
        
        financeLeaseView = [[FinanceLeaseView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [scrollView addSubview:financeLeaseView];
        [financeLeaseView makeConstraints];
        
        factoryView = [[FactoryView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
        [scrollView addSubview:factoryView];
        [factoryView makeConstraints];
        
        coldChainsView = [[ColdChainsView alloc] initWithFrame:CGRectMake(2 * frame.size.width, 0, frame.size.width, frame.size.height)];
        [scrollView addSubview:coldChainsView];
        [coldChainsView makeConstraints];
        
        authorizedLoanView = [[AuthorizedLoanView alloc] initWithFrame:CGRectMake(3 * frame.size.width, 0, frame.size.width, frame.size.height)];
        [scrollView addSubview:authorizedLoanView];
        [authorizedLoanView makeConstraints];
        
        crossBusinessView = [[CrossBusinessView alloc] initWithFrame:CGRectMake(4 * frame.size.width, 0, frame.size.width, frame.size.height)];
        [scrollView addSubview:crossBusinessView];
        [crossBusinessView makeConstraints];
        
        internetLoanView = [[InternetLoanView alloc] initWithFrame:CGRectMake(5 * frame.size.width, 0, frame.size.width, frame.size.height)];
        [scrollView addSubview:internetLoanView];
        [internetLoanView makeConstraints];
        
        [scrollView setContentSize:CGSizeMake(6 * frame.size.width, frame.size.height)];
        
        pageControl = [[UIPageControl alloc] init];
        [pageControl setNumberOfPages:6];
        [pageControl setPageIndicatorTintColor:[UIColor colorFromHexString:@"#EEEEEE"]];
        [pageControl setCurrentPageIndicatorTintColor:[UIColor colorFromHexString:@"#C9C9C9"]];
        [self addSubview:pageControl];
        pageControl.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
        [pageControl setCenter:CGPointMake(frame.size.width / 2.0f, frame.size.height - [UIDevice adaptLengthWithIphone6Length:15.0f])];
        
        current = 0;
        [self setCurrentPage:current];
        [self startTimer];
    }
    return self;
}

-(void)setCurrentPage:(NSInteger)page{
    current = page;
    [pageControl setCurrentPage:page];
}

-(void)beginTimer
{
    [self stopTimer];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSInteger tempCurrent;
        if (current == 5) {
            tempCurrent = 0;
        }else{
            tempCurrent = current + 1;
        }
        [scrollView setContentOffset:CGPointMake(self.frame.size.width * tempCurrent, 0) animated:YES];
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}


#pragma -mark public functions
-(void)startTimer
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self beginTimer];
    });
}

-(void)stopTimer
{
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
}
#pragma -mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)sv
{
    NSInteger tempPage = floor(sv.contentOffset.x / self.frame.size.width);
    [self setCurrentPage:tempPage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
#pragma -mark public functions
-(void)setFinanceLeaseUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio
{
    if (financeLeaseView) {
        [financeLeaseView setUseCredit:useCredit credit:credit totalLoanPrincipleBalance:totalLoanPrincipleBalance totalRefundPrincipal:totalRefundPrincipal totalOverdueAmount:totalOverdueAmount radio:radio];
    }
}

-(void)setFactoryUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio
{
    if (factoryView) {
         [factoryView setUseCredit:useCredit credit:credit totalLoanPrincipleBalance:totalLoanPrincipleBalance totalRefundPrincipal:totalRefundPrincipal totalOverdueAmount:totalOverdueAmount radio:radio];
    }
}

-(void)setColdChainsUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio
{
    if (coldChainsView) {
        [coldChainsView setUseCredit:useCredit credit:credit totalLoanPrincipleBalance:totalLoanPrincipleBalance totalRefundPrincipal:totalRefundPrincipal totalOverdueAmount:totalOverdueAmount radio:radio];
    }
}

-(void)setAuthorizedLoanUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio
{
    if (authorizedLoanView) {
        [authorizedLoanView setUseCredit:useCredit credit:credit totalLoanPrincipleBalance:totalLoanPrincipleBalance totalRefundPrincipal:totalRefundPrincipal totalOverdueAmount:totalOverdueAmount radio:radio];
    }
}

-(void)setInternetLoanUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio
{
    if (internetLoanView) {
        [internetLoanView setUseCredit:useCredit credit:credit totalLoanPrincipleBalance:totalLoanPrincipleBalance totalRefundPrincipal:totalRefundPrincipal totalOverdueAmount:totalOverdueAmount radio:radio];
    }
}

-(void)setCrossBusinessUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio
{
    if (crossBusinessView) {
        [crossBusinessView setUseCredit:useCredit credit:credit totalLoanPrincipleBalance:totalLoanPrincipleBalance totalRefundPrincipal:totalRefundPrincipal totalOverdueAmount:totalOverdueAmount radio:radio];
    }
}
@end
