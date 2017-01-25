//
//  CoreAnimationVC.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 17/1/24.
//  Copyright © 2017年 mingzhi.liu. All rights reserved.
//

#import "CoreAnimationVC.h"

@interface CoreAnimationVC ()
@property (nonatomic, strong) UIView *redView;
@end

@implementation CoreAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initBtn];
}

- (void)initBtn
{
    NSInteger SpaceXStart = 40;
    
    for (int i = 0; i < 3 ; i ++)
    {
        
        NSInteger btnWidth = 50;
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor grayColor];
        btn.frame = CGRectMake(SpaceXStart, 70, btnWidth, 40);
        [btn setTitle:[NSString stringWithFormat:@"btn%d",i] forState:UIControlStateNormal];
        
        SpaceXStart += btn.frame.size.width;
        SpaceXStart += 20;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [self.view addSubview:btn];
        
    }

}

-(void)btnClick:(id)sender
{
    [self removeAllSubviews];
    [self initBtn];
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0)
    {
        [self doBasicAnimation];
    }
    else if (btn.tag == 1)
    {
        [self keyFrameAnimation];
    }
    else if (btn.tag == 2)
    {
        [self animationGroup];
    }
    else if (btn.tag == 3)
    {
//        [self removeAllSubviews];
//        
//        [self initBtn];
    }

}

- (void)removeAllSubviews {
    while (self.view.subviews.count) {
        UIView* child = self.view.subviews.lastObject;
        [child removeFromSuperview];
    }
}


-(void)doBasicAnimation
{
    CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    /*fillMode这个属性，必须要配合removedOnCompletion这个属性来使用。这个属性的默认值是YES(回到原处),此时fillMode是没有作用的.如果设置为NO那么就需要设置一个fillMode属性，就是动画结束之后的状态，如果不设置，动画也会回到原处*/
    base.removedOnCompletion = NO;
    base.fillMode = kCAFillModeBackwards;
    base.fromValue = @2;
    base.duration = 3;
    base.repeatCount = 1;
    //给base动画设置延时启动
    base.beginTime = 2 + CACurrentMediaTime();
    //动画是否按原路径返回
    base.autoreverses = YES;
    
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(40, 200, 120, 120)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    
    [self.redView.layer addAnimation:base forKey:@"basic"];
    
//    // key：你需要删除的动画的名称
//    [self.redView.layer removeAnimationForKey:@"basic"];
//    
//    // 删除这个视图layer层上的所有动画
//    [self.redView.layer removeAllAnimations];
}


/*
 position是描述动画视图的位置信息的，简单理解就是和视图的中心点一样，所以我们通过改变position属性，就可以改变动画的位置。
 与position相对应得是锚点也就是anchorPoint，anchorPoint、position、frame这三者之间有着如下的关系
 position.x = frame.origin.x + anchorPoint.x * bounds.size.width；
 position.y = frame.origin.y + anchorPoint.y * bounds.size.height；
 
 */

-(void)keyFrameAnimation
{
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(40, 200, 120, 120)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //layer最初的position值
    float positionx = self.redView.layer.position.x;
    float positiony = self.redView.layer.position.y;
    
    // layer 向左偏移量
    NSValue *leftValue = [NSValue valueWithCGPoint:CGPointMake(positionx-30, positiony)];
    // layer 原始位置
    NSValue *originValue = [NSValue valueWithCGPoint:CGPointMake(positionx, positiony)];
    // layer 向右偏移量
    NSValue *rightValue = [NSValue valueWithCGPoint:CGPointMake(positionx+30, positiony)];
    // 添加每一帧value值
    [keyframe setValues:@[originValue,leftValue,originValue,rightValue,originValue]];
    keyframe.repeatCount = 10;
    keyframe.repeatDuration = 1;
    
    [self.redView.layer addAnimation:keyframe forKey:@"keyframe"];
    
}

/*
 
 CAAnimationGroup是一个组合动画，所谓的组合动画就是将多个动画组合到一起让它产生很炫酷的效果。
 注意：所有的组合动画，它的延迟启动，重复次数等属性，同一在组里面设置，不要在单一的动画里面设置，以免出现问题
 
 */

-(void)animationGroup
{
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(40, 200, 120, 120)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];

    // 初始化动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    // 创建至少两个动画
    CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    base.removedOnCompletion = NO;
    base.fillMode = kCAFillModeForwards;
    base.fromValue = @M_PI;
    base.autoreverses = YES;
    
    /********************/
    CAKeyframeAnimation *keyfram = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    float positionx = self.redView.layer.position.x;
    float positiony = self.redView.layer.position.y;
    
    NSValue *leftValue = [NSValue valueWithCGPoint:CGPointMake(positionx - 40, positiony)];
    NSValue *origionValue = [NSValue valueWithCGPoint:CGPointMake(positionx, positiony)];
    NSValue *rightValue = [NSValue valueWithCGPoint:CGPointMake(positionx + 40, positiony)];
    [keyfram setValues:@[origionValue,leftValue,origionValue,rightValue,origionValue]];
    
    // 将动画放入group中
    group.animations = @[base,keyfram];
    group.repeatCount = 10;
    group.repeatDuration = 5;
    
    
    [self.redView.layer addAnimation:group forKey:@"group"];
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
