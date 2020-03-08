//
//  RadarVC.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 2020/3/8.
//  Copyright © 2020 mingzhi.liu. All rights reserved.
//

#import "RadarVC.h"
#import "LJRadarChart.h"

@interface RadarVC ()
@property (nonatomic, strong) LJRadarChart * radarChart;

@end

@implementation RadarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"雷达图";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.radarChart];

    self.radarChart.valueArray = @[@"6",@"9",@"7",@"8",@"8"];
    self.radarChart.itemArray = @[@"房型",@"价格",@"配套",@"装修",@"优惠"];
    [self.radarChart strokePath];
    
    
}

- (LJRadarChart *)radarChart {
    if (!_radarChart) {
        _radarChart = [[LJRadarChart alloc] initWithFrame:CGRectMake(100, 100, 170, 170)];
    }
    return _radarChart;
}

@end
