//
//  SortView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/19.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "SortView.h"
#import "SortCollectionViewCell.h"
#define CellMargin 10.0f
#define CellItemCount 1
static NSString *sortCollectionCellIdentify = @"SortCollectionCellIdentify";
@interface SortView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIImageView *sortIconImageView;
    UILabel *titleLabel;
    UIView *lineView;
    
    UIButton *moreButton;
    
    UICollectionView *myCollectionView;
    
    NSMutableArray *sortList;
}
@end
@implementation SortView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor colorFromHexString:@"#F6F6F6"]];
        [self addSubview:lineView];
        
        sortIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sortIconImage"]];
        [self addSubview:sortIconImageView];
        
        titleLabel = [[UILabel alloc] init];
        [titleLabel setText:@"当月用信 TOP"];
        [titleLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [titleLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]];
        [self addSubview:titleLabel];
        
        moreButton = [[UIButton alloc] init];
        [moreButton setHidden:YES];
        [moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setAttributedTitle:[AppUtils generateAttriuteStringWithStr:@"更多  >" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]] forState:UIControlStateNormal];
        [self addSubview:moreButton];
        
        sortList = [NSMutableArray array];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        [myCollectionView registerClass:[SortCollectionViewCell class] forCellWithReuseIdentifier:sortCollectionCellIdentify];
        [myCollectionView setBackgroundColor:[UIColor whiteColor]];
        myCollectionView.delegate = self;
        myCollectionView.dataSource = self;
        [myCollectionView setShowsHorizontalScrollIndicator:NO];
        [myCollectionView setShowsVerticalScrollIndicator:NO];
        [myCollectionView setContentInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [self addSubview:myCollectionView];
    }
    return self;
}

-(void)makeConstraints
{
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:45.0f]);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(@(1));
    }];
    
    [sortIconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leading).offset(16.0f);
        make.top.equalTo(self).offset(([UIDevice adaptLengthWithIphone6Length:45.0f] - sortIconImageView.frame.size.height) / 2.0f);
    }];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(sortIconImageView.trailing).offset(8);
        make.centerY.equalTo(sortIconImageView.centerY);
    }];
    
    [moreButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(lineView.top).offset(0);
        make.width.equalTo(@(80));
        make.trailing.equalTo(self);
    }];
    
    [myCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom).offset(0);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

#pragma -mark set
-(void)setSortList:(NSArray *)list
{
    if (list) {
        if (sortList) {
            [sortList removeAllObjects];
            [sortList addObjectsFromArray:list];
        }else{
            sortList = [NSMutableArray arrayWithArray:list];
        }
        [myCollectionView reloadData];
    }
}

#pragma -mark buttonEvent
-(void)clickMoreButton
{
    if ([self.delegate respondsToSelector:@selector(searchMore)]) {
        [self.delegate searchMore];
    }
}

#pragma mark - LewReorderableLayoutDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sortCollectionCellIdentify forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RankInfo *info = [sortList objectAtIndex:indexPath.item];
       dispatch_async(dispatch_get_main_queue(), ^{
           [cell setupCellWithRankInfo:info];
       });
    });
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (sortList.count>6)?6:sortList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (CellItemCount >= 1) {
        CGFloat collectionViewHeight = CGRectGetHeight(collectionView.bounds)-0.5;
        CGFloat perPieceHeight = collectionViewHeight / (CellItemCount * 1.0f) - ((CellMargin / (CellItemCount * 1.0f)) * (CellItemCount - 1));
        //        CGFloat perPieceHeight = perPieceWidth + 10;
        //        return CGSizeMake(perPieceWidth, perPieceHeight);
        if (IS_IPHONE_6P) {
            return CGSizeMake([UIDevice adaptWidthWithIphone6Width:115.0f], perPieceHeight);
        }
        return CGSizeMake(114.0f, perPieceHeight);
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
    return UIEdgeInsetsMake(0, 0, 0, CellMargin);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
