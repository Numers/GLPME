//
//  HomeFooterView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "HomeFooterView.h"
#import "UPHomeCollectionViewCell.h"
#import "SystemInfo.h"
#import "PushMessageManager.h"
#define CellMargin 0.5f
#define CellItemCount 3
static NSString *homeCollectionCellIdentify = @"UPHomeCollectionCellIdentify";
@interface HomeFooterView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *lineView;
    UILabel *titleLabel;
    UIImageView *iconImageView;
    UICollectionView *myCollectionView;
    
    NSMutableArray *platformList;
}
@end
@implementation HomeFooterView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor colorFromHexString:@"#F6F6F6"]];
        [self addSubview:lineView];
        
        iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"platformIconImage"]];
        [self addSubview:iconImageView];
        
        titleLabel = [[UILabel alloc] init];
        [titleLabel setText:@"平台列表"];
        [titleLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [titleLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]];
        [self addSubview:titleLabel];
        
        platformList = [NSMutableArray array];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        [myCollectionView registerClass:[UPHomeCollectionViewCell class] forCellWithReuseIdentifier:homeCollectionCellIdentify];
        [myCollectionView setBackgroundColor:[UIColor whiteColor]];
        myCollectionView.delegate = self;
        myCollectionView.dataSource = self;
        [self addSubview:myCollectionView];
    }
    return self;
}

-(void)makeConstraints
{
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:43.0f]);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(@(1));
    }];
    
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leading).offset(17.0f);
        make.top.equalTo(self).offset(([UIDevice adaptLengthWithIphone6Length:43.0f] - iconImageView.frame.size.height) / 2.0f);
    }];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(iconImageView.trailing).offset(9);
        make.centerY.equalTo(iconImageView.centerY);
    }];
    
    [myCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom).offset(0);
        make.leading.equalTo(self).offset([UIDevice adaptWidthWithIphone6Width:20.0f]);
        make.trailing.equalTo(self).offset(-[UIDevice adaptWidthWithIphone6Width:20.0f]);
        make.bottom.equalTo(self);
    }];
}

-(void)setPlatformList:(NSMutableArray *)list
{
    if (list && list.count > 0) {
        if(platformList){
            [platformList removeAllObjects];
        }
        [platformList addObjectsFromArray:list];
        [myCollectionView reloadData];
    }
}
#pragma mark - LewReorderableLayoutDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UPHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCollectionCellIdentify forIndexPath:indexPath];
    SystemInfo *info = [platformList objectAtIndex:indexPath.item];
    [cell setupCellWithSystemInfo:info];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return platformList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (CellItemCount >= 1) {
        CGFloat collectionViewWidth = CGRectGetWidth(collectionView.bounds)-0.5;
        CGFloat perPieceWidth = collectionViewWidth / (CellItemCount * 1.0f) - ((CellMargin / (CellItemCount * 1.0f)) * (CellItemCount - 1));
        //        CGFloat perPieceHeight = perPieceWidth + 10;
        //        return CGSizeMake(perPieceWidth, perPieceHeight);
        if (IS_IPHONE_6P) {
            return CGSizeMake(perPieceWidth, 101);
        }
        return CGSizeMake(perPieceWidth, 100);
    }
    return CGSizeMake(0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return CellMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return CellMargin;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, CellMargin, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SystemInfo *info = [platformList objectAtIndex:indexPath.item];
    NSString *url = info.appUrl;
    if ([AppUtils isNetworkURL:url]) {
        [[PushMessageManager shareManager] addPushMessage:nil platformUrl:url withType:PlatformMessage];
        if ([self.delegate respondsToSelector:@selector(pushToPlatformPageWithName:)]) {
            [self.delegate pushToPlatformPageWithName:info.name];
        }
    }else{
        [AppUtils showInfo:@"功能尚未开放，敬请期待"];
    }
}

@end
