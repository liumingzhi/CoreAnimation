//
//  LJRadarChart.h
//  
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJRadar.h"

@interface LJRadarChart : UIView
/** 存储数据的数组 */
@property (nonatomic, strong) NSArray * valueArray;
@property (nonatomic, strong) NSArray * itemArray;

// 绘制
- (void)strokePath;

@end
