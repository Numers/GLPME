//
//  AppUtils.m
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "AppUtils.h"
#import "MBProgressHUD.h"
#import "MBProgressCustomView.h"
#import "FeThreeDotGlow.h"
#import "URLManager.h"
#import "AppStartManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <math.h>
#import <SDWebImage/UIImage+GIF.h>
#define MBTAG  1001 //显示文本的提示tag
#define MBProgressTAG 1002 //加载带循转小图标的控件tag
#define MBProgressAddViewTAG 1003 //加载带小图标的控件tag
#define MBProgressGIFTAG 1004 //加载带gif的控件tag
#define MBProgressCustomerViewTAG 1005 //加载自定义View的控件tag
#define MBProgressThreeDotViewTAG 1006 //加载三点的控件tag
@implementation AppUtils
+(void)setUrlWithState:(BOOL)state
{
    [[URLManager defaultManager] setUrlWithState:state];
}

+(NSString *)returnBaseUrl
{
    return [[URLManager defaultManager] returnBaseUrl];
}

+ (NSString*) appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(NSInteger) buildVersion
{
    NSString *app_build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return [app_build integerValue];
}

+(NSString *)keyBindMember:(NSString *)key
{
    Member *member = [[AppStartManager shareManager] currentMember];
    if (member && ![AppUtils isNullStr:key]) {
        return [NSString stringWithFormat:@"%@_%@",key,member.memberId];
    }
    return nil;
}

+(NSString *)token
{
    Member *member = [[AppStartManager shareManager] currentMember];
    if (member) {
        return member.token;
    }
    return @"";
}

+(void)logAllFont
{
    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    NSLog(@"[familyNames count]===%ld",[familyNames count]);
    for(indFamily=0;indFamily<[familyNames count];++indFamily)
        
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        
        for(indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
            
        }
    }
}

+(NSString *)generateSignatureString:(NSDictionary *)parameters Method:(NSString *)method URI:(NSString *)uri Key:(NSString *)subKey
{
    NSMutableString *signatureString = nil;
    if (parameters) {
        NSArray *allKeys = [parameters allKeys];
        NSArray *sortKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        signatureString = [[NSMutableString alloc] initWithFormat:@"%@:%@:",method,uri];
        for (NSString *key in sortKeys) {
            NSString *paraString = nil;
            if ([key isEqualToString:[sortKeys lastObject]]) {
                paraString = [NSString stringWithFormat:@"%@=%@:",key,[parameters objectForKey:key]];
            }else{
                paraString = [NSString stringWithFormat:@"%@=%@&",key,[parameters objectForKey:key]];
            }
            [signatureString appendString:paraString];
        }
        
        [signatureString appendString:subKey];
    }
    return signatureString;
}

+(NSString*) sha1:(NSString *)text
{
    const char *cstr = [text cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:text.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+(NSString *)getMd5_32Bit:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, str.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

+(void)showInfo:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *appRootView = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *HUD = (MBProgressHUD *)[appRootView viewWithTag:MBTAG];
        if (HUD == nil) {
            HUD = [[MBProgressHUD alloc] initWithView:appRootView];
            HUD.tag = MBTAG;
            [appRootView addSubview:HUD];
            [HUD showAnimated:YES];
        }
        
        HUD.removeFromSuperViewOnHide = YES; // 设置YES ，MB 再消失的时候会从super 移除
        
        if ([self isNullStr:text]) {
            //        HUD.animationType = MBProgressHUDAnimationZoom;
            [HUD hideAnimated:YES];
        }else{
            HUD.mode = MBProgressHUDModeText;
            HUD.label.text = text;
            HUD.label.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            [HUD hideAnimated:YES afterDelay:1.5];
        }
    });
}

/**
 带小图标提示控件
 
 @param text 提示文本
 @param iconView 小图标
 @param view 当前提示的view
 */
+(void)showInfo:(NSString *)text WithIconView:(UIView *)iconView ForView:(UIView *)view;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *appRootView = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *HUD = (MBProgressHUD *)[appRootView viewWithTag:MBProgressAddViewTAG];
        if (HUD == nil) {
            HUD = [[MBProgressHUD alloc] initWithView:appRootView];
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD.bezelView setBackgroundColor:[UIColor whiteColor]];
            [HUD setBackgroundColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:0.5]];
            HUD.customView = iconView;
            HUD.square = YES;
            HUD.tag = MBProgressAddViewTAG;
            [appRootView addSubview:HUD];
        }
        [HUD.label setText:text];
        [HUD.label setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
        [HUD showAnimated:YES];
        HUD.removeFromSuperViewOnHide = YES; // 设置YES ，MB 再消失的时候会从super 移除
        [HUD hideAnimated:YES afterDelay:1.5f];
    });
}


/**
 根据颜色值生成点状图片

 @param color 颜色
 @return 点状图片
 */
+(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  @author Baolicheng, 16-11-22 14:07:14
 *
 *  对float型数字四舍五入
 *
 *  @param value float型数字
 *
 *  @return 四舍五入后的整型
 */
+(NSInteger)floatToInt:(CGFloat)value
{
    CGFloat temp = roundf(value);
    return [[NSNumber numberWithFloat:temp] integerValue];
}



/**
 生成attributedStr

 @param str 字符串
 @param color 颜色
 @param font 字体
 @return attributedStr
 */
+(NSMutableAttributedString *)generateAttriuteStringWithStr:(NSString *)str WithColor:(UIColor *)color WithFont:(UIFont *)font
{
    if (str == nil) {
        return nil;
    }
    
    if (font == nil) {
        font = [UIFont boldSystemFontOfSize:16.0f];
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range;
    range.location = 0;
    range.length = attrString.length;
    [attrString beginEditing];
    [attrString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,font,NSFontAttributeName, nil] range:range];
    [attrString endEditing];
    return attrString;
}


+ (BOOL)isNullStr:(NSString *)str
{
    if (str == nil || [str isEqual:[NSNull null]] || str.length == 0) {
        return  YES;
    }
    
    return NO;
}

+ (BOOL)isMobile:(NSString *)mobile
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //    NSString *MOBILEString = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *MOBILEString = @"^1([3-9][0-9])\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    
    NSString *CMString = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    
    NSString * CUString = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    
    NSString * CTString = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    
    // NSString * PHSString = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILEString];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CMString];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CUString];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CTString];
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        || ([regextestcm evaluateWithObject:mobile] == YES)
        || ([regextestct evaluateWithObject:mobile] == YES)
        || ([regextestcu evaluateWithObject:mobile] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isEmail:(NSString *)email
{
    if (email == (id)[NSNull null] || email.length == 0) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return ([emailTest evaluateWithObject:email] == YES);
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string
{
    if ([AppUtils isNullStr:string]) {
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string
{
    if ([AppUtils isNullStr:string]) {
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+(BOOL)isValidateNumericalValue:(NSString *)string
{
    if ([AppUtils isNullStr:string]) {
        return NO;
    }
    
    if ([self isPureFloat:string]) {
        return YES;
    }
    
    if ([self isPureInt:string]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNetworkURL:(NSString *)url
{
    if (![url isKindOfClass:[NSString class]]) {
        return NO;
    }
    BOOL result = NO;
    if (url) {
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            result = YES;
        }
    }
    return result;
}

+(void)showHudProgress:(NSString *)title forView:(UIView *)view;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *appRootView = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *HUD = (MBProgressHUD *)[appRootView viewWithTag:MBProgressTAG];
        if (HUD == nil) {
            HUD = [[MBProgressHUD alloc] initWithView:appRootView];
            HUD.mode = MBProgressHUDModeIndeterminate;
//            HUD.customView = [[MBProgressCustomView alloc] init];
            HUD.square = YES;
            HUD.tag = MBProgressTAG;
            [appRootView addSubview:HUD];
        }
        [HUD.label setText:title];
        [HUD showAnimated:YES];
        HUD.removeFromSuperViewOnHide = YES; // 设置YES ，MB 再消失的时候会从super 移除
    });
}


+(void)hidenHudProgressForView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *appRootView = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *HUD = (MBProgressHUD *)[appRootView viewWithTag:MBProgressTAG];
        if (HUD != nil) {
            [HUD hideAnimated:YES];
        }
    });
}

+(void)showGIFHudProgress:(NSString *)title forView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //提示成功
        UIWindow *appRootView = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *newhud = (MBProgressHUD *)[appRootView viewWithTag:MBProgressGIFTAG];
        if (newhud == nil) {
            newhud = [[MBProgressHUD alloc] initWithView:appRootView];
            newhud.tag = MBProgressGIFTAG;
            newhud.userInteractionEnabled = NO;
            newhud.bezelView.backgroundColor = [UIColor clearColor];//这儿表示无背景
            /*!
             *  @author WS, 15-11-26 15:11:52
             *
             *  是否显示遮罩
             */
            newhud.backgroundColor = [UIColor clearColor];
            newhud.backgroundView.backgroundColor = [UIColor clearColor];
            /*!
             *  @author WS, 15-11-26 15:11:05
             *
             *  字体颜色
             */
            newhud.label.textColor=[UIColor blackColor];
            
            newhud.mode = MBProgressHUDModeCustomView;
            
            /*!
             *  @author WS, 15-11-26 15:11:32
             *
             *  如果修改动画图片就在这里修改
             */
            UIImage *images=[UIImage sd_animatedGIFNamed:@"pika2"];
            
            newhud.customView = [[UIImageView alloc] initWithImage:images];
            [appRootView addSubview:newhud];
        }
        
        newhud.label.text = title;
        
        [newhud showAnimated:YES];
    });
}

+(void)hiddenGIFHud:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *appRootView = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [appRootView viewWithTag:MBProgressGIFTAG];
        if (hud != nil) {
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES];
        }
    });
}

+(void)showLoadingInView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        FeThreeDotGlow *threeDotGlow = [view viewWithTag:MBProgressThreeDotViewTAG];
        if (threeDotGlow == nil) {
            threeDotGlow = [[FeThreeDotGlow alloc] initWithView:view blur:NO];
            threeDotGlow.tag = MBProgressThreeDotViewTAG;
            [view addSubview:threeDotGlow];
        }
        [threeDotGlow show];
    });
}

+(void)hiddenLoadingInView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        FeThreeDotGlow *threeDotGlow = [view viewWithTag:MBProgressThreeDotViewTAG];
        if (threeDotGlow != nil) {
            [threeDotGlow dismiss];
            [threeDotGlow removeFromSuperview];
            threeDotGlow = nil;
        }
    });
}

+(void)showCustomerViewHudProgress:(NSString *)title forView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //提示成功
        UIWindow *appRootView = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *newhud = (MBProgressHUD *)[appRootView viewWithTag:MBProgressCustomerViewTAG];
        if (newhud == nil) {
            newhud = [[MBProgressHUD alloc] initWithView:appRootView];
            newhud.tag = MBProgressCustomerViewTAG;
            newhud.userInteractionEnabled = NO;
            newhud.bezelView.backgroundColor = [UIColor clearColor];//这儿表示无背景
            /*!
             *  @author WS, 15-11-26 15:11:52
             *
             *  是否显示遮罩
             */
            newhud.backgroundColor = [UIColor clearColor];
            newhud.backgroundView.backgroundColor = [UIColor clearColor];
            /*!
             *  @author WS, 15-11-26 15:11:05
             *
             *  字体颜色
             */
            newhud.label.textColor=[UIColor blackColor];
            
            newhud.mode = MBProgressHUDModeCustomView;
            
            /*!
             *  @author WS, 15-11-26 15:11:32
             *
             *  如果修改动画图片就在这里修改
             */
            
            newhud.customView = [[MBProgressCustomView alloc] init];
            [appRootView addSubview:newhud];
        }
        
        newhud.label.text = title;
        
        [newhud showAnimated:YES];
    });
}

+(void)hiddenCustomerViewHud:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *appRootView = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [appRootView viewWithTag:MBProgressCustomerViewTAG];
        if (hud != nil) {
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES];
        }
    });
}

/**
 存取缓存数据方法
 */
+(id)localUserDefaultsForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:key];
    return token;
}

+(void)localUserDefaultsValue:(id)value forKey:(NSString *)key
{
    if ((value == nil) || ([value isKindOfClass:[NSNull class]])) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

// 对象转json字符串方法

+(NSString *)stringFromJsonData:(id)obj;

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        return nil;
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

+ (id)objectWithJsonString:(NSString *)jsonString;
{
    if (jsonString == nil) {
        return nil;
    }
    
    if (![jsonString isKindOfClass:[NSString class]]) {
        return jsonString;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return obj;
}

+(NSString *)unicodeIconWithHexint:(int)code
{
    unichar characters[2];
    NSUInteger numCharacters = 0;
    if (CFStringGetSurrogatePairForLongCharacter(code, characters)) {
        numCharacters = 2;
    } else {
        characters[0] = code;
        numCharacters = 1;
    }
    
    NSString *icon = [NSString stringWithCharacters:characters length:2];
    return icon;
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距 0时为实线
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距 0时为实线
 ** lineColor:      虚线的颜色
 **/
+ (void)drawVerticalDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(0, CGRectGetHeight(lineView.frame)/2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,0, CGRectGetHeight(lineView.frame));
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

/**
 UIImage:去色功能的实现（图片灰色显示）
 @param sourceImage 图片
 */
+(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

+(UIImage*)grayscaleImageForImage:(UIImage*)image {
    // Adapted from this thread: http://stackoverflow.com/questions/1298867/convert-image-to-grayscale
    const int RED =1;
    const int GREEN =2;
    const int BLUE =3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0,0, image.size.width* image.scale, image.size.height* image.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels,0, width * height *sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context,CGRectMake(0,0, width, height), [image CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t*) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] +0.59 * rgbaPixel[GREEN] +0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(imageRef);
    
    return resultUIImage;
}

+(NSString *)decimalNumberFormatter:(NSNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    
    [formatter setPositiveFormat:@",##0"];
    
    NSString *newAmount = [formatter stringFromNumber:number];
    
    return newAmount;
}

+(NSString *)integerNumberFormatter:(NSNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    
    [formatter setPositiveFormat:@",##0"];
    
    NSString *newAmount = [formatter stringFromNumber:number];
    
    return newAmount;
}

+(NSString *)transferStringNumberToString:(id)number
{
    NSString *str;
    if (![number isKindOfClass:[NSString class]]) {
        str = [NSString stringWithFormat:@"%@",number];
    }else{
        str = number;
    }
    if ([AppUtils isPureInt:str]) {
        return [AppUtils integerNumberFormatter:[NSNumber numberWithInteger:[str integerValue]]];
    }
    
    if ([AppUtils isPureFloat:str]) {
        return [AppUtils decimalNumberFormatter:[NSNumber numberWithDouble:[str doubleValue]]];
    }
    return @"0";
}

+(NSString *)returnCurrentFinancialYear
{
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    NSString *result;
    if(comp.month < 4){
        result = [NSString stringWithFormat:@"FY%ld",comp.year];
    }else{
        result = [NSString stringWithFormat:@"FY%ld",(comp.year + 1)];
    }
    return result;
}

+(NSString *)returnCurrentMonth
{
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    NSString *result;
    NSInteger month = comp.month;
    NSInteger day = comp.day;
    if (day == 1) {
        if (month == 1) {
            month = 12;
        }else{
            month--;
        }
    }
    if (month < 10) {
        result = [NSString stringWithFormat:@"0%ld",month];
    }else{
        result = [NSString stringWithFormat:@"%ld",month];
    }
    return result;
}

+(NSArray *)fiterArray:(NSArray *)list fieldName:(NSString *)fieldName value:(NSString *)value
{
    if (list) {
        if (fieldName && value) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.%@ == %@",fieldName,value];
            NSArray *filterArr = [list filteredArrayUsingPredicate:predicate];
            return filterArr;
        }else{
            return list;
        }
    }
    return nil;
}
@end