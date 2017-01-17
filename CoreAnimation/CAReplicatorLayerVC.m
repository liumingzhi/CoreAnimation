//
//  CAReplicatorLayerVC.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 17/1/5.
//  Copyright © 2017年 mingzhi.liu. All rights reserved.
//

#import "CAReplicatorLayerVC.h"

@interface CAReplicatorLayerVC ()

@end

@implementation CAReplicatorLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
//    首先我们要得到一个love路径,这个路径用UIBezierPath来制作。
//    然后生成一个UIView,它的layer加上CAKeyframeAnimation,而CAKeyframeAnimation的路径是love路径。
//    把UIView的layer加入CAReplicatorLayer。并对设置CAReplicatorLayer相应属性即可。
    
    // love
    // 路径
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(screenWidth/2.0, 200)];
    [path addQuadCurveToPoint:CGPointMake(screenWidth/2.0, 300) controlPoint:CGPointMake(screenWidth/2.0 + 100, 120)];
    [path addQuadCurveToPoint:CGPointMake(screenWidth/2.0, 200) controlPoint:CGPointMake(screenWidth/2.0 - 100, 120)];
    [path closePath];
    
    // 执行动画view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.center = CGPointMake(screenWidth/2.0, 200);
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    // 对view添加帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = path.CGPath;
    keyAnimation.duration = 8;
    keyAnimation.repeatCount = MAXFLOAT;
    [view.layer addAnimation:keyAnimation forKey:@"loveAnimation"];

    // 生成CAReplicaatorLayer
    CAReplicatorLayer *loveLayer = [CAReplicatorLayer layer];
    loveLayer.instanceCount = 40; // 复制39个layer，共40个
    loveLayer.instanceDelay = 0.2;// 每隔0.2秒出现一个layer
    loveLayer.instanceColor = [UIColor redColor].CGColor;
    loveLayer.instanceGreenOffset = - 0.03; // 颜色递减
    loveLayer.instanceRedOffset = - 0.02;
    loveLayer.instanceBlueOffset = - 0.01;
    [loveLayer addSublayer:view.layer];
    
    [self.view.layer addSublayer:loveLayer];
    
    
    
    // 控制点标注
    UIView *controlPoint1 = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2.0 + 100, 120, 3, 3)];
    controlPoint1.backgroundColor = [UIColor redColor];
    [self.view addSubview:controlPoint1];
    
    UIView *controlPoint2 = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2.0 - 100, 120, 3, 3)];
    controlPoint2.backgroundColor = [UIColor redColor];
    [self.view addSubview:controlPoint2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
