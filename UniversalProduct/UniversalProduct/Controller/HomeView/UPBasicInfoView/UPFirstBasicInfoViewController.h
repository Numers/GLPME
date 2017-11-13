//
//  UPFirstBasicInfoViewController.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/15.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UPFirstBasicInfoViewProtocol <NSObject>
-(void)pushToWebView;
@end
@class SystemExtraInfo;
@interface UPFirstBasicInfoViewController : UIViewController
@property(nonatomic, assign) id<UPFirstBasicInfoViewProtocol> delegate;
@property(nonatomic, strong) SystemExtraInfo *info;
@end
