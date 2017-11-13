//
//  CardView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/26.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "CardView.h"
#define SkipButtonWidth 100.f
#define SkipButtonHeight 28.f
#define SkipButtonBottomMargin 41.f

@implementation CardView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageview];
        btnSkip = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width - SkipButtonWidth)/2, frame.size.height - SkipButtonBottomMargin - SkipButtonHeight, SkipButtonWidth, SkipButtonHeight)];
        [btnSkip setBackgroundColor:[UIColor whiteColor]];
        [btnSkip.layer setCornerRadius:SkipButtonHeight / 2.0f];
        [btnSkip.layer setMasksToBounds:YES];
        [btnSkip.layer setBorderColor:[UIColor colorFromHexString:ThemeHexColor].CGColor];
        [btnSkip.layer setBorderWidth:1.0f];
        [btnSkip addTarget:self action:@selector(clickSkipButton) forControlEvents:UIControlEventTouchUpInside];
        
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"立即体验" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor colorFromHexString:ThemeHexColor]}];
        [btnSkip setAttributedTitle:title forState:UIControlStateNormal];
        [self addSubview:btnSkip];
    }
    return self;
}

-(void)clickSkipButton
{
    if ([self.delegate respondsToSelector:@selector(clickSkipBtn)]) {
        [self.delegate clickSkipBtn];
    }
}

-(void)setImage:(UIImage *)image ShowSkipButton:(BOOL)show
{
    [imageview setImage:image];
    [btnSkip setHidden:!show];
}
@end
