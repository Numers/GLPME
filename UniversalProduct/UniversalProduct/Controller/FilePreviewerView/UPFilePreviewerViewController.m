//
//  UPFilePreviewerViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/8.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPFilePreviewerViewController.h"
#import "UPFilePreviewerCollectionViewCell.h"

static NSString *collectionViewCellIdentify = @"FilePreviewerCollectionViewCellIdentify";
@interface UPFilePreviewerViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    NSInteger currentPage;
}
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *marginToButton;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *marginToBottom;

@property(nonatomic, strong) IBOutlet UIButton *btnNext;
@property(nonatomic, strong) IBOutlet UIButton *btnPrevious;
@property(nonatomic, strong) IBOutlet UIView *horizonLine;
@property(nonatomic, strong) IBOutlet UIView *verticalLine;
@end

@implementation UPFilePreviewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    
    [_collectionView registerClass:[UPFilePreviewerCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellIdentify];
    [self setCurrentPage:0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clickRefreshItem)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    [self adaptView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark private funcitons
-(void)setDetailsMaterials:(NSMutableArray *)detailsMaterials
{
    if (_detailsMaterials) {
        [_detailsMaterials removeAllObjects];
    }else{
        _detailsMaterials = [NSMutableArray array];
    }
    [_detailsMaterials addObjectsFromArray:detailsMaterials];
}

-(void)setCurrentPage:(NSInteger)page
{
    currentPage = page;
    NSDictionary *info = [_detailsMaterials objectAtIndex:page];
    self.title = [info objectForKey:@"title"];
    if (currentPage < (_detailsMaterials.count - 1)) {
        [_btnNext setEnabled:YES];
        [_btnNext setTitleColor:[UIColor colorFromHexString:ThemeHexColor] forState:UIControlStateNormal];
        [_btnNext setBackgroundColor:[UIColor whiteColor]];
    }else{
        [_btnNext setEnabled:NO];
        [_btnNext setTitleColor:[UIColor colorFromHexString:@"#BBBBBB"] forState:UIControlStateNormal];
        [_btnNext setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (currentPage > 0) {
        [_btnPrevious setEnabled:YES];
        [_btnPrevious setTitleColor:[UIColor colorFromHexString:ThemeHexColor] forState:UIControlStateNormal];
        [_btnPrevious setBackgroundColor:[UIColor whiteColor]];
    }else{
        [_btnPrevious setEnabled:NO];
        [_btnPrevious setTitleColor:[UIColor colorFromHexString:@"#BBBBBB"] forState:UIControlStateNormal];
        [_btnPrevious setBackgroundColor:[UIColor whiteColor]];
    }
}

-(void)adaptView
{
    if (self.detailsMaterials && self.detailsMaterials.count <= 1) {
        [self.btnPrevious setHidden:YES];
        [self.btnNext setHidden:YES];
        [self.horizonLine setHidden:YES];
        [self.verticalLine setHidden:YES];
        self.marginToBottom.priority = 800;
        self.marginToButton.priority = 250;
    }
}
#pragma -mark UIButtonEvent
-(IBAction)clickNextBtn:(id)sender
{
    if (_detailsMaterials && _detailsMaterials.count > 0) {
        if (currentPage < (_detailsMaterials.count - 1)) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            NSInteger tempPage = currentPage + 1;
            [self setCurrentPage:tempPage];
        }
    }
}

-(IBAction)clickPreviousBtn:(id)sender
{
    if (_detailsMaterials && _detailsMaterials.count > 0) {
        if (currentPage > 0) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            NSInteger tempPage = currentPage - 1;
            [self setCurrentPage:tempPage];
        }
    }
}

-(void)clickRefreshItem
{
    NSDictionary *info = [_detailsMaterials objectAtIndex:currentPage];
    UPFilePreviewerCollectionViewCell *cell = (UPFilePreviewerCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0]];
    if (cell) {
        [cell loadFile:[info objectForKey:@"url"]];
    }
}
#pragma -mark ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UIView *view in _collectionView.subviews) {
        if ([view isKindOfClass:[UPFilePreviewerCollectionViewCell class]]) {
            UPFilePreviewerCollectionViewCell *cell = (UPFilePreviewerCollectionViewCell *)view;
            [cell.contentScrollView setZoomScale:1.0f];
        }
    }
    
    NSArray *visibleIndexPaths = [_collectionView indexPathsForVisibleItems];
    if (visibleIndexPaths && visibleIndexPaths.count > 0) {
        NSIndexPath *indexPath = [visibleIndexPaths lastObject];
        [self setCurrentPage:indexPath.item];
    }
}

#pragma -mark UICollectionViewDelegateFlowLayout | UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _detailsMaterials.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UPFilePreviewerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentify forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *info = [_detailsMaterials objectAtIndex:indexPath.item];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell loadFile:[info objectForKey:@"url"]];
        });
    });
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
