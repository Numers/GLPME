//
//  UPGuidIntroViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/26.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPGuidIntroViewController.h"
#import "iCards.h"
#import "CardView.h"

#import "UPLoginScrollViewController.h"

@interface UPGuidIntroViewController ()<iCardsDataSource, iCardsDelegate,CardViewProtocol>
{
    iCards *cardsView;
    NSMutableArray *cardList;
}
@end

@implementation UPGuidIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 禁用 iOS7 返回手势
    self.view.layer.contents = (id)[UIImage imageNamed:@"GuidBackgroundImage"].CGImage;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UIImage *image1 = [UIImage imageNamed:@"FirstGuidPicture"];
    UIImage *image2 = [UIImage imageNamed:@"SecondGuidPicture"];
    UIImage *image3 = [UIImage imageNamed:@"ThirdGuidPicture"];
    cardList = [NSMutableArray arrayWithObjects:image1,image2,image3, nil];
    
    cardsView = [[iCards alloc] initWithFrame:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    [cardsView setCenter:CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f)];
    cardsView.delegate = self;
    cardsView.dataSource = self;
    cardsView.offset = CGSizeMake(5, -5);
    cardsView.numberOfVisibleItems = cardList.count;
    [self.view addSubview:cardsView];
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

#pragma mark - iCardsDataSource methods

- (NSInteger)numberOfItemsInCards:(iCards *)cards {
    return cardList.count;
}

- (UIView *)cards:(iCards *)cards viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view) {
        // you can set new style
        return view;
    }
    
    UIImage *image = [cardList objectAtIndex:index];
    if (image) {
        CardView *card = [[CardView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        card.delegate = self;
        if (index < (cardList.count - 1)) {
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

#pragma mark - iCardsDelegate methods

- (void)cards:(iCards *)cards beforeSwipingItemAtIndex:(NSInteger)index {
    NSLog(@"Begin swiping card %ld!", index);
}

- (void)cards:(iCards *)cards didLeftRemovedItemAtIndex:(NSInteger)index {
    NSLog(@"<--%ld", index);
}

- (void)cards:(iCards *)cards didRightRemovedItemAtIndex:(NSInteger)index {
    NSLog(@"%ld-->", index);
}

- (void)cards:(iCards *)cards didRemovedItemAtIndex:(NSInteger)index {
    NSLog(@"index of removed card: %ld", index);
}

#pragma -mark CardViewProtocol
-(void)clickSkipBtn
{
    UPLoginScrollViewController *loginScrollVC = [[UPLoginScrollViewController alloc] init];
    [self.navigationController pushViewController:loginScrollVC animated:YES];
}
@end
