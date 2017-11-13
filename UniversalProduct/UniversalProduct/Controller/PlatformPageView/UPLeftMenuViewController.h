//
//  UPLeftMenuViewController.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/4.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UPLeftMenuViewProtocol <NSObject>
-(void)selectMenuItem:(id)data;
@end
@interface UPLeftMenuViewController : UIViewController
@property(nonatomic, assign) id<UPLeftMenuViewProtocol> delegate;
-(void)setMenuData:(NSArray *)menuData;
@end
