//
//  ZFRadarChart.m
//  ZFChartView
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LJRadarChart.h"
#import "LJRadarPolygon.h"

@interface LJRadarChart()

/** 雷达图控件 */
@property (nonatomic, strong) LJRadar * radar;

@end

@implementation LJRadarChart

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.radar = [[LJRadar alloc] initWithFrame:self.bounds];
    [self addSubview:self.radar];
}

#pragma mark - public method
/**
 *  绘制
 */
- (void)strokePath{
    
    // 雷达地图参数配置
    self.radar.itemArray = self.itemArray;
    self.radar.radius = 45.f;
    self.radar.sectionCount = 3;
    self.radar.radarLineColor = [UIColor lightGrayColor];
    self.radar.radarBackgroundColor = [UIColor clearColor];
    self.radar.radarLineWidth = 1.f;
    self.radar.separateLineWidth = 1.f;
    self.radar.raderPeakRadius = 5.f;
    self.radar.isShowSeparate = YES;
    self.radar.radarPeakColor = [UIColor whiteColor];
    [self.radar strokePath];
    
    [self setItemLabelOnChart];
    [self setPolygon];
}

#pragma mark - 设置多边形
/**
 *  设置多边形
 */
- (void)setPolygon{
    id subObject = _valueArray.firstObject;
    //一组数据
    if ([subObject isKindOfClass:[NSString class]]) {
        CGFloat width = self.radar.radius * 2;
        CGFloat height = width;
        
        LJRadarPolygon * polygon = [[LJRadarPolygon alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        polygon.polygonColor = [UIColor orangeColor];
        polygon.center = self.radar.center;
        polygon.averageRadarAngle = self.radar.averageRadarAngle;
        polygon.maxValue = 10;
        polygon.maxRadius = self.radar.radius;
        polygon.valueArray = _valueArray;
        polygon.opacity = 0.3;
        polygon.polygonLineColor = [UIColor orangeColor];
        polygon.polygonLineWidth = 1.f;
        [self.radar addSubview:polygon];
        
        [polygon strokePath];
    }
}

#pragma mark - 设置item label

/**
 *  设置item label
 */
- (void)setItemLabelOnChart{
    
    CGFloat maxValue = [self getMaxValue:_valueArray];
    
    NSArray *itemLabelCenterArray = self.radar.itemLabelCenterArray;
    
    for (NSInteger i = 0; i < itemLabelCenterArray.count; i++) {
        CGPoint labelCenter = [itemLabelCenterArray[i] CGPointValue];
        CGSize size = CGSizeZero;
        if (i == 0) {
             size = CGSizeMake(50, 18);
        } else {
             size = CGSizeMake(26, 30);
        }
        
        UILabel * itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        itemLabel.numberOfLines = 0;
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.font = [UIFont systemFontOfSize:10];
        itemLabel.center = labelCenter;
        itemLabel.text = [self.radar.itemArray objectAtIndex:i];
        itemLabel.textColor = [UIColor blackColor];
        [self.radar addSubview:itemLabel];
        
        // 最大值item文案色值
        if (itemLabelCenterArray.count == self.valueArray.count) {
            if (maxValue == [[self.valueArray objectAtIndex:i] floatValue]) {
                itemLabel.textColor = [UIColor orangeColor];
            }
        }
    }
}

// 获取最大值index
- (CGFloat)getMaxValue:(NSArray *)array {
    float value = 0;
    for (int i = 0; i < array.count; i ++) {
        
        if ([[array objectAtIndex:i] floatValue] > value ) {
            value = [[array objectAtIndex:i] floatValue];
        }
    }
    return value;
}


@end
