//
//  CardView.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/26.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CardViewProtocol <NSObject>
-(void)clickSkipBtn;
@end
@interface CardView : UIView
{
    UIImageView *imageview;
    UIButton *btnSkip;
}
@property(nonatomic, weak) id<CardViewProtocol> delegate;
-(void)setImage:(UIImage *)image ShowSkipButton:(BOOL)show;
@end
