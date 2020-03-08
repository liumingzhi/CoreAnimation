//
//  LJRadar.m
//  ZFChartView
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LJRadar.h"

#define ZFSin(a) sin(a / 180.f * M_PI)
#define ZFCos(a) cos(a / 180.f * M_PI)
#define ZFRadian(angle) (angle / 180.f * M_PI)


@interface LJRadar()
/** 雷达中心点 */
@property (nonatomic, assign) CGPoint radarCenter;
/** 雷达角点起点xPos */
@property (nonatomic, assign) CGFloat startXPos;
/** 雷达角点起点yPos */
@property (nonatomic, assign) CGFloat startYPos;
/** 雷达角点终点xPos */
@property (nonatomic, assign) CGFloat endXPos;
/** 雷达角点终点yPos */
@property (nonatomic, assign) CGFloat endYPos;
/** 雷达开始角度 */
@property (nonatomic, assign) CGFloat startAngle;
/** 雷达结束角度 */
@property (nonatomic, assign) CGFloat endAngle;
/** 雷达中点当前角度 */
@property (nonatomic, assign) CGFloat currentRadarAngle;

/** 存储item point的数组 */
@property (nonatomic, strong) NSMutableArray * pointArray;

@end

@implementation LJRadar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

#pragma mark - 画雷达（直线样式）

/**
 *  画雷达（直线样式）
 *  @param index 第几个多边形
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawRadar:(NSInteger)index{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(_startXPos, _startYPos)];
    //存储最外层多边形开始的棱角point
    if (index == _sectionCount - 1) {
        [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(_startXPos, _startYPos)]];
    }
        
    for (NSInteger i = 0; i < self.itemArray.count - 1; i++) {
        _currentRadarAngle = self.averageRadarAngle * (i + 1);
        //计算每个item的角度
        _endAngle = _startAngle + self.averageRadarAngle;
        
        if (_endAngle > -90.f && _endAngle <= 0.f) {
            _endXPos = _radarCenter.x + fabs(-(_radius * ZFSin(_currentRadarAngle)));
            _endYPos = _radarCenter.y - fabs(_radius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 0.f && _endAngle <= 90.f){
            _endXPos = _radarCenter.x + fabs(-(_radius * ZFSin(_currentRadarAngle)));
            _endYPos = _radarCenter.y + fabs(_radius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 90.f && _endAngle <= 180.f){
            _endXPos = _radarCenter.x - fabs(-(_radius * ZFSin(_currentRadarAngle)));
            _endYPos = _radarCenter.y + fabs(_radius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 180.f && _endAngle < 270.f){
            _endXPos = _radarCenter.x - fabs(-(_radius * ZFSin(_currentRadarAngle)));
            _endYPos = _radarCenter.y - fabs(_radius * ZFCos(_currentRadarAngle));
        }
        
        [bezier addLineToPoint:CGPointMake(_endXPos, _endYPos)];
        //下一个item开始角度等于上一个item结束角度
        _startAngle = _endAngle;
        
        //存储最外层多边形各棱角的point,用于绘画分割线
        if (index == _sectionCount - 1) {
            [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(_endXPos, _endYPos)]];
        }
    }
    [bezier closePath];
    return bezier;
}

/**
 *  雷达ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)radarShapeLayer:(NSInteger)index{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = _radarLineWidth;
    shapeLayer.strokeColor = _radarPatternType == kRadarPatternTypeCircle ? [UIColor clearColor].CGColor : _radarLineColor.CGColor;
    shapeLayer.fillColor = _radarPatternType == kRadarPatternTypeCircle ? [UIColor clearColor].CGColor : _radarBackgroundColor.CGColor;
    shapeLayer.path = [self drawRadar:index].CGPath;
    
    return shapeLayer;
}

#pragma mark - 画雷达（圆圈样式）

/**
 *  画雷达（圆圈样式）
 *
 *  @param index 第几个多边形
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawCircle:(NSInteger)index{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_radarCenter.x, _radarCenter.y) radius:_radius startAngle:ZFRadian(-90) endAngle:ZFRadian(270) clockwise:YES];
    return bezier;
}

/**
 *  雷达圆圈底图ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)circleShapeLayer:(NSInteger)index{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = _radarLineWidth;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.fillColor = index == _sectionCount - 1 ? _radarBackgroundColor.CGColor : [UIColor clearColor].CGColor;
    shapeLayer.opacity = 0.1f;
    shapeLayer.path = [self drawCircle:index].CGPath;
    
    return shapeLayer;
}

/**
 *  雷达圆圈ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)circleLineShapeLayer:(NSInteger)index{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = _radarLineWidth;
        shapeLayer.strokeColor = _radarLineColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = [self drawCircle:index].CGPath;
    
    return shapeLayer;
}

#pragma mark - item顶点

/**
 *  画item顶点
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawPeak:(NSInteger)index{
    CGPoint endPoint = [self.pointArray[index] CGPointValue];
    
    UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:endPoint radius:_raderPeakRadius startAngle:ZFRadian(-90) endAngle:ZFRadian(270) clockwise:YES];
    return bezier;
}

/**
 *  item顶点ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)topCircleShapeLayer:(NSInteger)index{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = _radarPeakColor.CGColor;
    shapeLayer.path = [self drawPeak:index].CGPath;
    
    return shapeLayer;
}

#pragma mark - 分割线

/**
 *  画分割线
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawSeparate:(NSInteger)index{
    CGPoint endPoint = [self.pointArray[index] CGPointValue];
    
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:_radarCenter];
    [bezier addLineToPoint:endPoint];
    return bezier;
}

/**
 *  分割线ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)separateShapeLayer:(NSInteger)index{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = _separateLineWidth;
    shapeLayer.strokeColor = _radarLineColor.CGColor;
    shapeLayer.path = [self drawSeparate:index].CGPath;
    
    return shapeLayer;
}

#pragma mark - 清除之前所有subLayers

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
 *  重绘 底层蒙版
 */
- (void)strokePath{
    [self.pointArray removeAllObjects];
    [self removeAllSubLayers];

    _radarCenter = self.center;
    _startXPos = _radarCenter.x;
   
    _averageRadius = _radius / _sectionCount;
    for (NSInteger i = 0; i < _sectionCount; i++) {
        _startAngle = -90.f;
        _radius = _averageRadius * (i + 1);
        _startYPos = _radarCenter.y - _radius;
        // 底层网状图
        [self.layer addSublayer:[self radarShapeLayer:i]];
        
        // 当雷达底层蒙版kRadarPatternTypeCircle
        _radarPatternType == kRadarPatternTypeCircle ? [self.layer addSublayer:[self circleShapeLayer:i]] : nil;
        _radarPatternType == kRadarPatternTypeCircle ? [self.layer addSublayer:[self circleLineShapeLayer:i]] : nil;
    }
    
    // 网图分割射线
    if (_isShowSeparate) {
        for (NSInteger i = 0; i < self.pointArray.count; i++) {
            [self.layer addSublayer:[self separateShapeLayer:i]];
        }
    }
    
    // 底图蒙版顶点
    if (_isShowRadarPeak) {
        for (NSInteger i = 0; i < self.pointArray.count; i++) {
            [self.layer addSublayer:[self topCircleShapeLayer:i]];
        }
    }
}

#pragma mark - 重写setter, getter方法

- (CGFloat)averageRadarAngle{
    return 360.f / self.itemArray.count;
}

- (NSArray *)itemLabelCenterArray{
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    _startAngle = -90.f;
    
    for (NSInteger i = 0; i < self.itemArray.count; i++) {        
         // 雷达图半径延伸长度， 半径延伸长度，用于计算item label的中心点位置(默认25.f)
        CGFloat radiusExtendLength = 25;
        _currentRadarAngle = self.averageRadarAngle * i;
        //计算每个item的角度,当为第1个item是终点就是起点
        _endAngle = i != 0 ? _startAngle + self.averageRadarAngle : _startAngle;
        // 0 ,1
        if (_endAngle >= -90.f && _endAngle < 0.f) {
            _endXPos = _radarCenter.x + fabs(-((_radius + radiusExtendLength) * ZFSin(_currentRadarAngle)));
            _endYPos = _radarCenter.y - fabs((_radius + radiusExtendLength) * ZFCos(_currentRadarAngle));
            
            if (i == 0) {
                _endYPos += 15;
            } else {
                _endXPos -= 10;
                _endYPos += 6;
            }
            
        }else if (_endAngle >= 0.f && _endAngle < 90.f){
            _endXPos = _radarCenter.x + fabs(-((_radius + radiusExtendLength) * ZFSin(_currentRadarAngle)));
            _endYPos = _radarCenter.y + fabs((_radius + radiusExtendLength) * ZFCos(_currentRadarAngle));
            
            _endXPos += 10;
            _endYPos -= 25;
            
        }else if (_endAngle >= 90.f && _endAngle < 180.f){
            _endXPos = _radarCenter.x - fabs(-((_radius + radiusExtendLength) * ZFSin(_currentRadarAngle)));
            _endYPos = _radarCenter.y + fabs((_radius + radiusExtendLength) * ZFCos(_currentRadarAngle));
            
            _endXPos -= 10;
            _endYPos -= 25;
            
        }else if (_endAngle >= 180.f && _endAngle < 270.f){
            _endXPos = _radarCenter.x - fabs(-((_radius + radiusExtendLength) * ZFSin(_currentRadarAngle)));
            _endYPos = _radarCenter.y - fabs((_radius + radiusExtendLength) * ZFCos(_currentRadarAngle));
            
            _endXPos += 10;
            _endYPos += 6;
        }
        
        _startAngle = _endAngle;
        
        CGPoint center = CGPointMake(_endXPos, _endYPos);
        NSValue * value = [NSValue valueWithCGPoint:center];
        [mutArray addObject:value];
    }
    
    return mutArray;
}

#pragma mark - 懒加载
- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}


@end
