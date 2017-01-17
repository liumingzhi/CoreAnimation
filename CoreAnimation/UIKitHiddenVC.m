//
//  UIKitHiddenVC.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 17/1/11.
//  Copyright © 2017年 mingzhi.liu. All rights reserved.
//

//*************************************//
// 验证隐式动画被UIView关联图层给禁用了
//*************************************//

#import "UIKitHiddenVC.h"

@interface UIKitHiddenVC ()
@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) NSString *testStr;

@end

@implementation UIKitHiddenVC

-(void)dealloc
{


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(100, 70, 100, 100)];
    self.layerView.layer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view addSubview:self.layerView];
    
    // 当属性在动画块之外发生改变，UIView直接通过返回nil来禁用隐式动画。但如果在动画块范围之内，根据动画具体类型返回相应的属性
    NSLog(@"Outside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    
    [UIView beginAnimations:nil context:nil];
    
    NSLog(@"Inside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    
    [UIView commitAnimations];
    
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 120, 30)];
    changeBtn.backgroundColor = [UIColor grayColor];
    [changeBtn setTitle:@"changeColor" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
    
}

-(void)btnclick
{
    [CATransaction begin];
    //set the animation duration to 1 second
    [CATransaction setAnimationDuration:1.0];
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.layerView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    //commit the transaction
    [CATransaction commit];
    
//    [UIView animateWithDuration:16 animations:^{
//        
//        self.view.backgroundColor = [UIColor redColor];
//
//    } completion:^(BOOL finished) {
//        if (finished) {
//
//            NSLog(@"finished");
//        }
//        else
//        {
//            NSLog(@"failed");
//
//        }
//    }];

    
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.testStr = @"123";
    });
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
