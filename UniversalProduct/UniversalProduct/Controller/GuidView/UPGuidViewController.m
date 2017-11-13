//
//  UPGuidViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/26.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPGuidViewController.h"
#import "CardScrollView.h"
#import "CardView.h"

#import "UPLoginScrollViewController.h"

@interface UPGuidViewController ()<CardScrollViewDelegate,CardScrollViewDataSource,CardViewProtocol>
{
    CardScrollView *cardScrollView;
    NSMutableArray *cards;
}
@end

@implementation UPGuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UIImage *image1 = [UIImage imageNamed:@"FirstGuidPicture"];
    UIImage *image2 = [UIImage imageNamed:@"SecondGuidPicture"];
    UIImage *image3 = [UIImage imageNamed:@"ThirdGuidPicture"];
    cards = [NSMutableArray arrayWithObjects:image1,image2,image3, nil];
    
    cardScrollView = [[CardScrollView alloc] initWithFrame:self.view.bounds];
    cardScrollView.cardDelegate = self;
    cardScrollView.cardDataSource = self;
    cardScrollView.canDeleteCard = NO;
    [self.view addSubview:cardScrollView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [cardScrollView loadCard];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CardScrollViewDelegate
- (void)updateCard:(UIView *)card withProgress:(CGFloat)progress direction:(CardMoveDirection)direction {
    if (direction == CardMoveDirectionNone) {
        if (card.tag != [cardScrollView currentCard]) {
            CGFloat scale = 1 - 0.1 * progress;
            card.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
            card.layer.opacity = 1 - 0.2*progress;
        } else {
            card.layer.transform = CATransform3DIdentity;
            card.layer.opacity = 1;
        }
    } else {
        NSInteger transCardTag = direction == CardMoveDirectionLeft ? [cardScrollView currentCard] + 1 : [cardScrollView currentCard] - 1;
        if (card.tag != [cardScrollView currentCard] && card.tag == transCardTag) {
            card.layer.transform = CATransform3DMakeScale(0.9 + 0.1*progress, 0.9 + 0.1*progress, 1.0);
            card.layer.opacity = 0.8 + 0.2*progress;
        } else if (card.tag == [cardScrollView currentCard]) {
            card.layer.transform = CATransform3DMakeScale(1 - 0.1 * progress, 1 - 0.1 * progress, 1.0);
            card.layer.opacity = 1 - 0.2*progress;
        }
    }
}

#pragma mark - CardScrollViewDataSource
- (NSInteger)numberOfCards {
    return cards.count;
}

- (UIView *)cardReuseView:(UIView *)reuseView atIndex:(NSInteger)index {
    if (reuseView) {
        // you can set new style
        return reuseView;
    }
    
    UIImage *image = [cards objectAtIndex:index];
    if (image) {
        CardView *card = [[CardView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        card.delegate = self;
        if (index < (cards.count - 1)) {
            [card setImage:image ShowSkipButton:NO];
        }else{
            [card setImage:image ShowSkipButton:YES];
        }
        
        card.layer.backgroundColor = [UIColor whiteColor].CGColor;
        card.layer.cornerRadius = 4;
        card.layer.masksToBounds = YES;
        
        return card;
    }
    return [UIView new];
}

- (void)deleteCardWithIndex:(NSInteger)index {
    [cards removeObjectAtIndex:index];
}


#pragma -mark CardViewProtocol
-(void)clickSkipBtn
{
    UPLoginScrollViewController *loginScrollVC = [[UPLoginScrollViewController alloc] init];
    [self.navigationController pushViewController:loginScrollVC animated:YES];
}
@end
