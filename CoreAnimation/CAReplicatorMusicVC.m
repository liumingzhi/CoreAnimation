//
//  CAReplicatorMusicVC.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 17/1/13.
//  Copyright © 2017年 mingzhi.liu. All rights reserved.
//

#import "CAReplicatorMusicVC.h"

@interface CAReplicatorMusicVC ()

@end

@implementation CAReplicatorMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CAReplicatorLayer *musicLayer = [CAReplicatorLayer layer];
    musicLayer.frame = CGRectMake(0, 0, 160, 100);
    musicLayer.position = self.view.center;
    musicLayer.instanceCount = 4;
    //每个副本向右平移15px
    musicLayer.instanceTransform = CATransform3DMakeTranslation(15, 0, 0);
    
    musicLayer.instanceDelay = 0.2;
    musicLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    musicLayer.masksToBounds = YES;
    [self.view.layer addSublayer:musicLayer];
    
    CALayer *tLayer = [CALayer layer];
    tLayer.frame = CGRectMake(10, 100, 10, 30);
    tLayer.backgroundColor = [UIColor redColor].CGColor;
    [musicLayer addSublayer:tLayer];
    
    CABasicAnimation *musicAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    musicAnimation.duration = 0.35;
    musicAnimation.fromValue = @100;
    musicAnimation.toValue = @85;
    musicAnimation.autoreverses = YES;
    musicAnimation.repeatCount = MAXFLOAT;
    
    [tLayer addAnimation:musicAnimation forKey:@"musicAnimation"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];



    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:view];
    view.backgroundColor=[UIColor redColor];
    [UIView beginAnimations:@"test" context:nil];
    [UIView setAnimationDuration:3];
    view.backgroundColor=[UIColor orangeColor];
    [UIView commitAnimations];//执行commit后，动画即开始执行

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
