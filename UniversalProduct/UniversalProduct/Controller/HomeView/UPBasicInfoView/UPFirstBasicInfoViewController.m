//
//  UPFirstBasicInfoViewController.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/15.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPFirstBasicInfoViewController.h"
#import "SystemInfo.h"

@interface UPFirstBasicInfoViewController ()
@property(nonatomic, strong) IBOutlet UILabel *lblField1;
@property(nonatomic, strong) IBOutlet UILabel *lblField1Value;
@property(nonatomic, strong) IBOutlet UILabel *lblField2;
@property(nonatomic, strong) IBOutlet UILabel *lblField2Value;
@property(nonatomic, strong) IBOutlet UILabel *lblField3;
@property(nonatomic, strong) IBOutlet UILabel *lblField3Value;
@property(nonatomic, strong) IBOutlet UILabel *lblField4;
@property(nonatomic, strong) IBOutlet UILabel *lblField4Value;
@property(nonatomic, strong) IBOutlet UILabel *lblField5;
@property(nonatomic, strong) IBOutlet UILabel *lblField5Value;
@property(nonatomic, strong) IBOutlet UILabel *lblField6;
@property(nonatomic, strong) IBOutlet UILabel *lblField6Value;
@property(nonatomic, strong) IBOutlet UILabel *lblField7;
@property(nonatomic, strong) IBOutlet UILabel *lblField7Value;
@property(nonatomic, strong) IBOutlet UILabel *lblField8;
@property(nonatomic, strong) IBOutlet UILabel *lblField8Value;
@end

@implementation UPFirstBasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_lblField1 setFont:[UIFont systemFontOfSize:14.0f]];
    [_lblField1 setTextColor:[UIColor whiteColor]];
    [_lblField1Value setFont:[UIFont systemFontOfSize:20.0f]];
    [_lblField1Value setTextColor:[UIColor whiteColor]];
    [_lblField2 setFont:[UIFont systemFontOfSize:12]];
    [_lblField2 setTextColor:[UIColor whiteColor]];
    [_lblField2Value setFont:[UIFont systemFontOfSize:13.0f]];
    [_lblField2Value setTextColor:[UIColor whiteColor]];
    [_lblField3 setFont:[UIFont systemFontOfSize:12]];
    [_lblField3 setTextColor:[UIColor whiteColor]];
    [_lblField3Value setFont:[UIFont systemFontOfSize:13.0f]];
    [_lblField3Value setTextColor:[UIColor whiteColor]];
    [_lblField4 setFont:[UIFont systemFontOfSize:12]];
    [_lblField4 setTextColor:[UIColor whiteColor]];
    [_lblField4Value setFont:[UIFont systemFontOfSize:13.0f]];
    [_lblField4Value setTextColor:[UIColor whiteColor]];
    [_lblField5 setFont:[UIFont systemFontOfSize:13.0f]];
    [_lblField5 setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
    [_lblField5Value setFont:[UIFont systemFontOfSize:20.0f]];
    [_lblField5Value setTextColor:[UIColor colorFromHexString:@"#666666"]];
    [_lblField6 setFont:[UIFont systemFontOfSize:12.0f]];
    [_lblField6 setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
    [_lblField6Value setFont:[UIFont systemFontOfSize:13.0f]];
    [_lblField6Value setTextColor:[UIColor colorFromHexString:@"#2A2A2A"]];
    [_lblField7 setFont:[UIFont systemFontOfSize:12.0f]];
    [_lblField7 setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
    [_lblField7Value setFont:[UIFont systemFontOfSize:13.0f]];
    [_lblField7Value setTextColor:[UIColor colorFromHexString:@"#2A2A2A"]];
    [_lblField8 setFont:[UIFont systemFontOfSize:12.0f]];
    [_lblField8 setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
    [_lblField8Value setFont:[UIFont systemFontOfSize:13.0f]];
    [_lblField8Value setTextColor:[UIColor colorFromHexString:@"#2A2A2A"]];
    
    if (_info) {
        [_lblField1 setText:_info.field1];
        [_lblField1Value setAttributedText:_info.field1Value];
        [_lblField2 setText:_info.field2];
        [_lblField2Value setAttributedText:_info.field2Value];
        [_lblField3 setText:_info.field3];
        [_lblField3Value setAttributedText:_info.field3Value];
        [_lblField4 setText:_info.field4];
        [_lblField4Value setAttributedText:_info.field4Value];
        [_lblField5 setText:_info.field5];
        [_lblField5Value setAttributedText:_info.field5Value];
        [_lblField6 setText:_info.field6];
        [_lblField6Value setAttributedText:_info.field6Value];
        [_lblField7 setText:_info.field7];
        [_lblField7Value setAttributedText:_info.field7Value];
        [_lblField8 setText:_info.field8];
        [_lblField8Value setAttributedText:_info.field8Value];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma private functions
-(void)pushToView
{
    if ([self.delegate respondsToSelector:@selector(pushToWebView)]) {
        [self.delegate pushToWebView];
    }
}
#pragma -mark GestureRecognizer
-(void)tapView
{
    [self pushToView];
}
@end
