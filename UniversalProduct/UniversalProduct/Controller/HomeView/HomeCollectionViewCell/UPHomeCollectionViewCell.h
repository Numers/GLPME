//
//  UPHomeCollectionViewCell.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/28.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SystemInfo;
@interface UPHomeCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imgPlatform;
@property(nonatomic, strong) UILabel *lblPlatformName;

-(void)setupCellWithSystemInfo:(SystemInfo *)info;
@end
