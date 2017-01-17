//
//  CABaseLayerVC.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 17/1/17.
//  Copyright © 2017年 mingzhi.liu. All rights reserved.
//

#import "CABaseLayerVC.h"

@interface CABaseLayerVC ()

@end

@implementation CABaseLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

   // 设置view的圆角属性
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:view];
    view.backgroundColor=[UIColor redColor];
    view.layer.masksToBounds=YES;//设置layer层的切割属性
    view.layer.cornerRadius=10;//设置layer层的圆角半径
    
    CALayer *layer=view.layer;
    CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];//创建一个关键帧动画对象
    ani.duration=3;
    ani.repeatCount = 4;
    ani.values=@[@1,@0,@1];//传入三个关键帧，动画会将试图先慢慢隐藏，再慢慢展现
    [layer addAnimation:ani forKey:@"test"];
    
    
    // 设置view的边框
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(100, 220, 100, 100)];
    [self.view addSubview:view1];
    view1.backgroundColor=[UIColor redColor];
    CALayer *layer1=view1.layer;
    layer1.borderWidth=10;//设置边框的宽度
    layer1.borderColor=[[UIColor magentaColor]CGColor];//设置边框的颜色

    // 设置视图阴影
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(100, 340, 100, 100)];
    [self.view addSubview:view2];
    view2.backgroundColor=[UIColor redColor];
    CALayer *layer2=view2.layer;
    layer2.shadowOffset=CGSizeMake(30, 30);//设置阴影方向
    layer2.shadowColor=[[UIColor blackColor] CGColor];//设置阴影颜色
    layer2.shadowOpacity=0.5;//设置阴影透明度
    layer2.shadowRadius=10;//设置阴影圆角
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
