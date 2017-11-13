//
//  UPFilePreviewerCollectionViewCell.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/8.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPFilePreviewerCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic, strong) UIWebView *contentWebView;

-(void)loadFile:(NSString *)url;
@end
