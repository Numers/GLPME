//
//  UPLoginViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/4/24.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPLoginViewController.h"
#import "AnimateBackgroundView.h"
#import "UPLoginManager.h"
#import "AppStartManager.h"

#import "PushMessageManager.h"
#import "MiPushSDK.h"
#import "BEMCheckBox.h"

@interface UPLoginViewController ()
{
    BEMCheckBoxGroup *group;
}
@property(nonatomic, strong) IBOutlet UIImageView *imgLoginName;
@property(nonatomic, strong) IBOutlet UIImageView *imgPassword;
@property(nonatomic, strong) IBOutlet UILabel *lblNotify;
@property(nonatomic, strong) IBOutlet UITextField *txtLoginName;
@property(nonatomic, strong) IBOutlet UITextField *txtPassword;
@property(nonatomic, strong) IBOutlet BEMCheckBox *leaseCheckBox;
@property(nonatomic, strong) IBOutlet BEMCheckBox *otherCheckBox;
@property(nonatomic, strong) IBOutlet UIButton *btnLogin;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *iconTopConstraint;
@end

@implementation UPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.imgLoginName setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e61f", 14, [UIColor colorFromHexString:ThemeHexColor])]];
    [self.imgPassword setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e620", 14, [UIColor colorFromHexString:ThemeHexColor])]];
    NSAttributedString *attrLoginPlacehold = [[NSAttributedString alloc] initWithString:@"请输入邮箱地址/手机号" attributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#bbbbbb"],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_txtLoginName setAttributedPlaceholder:attrLoginPlacehold];
    
    NSAttributedString *attrPasswordPlacehold = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#bbbbbb"],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_txtPassword setAttributedPlaceholder:attrPasswordPlacehold];
    
    [_btnLogin.layer setCornerRadius:_btnLogin.frame.size.height / 2.0f];
    [_btnLogin.layer setMasksToBounds:YES];
    
    [_lblNotify setFont:[UIFont fontWithName:@"iconfont" size:12.0f]];
    [_lblNotify setHidden:YES];
    
    _iconTopConstraint.constant = GDeviceHeight * 164.0f/667.0f - 20;
    
    group = [BEMCheckBoxGroup groupWithCheckBoxes:@[self.leaseCheckBox,self.otherCheckBox]];
    group.selectedCheckBox = self.leaseCheckBox;
    group.mustHaveSelection = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.txtLoginName isFirstResponder]) {
        [self.txtLoginName resignFirstResponder];
    }
    
    if ([self.txtPassword isFirstResponder]) {
        [self.txtPassword resignFirstResponder];
    }
}

#pragma -mark private function
-(BOOL)validateInput
{
    if ([AppUtils isNullStr:self.txtLoginName.text]) {
        [self notifyError:@"登录名不能为空"];
        return NO;
    }
    
    if ([AppUtils isNullStr:self.txtPassword.text]) {
        [self notifyError:@"密码不能为空"];
        return  NO;
    }
    
    return YES;
}

-(void)notifyError:(NSString *)text
{
    if (![AppUtils isNullStr:text]) {
        NSString *icon = @"\U0000e627";
        NSString *notify = [NSString stringWithFormat:@"%@ %@",icon,text];
        [_lblNotify setText:notify];
        [_lblNotify sizeToFit];
        [_lblNotify setHidden:NO];
    }
}
#pragma -mark IBAction
-(IBAction)clickLoginBtn:(id)sender
{
    if ([self validateInput]) {
        [_lblNotify setHidden:YES];
        [AppUtils showLoadingInView:self.view];
        NSString *source = nil;
        if ([self.leaseCheckBox isEqual:group.selectedCheckBox]) {
            source = @"fl";
        }else{
            source = @"greyhound";
        }
        [[UPLoginManager shareManager] loginWithName:self.txtLoginName.text withPassword:self.txtPassword.text withSource:source isNotify:NO callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg){
            [AppUtils hiddenLoadingInView:self.view];
            if (data) {
                Member *member = [[Member alloc] init];
                member.memberId = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                member.name = [data objectForKey:@"name"];
                member.loginName = [data objectForKey:@"loginName"];
                member.password = self.txtPassword.text;
                member.token = [data objectForKey:@"token"];
                member.source = [data objectForKey:@"source"];
                member.headIcon = [data objectForKey:@"portrait"];
                member.ip = [data objectForKey:@"ip"];
                member.time = [[data objectForKey:@"time"] doubleValue];
                NSArray *roles = [data objectForKey:@"roles"];
                if (roles && roles.count > 0) {
                    NSDictionary *roleDic = [roles firstObject];
                    NSString *code = [roleDic objectForKey:@"code"];
                    if ([@"ROLE_GREYHOUND_CHECK" isEqualToString:code]) {
                        member.role = CustomerRole;
                    }else{
                        member.role = StaffRole;
                    }
                }
                member.userInfo = data;
                [[AppStartManager shareManager] setMember:member];
                [AppUtils localUserDefaultsValue:@"1" forKey:KMY_AutoLogin];
                
                [MiPushSDK setAccount:member.memberId];
                
                if ([self.delegate respondsToSelector:@selector(loginSuccess)]) {
                    [self.delegate loginSuccess];
                }
            }else{
                [self notifyError:errorMsg];
            }
        }];
    }
}
@end
