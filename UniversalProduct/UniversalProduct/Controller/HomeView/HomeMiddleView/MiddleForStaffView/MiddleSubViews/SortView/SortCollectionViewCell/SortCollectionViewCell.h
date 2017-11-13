//
//  SortCollectionViewCell.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/19.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankInfo;
@interface SortCollectionViewCell : UICollectionViewCell
-(void)setupCellWithRankInfo:(RankInfo *)info;
@end
