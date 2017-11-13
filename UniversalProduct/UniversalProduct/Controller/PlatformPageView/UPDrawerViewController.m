//
//  UPDrawerViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/4.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPDrawerViewController.h"
#import "UPLeftMenuViewController.h"
#import "UPWebBrowserViewController.h"
#import <MMDrawerController/MMDrawerVisualState.h>

#import "UPFilePreviewerViewController.h"
#import "UPPresentWebViewController.h"

#import "AppStartManager.h"
#import "MiPushSDK.h"

@interface UPDrawerViewController ()<UPWebBrowserViewProtocol,UPLeftMenuViewProtocol>
{
    UPLeftMenuViewController *leftMenuVC;
    UPWebBrowserViewController *webBrowerVC;
}
@end

@implementation UPDrawerViewController

-(instancetype)initWithPlatformName:(NSString *)name
{
    [self inilizeLeftMenuAndPlatformPage];
    
    UINavigationController *nav = [UPWebBrowserViewController navigationControllerWithWebBrowserWithConfiguration:nil];
    webBrowerVC = (UPWebBrowserViewController *)nav.rootWebBrowser;
    webBrowerVC.myDelegate = self;
    webBrowerVC.platformName = name;
    self = [super initWithCenterViewController:nav leftDrawerViewController:leftMenuVC];
    if (self) {
        [self setShowsShadow:NO];
        [self setMaximumLeftDrawerWidth:GDeviceWidth-100];
        [self setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNavigationBarOnly];
        [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            MMDrawerControllerDrawerVisualStateBlock block;
            block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:1.0f];
            if(block){
                block(drawerController, drawerSide, percentVisible);
            }
            
        }];

    }
    return self;
}

-(instancetype)init
{
    [self inilizeLeftMenuAndPlatformPage];
    
    UINavigationController *nav = [UPWebBrowserViewController navigationControllerWithWebBrowserWithConfiguration:nil];
    webBrowerVC = (UPWebBrowserViewController *)nav.rootWebBrowser;
    webBrowerVC.myDelegate = self;
    self = [super initWithCenterViewController:nav leftDrawerViewController:leftMenuVC];
    if (self) {
        [self setShowsShadow:NO];
        [self setMaximumLeftDrawerWidth:GDeviceWidth-100];
        [self setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNavigationBarOnly];
        [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            MMDrawerControllerDrawerVisualStateBlock block;
            block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:1.0f];
            if(block){
                block(drawerController, drawerSide, percentVisible);
            }
            
        }];
        
    }
    return self;
}


-(void)inilizeLeftMenuAndPlatformPage
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    leftMenuVC = [storyboard instantiateViewControllerWithIdentifier:@"UPLeftMenuViewIdentify"];
    leftMenuVC.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UPWebBrowserViewProtocol
-(void)setMenuItemData:(id)data
{
    if (data) {
        [leftMenuVC setMenuData:data];
    }
}

-(void)loginout
{
    Member *host = [[AppStartManager shareManager] currentMember];
    if (host) {
        [MiPushSDK unsetAccount:host.memberId];
    }
    [[AppStartManager shareManager] loginout];
}

-(void)goHome
{
    if (webBrowerVC) {
        [[NSNotificationCenter defaultCenter] removeObserver:webBrowerVC];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)previewerFile:(id)data
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UPFilePreviewerViewController *filePreviewerVC = [storyboard instantiateViewControllerWithIdentifier:@"UPFilePreviewerViewIdentify"];
    filePreviewerVC.detailsMaterials = [NSMutableArray arrayWithArray:data];
    [self.navigationController pushViewController:filePreviewerVC animated:YES];
}

-(void)pushWebView:(NSString *)url withTitle:(NSString *)title
{
    UPPresentWebViewController *presentWebVC = [[UPPresentWebViewController alloc] init];
    presentWebVC.loadUrl = url;
    presentWebVC.navTitle = title;
    [self.navigationController pushViewController:presentWebVC animated:YES];
}

#pragma -mark UPLeftMenuViewProtocol
-(void)selectMenuItem:(id)data{
    if (data) {
        [self toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            [webBrowerVC selectMenuItem:data];
        }];
    }
}
@end
