//
//  UPFilePreviewerCollectionViewCell.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/8.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPFilePreviewerCollectionViewCell.h"
@interface UPFilePreviewerCollectionViewCell()<UIScrollViewDelegate,UIWebViewDelegate>
{
    UIActivityIndicatorView *activityView;
}
@end
@implementation UPFilePreviewerCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_contentScrollView setContentSize:frame.size];
        _contentScrollView.minimumZoomScale = 1.0f;
        _contentScrollView.maximumZoomScale = 2.5f;
        _contentScrollView.delegate = self;
        
        [self.contentView addSubview:_contentScrollView];
        
        _contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height)];
        _contentWebView.delegate = self;
        [_contentWebView setScalesPageToFit:YES];
        [_contentScrollView addSubview:_contentWebView];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView setCenter:CGPointMake(CGRectGetWidth(_contentScrollView.frame) / 2.0f, CGRectGetHeight(_contentScrollView.frame) / 2.0f)];
        [activityView setHidesWhenStopped:YES];
        [_contentScrollView insertSubview:activityView aboveSubview:_contentWebView];
        
        UIScrollView *scrollView = [self findScrollViewInWebView];
        if (scrollView) {
            [scrollView setShowsVerticalScrollIndicator:NO];
            [scrollView setShowsHorizontalScrollIndicator:NO];
        }
    }
    return self;
}

-(UIScrollView *)findScrollViewInWebView
{
    UIScrollView *scrollView;
    for (UIView *view in _contentWebView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
            break;
        }
    }
    return scrollView;
}

-(void)loadFile:(NSString *)url
{
    if ([AppUtils isNullStr:url]) {
        [_contentWebView setHidden:YES];
        [AppUtils showInfo:@"无该资料信息"];
        return;
    }
    if (_contentWebView) {
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
        NSURL *requestURL = [NSURL URLWithString:encodedString];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
        [_contentWebView loadRequest:request];
    }
}

#pragma -mark UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[UIWebView class]]) {
            return view;
            break;
        }
    }
    return nil;
}

#pragma -mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [webView setHidden:YES];
    [activityView setHidden:NO];
    [activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView setHidden:NO];
    [activityView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [webView setHidden:YES];
    [AppUtils showInfo:@"加载失败!"];
    [activityView stopAnimating];
}

@end
