//
//  LJRadarPolygon.m
//  ZFChartView
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LJRadarPolygon.h"

/**
 *  角度求三角函数sin值
 *  @param a 角度
 */
#define ZFSin(a) sin(a / 180.f * M_PI)

/**
 *  角度求三角函数cos值
 *  @param a 角度
 */
#define ZFCos(a) cos(a / 180.f * M_PI)

@interface LJRadarPolygon()

/** 多边形中心点 */
@property (nonatomic, assign) CGPoint polygonCenter;
/** 雷达中点当前角度 */
@property (nonatomic, assign) CGFloat currentRadarAngle;
/** 雷达角点终点xPos */
@property (nonatomic, assign) CGFloat endXPos;
/** 雷达角点终点yPos */
@property (nonatomic, assign) CGFloat endYPos;
/** 雷达结束角度 */
@property (nonatomic, assign) CGFloat endAngle;
/** 获取当前item半径 */
@property (nonatomic, assign) CGFloat currentRadius;
/** 存储每个item半径的数组 */
@property (nonatomic, strong) NSMutableArray * radiusArray;
/** 存储星标数组 */
@property (nonatomic, strong) NSMutableArray *starIconArray;

@end

@implementation LJRadarPolygon


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

/**
 *  填充bezierPath
 *  @return UIBezierPath
 */
- (UIBezierPath *)fill{
    float maxValue = [self getMaxValue:_radiusArray];
    [self.starIconArray removeAllObjects];
    
    /** 雷达开始角度 */
    CGFloat startAngle = -90.f;
    //获取第一个item半径
    _currentRadius = [_radiusArray.firstObject floatValue];
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    
    // 起始点
    CGPoint point = CGPointMake(_polygonCenter.x, _polygonCenter.y - _currentRadius);
    [bezier moveToPoint:point];
    
    if (maxValue == _currentRadius) {
        [self.starIconArray addObject:[NSValue valueWithCGPoint:point]];
    }
    
    for (NSInteger i = 1; i < _radiusArray.count; i++) {
        _currentRadarAngle = _averageRadarAngle * i;
        //计算每个item的角度
        _endAngle = startAngle + _averageRadarAngle;
        //获取当前item半径
        _currentRadius = [_radiusArray[i] floatValue];
        
        if (_endAngle > -90.f && _endAngle <= 0.f) {
            _endXPos = _polygonCenter.x + fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y - fabs(_currentRadius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 0.f && _endAngle <= 90.f){
            _endXPos = _polygonCenter.x + fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y + fabs(_currentRadius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 90.f && _endAngle <= 180.f){
            _endXPos = _polygonCenter.x - fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y + fabs(_currentRadius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 180.f && _endAngle < 270.f){
            _endXPos = _polygonCenter.x - fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y - fabs(_currentRadius * ZFCos(_currentRadarAngle));
        }

        [bezier addLineToPoint:CGPointMake(_endXPos, _endYPos)];
        //记录下一个item开始角度
        startAngle = _endAngle;
        
        if (maxValue == _currentRadius) {
            CGPoint point = CGPointMake(_endXPos, _endYPos);
            [self.starIconArray addObject:[NSValue valueWithCGPoint:point]];        
        }
    }
    [bezier closePath];
    return bezier;
}

// 获取最大值
- (CGFloat)getMaxValue:(NSArray *)array {
    float value = 0;
    for (int i = 0; i < array.count; i ++) {
        if ([[array objectAtIndex:i] floatValue] > value ) {
            value = [[array objectAtIndex:i] floatValue];
        }
    }
    return value;
}

#pragma mark - 清除控件

/**
 *  清除之前所有subLayers
 */
- (void)removeAllSubLayers{
    NSArray * sublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in sublayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self removeAllSubLayers];
    
    UIBezierPath *fillPath = [self fill];
    // 填充
    CAShapeLayer * fillShapeLayer = [CAShapeLayer layer];
    fillShapeLayer.fillColor = _polygonColor.CGColor;
    fillShapeLayer.opacity = _opacity;
    fillShapeLayer.path = fillPath.CGPath;
    [self.layer addSublayer:fillShapeLayer];
    
    // 边线
    CAShapeLayer * strokeShapelayer = [CAShapeLayer layer];
    strokeShapelayer.fillColor = nil;
    strokeShapelayer.strokeColor = _polygonLineColor.CGColor;
    strokeShapelayer.lineJoin = kCALineJoinRound;
    strokeShapelayer.lineWidth = _polygonLineWidth;
    strokeShapelayer.path = fillPath.CGPath;
    [self.layer addSublayer:strokeShapelayer];
    
    [self addStarIcon];
}

- (void)addStarIcon {
    for (int i = 0; i < self.starIconArray.count; i ++) {
        CGPoint anotherPoint = [[self.starIconArray objectAtIndex:i] CGPointValue];
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"radar_icon_star"];
        view.frame = CGRectMake(0, 0, 12, 12);
        [view setCenter:CGPointMake(anotherPoint.x, anotherPoint.y)];
        [self addSubview:view];
    }
}

#pragma mark - 重写setter, getter方法

- (void)setMaxRadius:(CGFloat)maxRadius{
    _maxRadius = maxRadius;
    _polygonCenter = CGPointMake(_maxRadius, _maxRadius);
}

- (void)setValueArray:(NSArray *)valueArray{
    _valueArray = valueArray;

    //计算每个item的半径
    for (NSInteger i = 0; i < _valueArray.count; i++) {
        CGFloat percent = ([_valueArray[i] floatValue] - _minValue) / (_maxValue - _minValue);
        CGFloat currentRadius = _maxRadius * percent;
        [self.radiusArray addObject:@(currentRadius)];
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)radiusArray{
    if (!_radiusArray) {
        _radiusArray = [NSMutableArray array];
    }
    return _radiusArray;
}

- (NSMutableArray *)starIconArray {
    if (!_starIconArray) {
        _starIconArray = [NSMutableArray array];
    }
    return _starIconArray;
}

@end
