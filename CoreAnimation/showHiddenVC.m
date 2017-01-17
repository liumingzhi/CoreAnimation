//
//  showHiddenVC.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 17/1/10.
//  Copyright © 2017年 mingzhi.liu. All rights reserved.
//


//*************************************//
// 验证显式&隐式动画
//*************************************//

#import "showHiddenVC.h"

@interface showHiddenVC ()
@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation showHiddenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame=CGRectMake(10, 10, 100, 100);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(100, 70, 10, 10)];
    [self.layerView.layer addSublayer:self.colorLayer];
    self.layerView.layer.cornerRadius = 5;
    self.layerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.view addSubview:self.layerView];
    
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 120, 30)];
    changeBtn.backgroundColor = [UIColor grayColor];
    [changeBtn setTitle:@"changeColor" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
}

-(void)btnclick
{
    // 隐式动画
    [CATransaction begin];
    [CATransaction setAnimationDuration:1];
    
    [CATransaction setCompletionBlock:^{
        
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;
    }];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;

    [CATransaction commit];
    
    
//    // 显式动画
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//    
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.fromValue = (__bridge id)color.CGColor;
//    
//    // 事物嵌套
//    [CATransaction begin];
//    //[CATransaction setDisableActions:YES];
//    
//    [CATransaction setAnimationDuration:1];
//   // [CATransaction setValue:[NSNumber numberWithInt:3] forKey:kCATransactionAnimationDuration];
//    self.colorLayer.backgroundColor = color.CGColor;
//    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:4];
//    CGAffineTransform transform = self.colorLayer.affineTransform;
//    transform = CGAffineTransformRotate(transform, M_PI_2);
//    self.colorLayer.affineTransform = transform;
//    [CATransaction commit];
//
//    [CATransaction commit];
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
