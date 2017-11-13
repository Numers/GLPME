//
//  AnimateBackgroundView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/4.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "AnimateBackgroundView.h"
@interface cirlemodel:NSObject
@property(assign,nonatomic)CGFloat orignX;
@property(assign,nonatomic)CGFloat orignY;
@property(assign,nonatomic)CGFloat width;
@property(assign,nonatomic)CGFloat offsetX;
@property(assign,nonatomic)CGFloat offsetY;
- (instancetype)initModelWith:(CGFloat)orignx andy:(CGFloat)origny andwidth:(CGFloat)width andOffsetX:(CGFloat)offsetx andOffsetY:(CGFloat)offsety;
@end

@interface linemodel:NSObject
@property(assign,nonatomic)CGFloat beginX;
@property(assign,nonatomic)CGFloat beginY;
@property(assign,nonatomic)CGFloat opacity;
@property(assign,nonatomic)CGFloat closeX;
@property(assign,nonatomic)CGFloat closeY;
- (instancetype)initModelWith:(CGFloat)beginx andy:(CGFloat)beginy andOpacity:(CGFloat)opacity andCloseX:(CGFloat)closex andCloseY:(CGFloat)closey;
@end
@interface AnimateBackgroundView()
@property(assign,nonatomic)CGFloat screenWidth;
@property(assign,nonatomic)CGFloat screenHeight;
@property(strong,nonatomic)UIView *bgview;
@property(assign,nonatomic)NSUInteger point;
@property(strong,nonatomic)NSMutableArray *cirleArry;
@property(nonatomic,strong)CADisplayLink* gameTimer;
@end
@implementation AnimateBackgroundView
-(void)startAnimate
{
    [self insertSubview:self.bgview atIndex:0];
    [self initprama];
    [self draw];
    
    _gameTimer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(run)];
    [_gameTimer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
}

-(void)stopAnimate
{
    [_gameTimer invalidate];
    _gameTimer = nil;
    
    if (self.bgview) {
        [self.bgview removeFromSuperview];
        self.bgview=nil;
    }
}

- (void)initprama{
    _screenWidth=[UIScreen mainScreen].bounds.size.width;
    _screenHeight=[UIScreen mainScreen].bounds.size.height;
    _point=15;
    _cirleArry=[NSMutableArray arrayWithCapacity:_point];
    for (NSUInteger i=0; i<_point; i++) {
        cirlemodel *cirle=[[cirlemodel alloc]initModelWith:[self randomBetween:0 And:self.screenWidth] andy:[self randomBetween:0 And:self.screenHeight] andwidth:[self randomBetween:1 And:9] andOffsetX:[self randomBetween:10 And:-10]/40 andOffsetY:[self randomBetween:10 And:-10]/40];
        [_cirleArry addObject:cirle];
    }
    
}


- (void)run{
    [self.bgview removeFromSuperview];
    self.bgview=nil;
    [self insertSubview:self.bgview atIndex:0];
    for (int i=0; i<_point; i++) {
        cirlemodel *model=_cirleArry[i];
        model.orignX+=model.offsetX;
        model.orignY+=model.offsetY;
        if (model.orignX>_screenWidth) {
            model.orignX=0;
        }else if(model.orignX<0){
            model.orignX=_screenWidth;
        }
        
        if (model.orignY>_screenHeight) {
            model.orignY=0;
        }else if (model.orignY<0){
            model.orignY=_screenHeight;
        }
    }
    [self draw];
    
}

- (void)draw{
    
    for (cirlemodel *model in _cirleArry) {
        [self drawCirleWithPrama:model.orignX andy:model.orignY andRadio:model.width andOffsetX:model.offsetX andOffsetY:model.offsetY];
    }
    for (int i=0; i<_point; i++) {
        for (int j=0; j<_point; j++) {
            if (i+j<_point) {
                cirlemodel *model1=_cirleArry[i+j];
                cirlemodel*model2=_cirleArry[i];
                float a=ABS(model1.orignX-model2.orignX);
                float b=ABS(model1.orignY-model2.orignY);
                float length=sqrtf(a*a+b*b);
                float lineOpacity;
                if (length<=_screenWidth/2) {
                    lineOpacity=0.2;
                }else if (_screenWidth/2>length>_screenWidth){
                    lineOpacity=0.15;
                }else if(_screenWidth>length>_screenHeight/2){
                    lineOpacity=0.1;
                }else{
                    lineOpacity=0.0;
                }
                if (lineOpacity>0) {
                    [self drawLinewithPrama:model2.orignX + model2.width/2 andy:model2.orignY + model2.width/2 andOpacity:lineOpacity andCloseX:model1.orignX + model1.width / 2 andCloseY:model1.orignY + model1.width/2];
                }
            }
        }
    }
    
}

- (UIView*)bgview{
    if (!_bgview) {
        _bgview =  [UIView new];
        [_bgview setUserInteractionEnabled:NO];
        _bgview.frame=self.bounds;
        _bgview.backgroundColor=[UIColor whiteColor];
    }
    return _bgview;
}

//随机返回某个区间范围内的值
- (float) randomBetween:(float)smallerNumber And:(float)largerNumber
{
    //设置精确的位数
    int precision = 100;
    //先取得他们之间的差值
    float subtraction = largerNumber - smallerNumber;
    //取绝对值
    subtraction = ABS(subtraction);
    //乘以精度的位数
    subtraction *= precision;
    //在差值间随机
    float randomNumber = arc4random() % ((int)subtraction+1);
    //随机的结果除以精度的位数
    randomNumber /= precision;
    //将随机的值加到较小的值上
    float result = MIN(smallerNumber, largerNumber) + randomNumber;
    //返回结果
    return result;
}

/*
 画圈
 */
- (void)drawCirleWithPrama:(CGFloat)beginx andy:(CGFloat)beginy andRadio:(CGFloat)width andOffsetX:(CGFloat)offsetx andOffsetY:(CGFloat)offsety{
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 7.0f ;
    solidLine.strokeColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:0.4].CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(beginx,  beginy, width, width));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.bgview.layer addSublayer:solidLine];
    
}

/*
 划线
 */

- (void)drawLinewithPrama:(CGFloat)beginx andy:(CGFloat)beginy andOpacity:(CGFloat)opacity andCloseX:(CGFloat)closex andCloseY:(CGFloat)closey{
    
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:opacity].CGColor];
    solidShapeLayer.lineWidth =0.5f ;
    CGPathMoveToPoint(solidShapePath, NULL, beginx, beginy);
    CGPathAddLineToPoint(solidShapePath, NULL, closex,closey);
    
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [self.bgview.layer addSublayer:solidShapeLayer];
}


@end

@implementation cirlemodel

- (instancetype)initModelWith:(CGFloat)orignx andy:(CGFloat)origny andwidth:(CGFloat)width andOffsetX:(CGFloat)offsetx andOffsetY:(CGFloat)offsety{
    
    if (self=[super init]) {
        self.orignX=orignx;
        self.orignY=origny;
        self.width=width;
        self.offsetX=offsetx;
        self.offsetY=offsety;
    }
    return self;
    
}

@end


@implementation linemodel

- (instancetype)initModelWith:(CGFloat)beginx andy:(CGFloat)beginy andOpacity:(CGFloat)opacity andCloseX:(CGFloat)closex andCloseY:(CGFloat)closey{
    
    if (self=[super init]) {
        self.beginX=beginx;
        self.beginY=beginy;
        self.opacity=opacity;
        self.closeX=closex;
        self.closeY=closey;
    }
    return self;
    
}
@end
