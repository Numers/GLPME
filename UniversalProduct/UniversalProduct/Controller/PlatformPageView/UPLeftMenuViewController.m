//
//  UPLeftMenuViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/4.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPLeftMenuViewController.h"
#import "AppStartManager.h"
#import "MenuItem.h"
#import "MTreeViewFramework.h"

#import <SDWebImage/UIImageView+WebCache.h>

#define DegreesToRadians(degrees) (degrees * M_PI / 180)
static NSString *cellIdentify = @"MenuTableViewCellIdentify";
@interface UPLeftMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *menuItems;
}
@property(nonatomic, strong) IBOutlet MTreeView *tableView;
@property(nonatomic, strong) IBOutlet UIImageView *headImageView;
@property(nonatomic, strong) IBOutlet UILabel *lblName;
@end

@implementation UPLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundMainColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    menuItems = [NSMutableArray array];
    
    Member *host = [[AppStartManager shareManager] currentMember];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:host.headIcon] placeholderImage:[UIImage imageNamed:@"DefaultUserHeadIcon"]];
    [_lblName setText:host.name];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark private functions
-(void)setMenuData:(NSArray *)menuData
{
    if (menuData) {
        self.tableView.rootNode = [MTreeNode initWithParent:nil expand:NO];
        for (NSDictionary *dic in menuData) {
            MTreeNode *node = [MTreeNode initWithParent:self.tableView.rootNode expand:NO];
            MenuItem *item = [[MenuItem alloc] initWithDictionary:dic withParentNode:node];
            [menuItems addObject:item];
            
            node.content = item;
            [self.tableView.rootNode.subNodes addObject:node];
        }
        [self.tableView reloadData];
    }
}


#pragma -mark UITableViewDelegate | UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTreeNode *subNode = [self.tableView nodeAtIndexPath:indexPath];
    MenuItem *item = subNode.content;
    CGRect rect = [item.title boundingRectWithSize:CGSizeMake(GDeviceWidth - 40 - 40, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    CGFloat height = rect.size.height + 10;
    if (height < 50.0f) {
        height = 50.0f;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f ;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 0.1f)];
    footerView.alpha = 0;
    return footerView;
}

-(nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MTreeNode *subNode = [[self.tableView.rootNode subNodes] objectAtIndex:section];
    MenuItem *item = subNode.content;
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 50.0f)];
    {
        sectionView.tag = 10000 + section;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTaped:)];
        [sectionView addGestureRecognizer:recognizer];
        sectionView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.5f;
        [sectionView addSubview:line];
    }
    
    {
        UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 15, 20, 20)];
        tipImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(item.icon, 20, [UIColor colorFromHexString:ThemeHexColor])];
        tipImageView.tag = 10;
        [sectionView addSubview:tipImageView];
//        [self doTipImageView:tipImageView expand:subNode.expand];
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, CGRectGetMaxX(self.view.bounds) - 85, 50)];
        label.font = [UIFont systemFontOfSize:17.0f];
        label.tag = 20;
        label.text = item.title;
        [sectionView addSubview:label];
    }
    
    {
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 35, 15, 20, 20)];
        arrowImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e628", 20, [UIColor blackColor])];
        arrowImageView.tag = 30;
        [sectionView addSubview:arrowImageView];
        [self doArrowImageView:arrowImageView expand:subNode.expand];
    }
    
    return sectionView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 50, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 50, 0, 0)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableView treeView:_tableView numberOfRowsInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableView numberOfSectionsInTreeView:_tableView];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    MTreeNode *subNode = [self.tableView nodeAtIndexPath:indexPath];
    MenuItem *item = subNode.content;
    [cell.textLabel setNumberOfLines:0];
    cell.textLabel.text = item.title;
    [cell.imageView setImage:[UIImage iconWithInfo:TBCityIconInfoMake(item.icon, 20, [UIColor colorFromHexString:ThemeHexColor])]];
    [cell.textLabel sizeToFit];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView expandNodeAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MTreeNode *subNode = [self.tableView nodeAtIndexPath:indexPath];
    MenuItem *item = subNode.content;
    if ([self.delegate respondsToSelector:@selector(selectMenuItem:)]) {
        [self.delegate selectMenuItem:item.defaultField];
    }
}

#pragma -mark tableViewHeader GestureAction
- (void) doTipImageView:(UIImageView *)imageView expand:(BOOL) expand {
    if (expand) {
        imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e8e2", 20, [UIColor blackColor])];
    }else{
        imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e8e1", 20, [UIColor blackColor])];
    }
}

- (void) doArrowImageView:(UIImageView *)imageView expand:(BOOL) expand
{
    [UIView animateWithDuration:0.2f animations:^{
        imageView.transform = (expand) ? CGAffineTransformMakeRotation(DegreesToRadians(180)) : CGAffineTransformIdentity;
    }];
}

- (void)sectionTaped:(UIGestureRecognizer *) recognizer {
    UIView *view = recognizer.view;
    NSUInteger tag = view.tag - 10000;
//    UIImageView *tipImageView = [view viewWithTag:10];
    UIImageView *arrowImageView = [view viewWithTag:30];
    MTreeNode *subNode = [self.tableView nodeAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:tag]];
    [self.tableView expandNodeAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:tag]];
//    [self doTipImageView:tipImageView expand:subNode.expand];
    [self doArrowImageView:arrowImageView expand:subNode.expand];
}
@end
