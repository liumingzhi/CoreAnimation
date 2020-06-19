//
//  TouchAnimateVC.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 2020/6/19.
//  Copyright © 2020 mingzhi.liu. All rights reserved.
//

#import "TouchAnimateVC.h"
#import "UIView+LJGRTouchAnimate.h"
#import "UIView+TouchIconAnimate.h"

@interface TouchAnimateVC ()

@end

@implementation TouchAnimateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];


    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    btn1.showTouchAnimate = YES;
    [btn1 setTitle:@"缩小/震动" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:UIColor.grayColor];
    [self.view addSubview:btn1];
    
    
   UIImageView *iconView = [[UIImageView alloc] init];
   iconView.image = [UIImage imageNamed:@"radar_icon_star_light"];
   iconView.frame = CGRectMake(100, 400, 130, 130);
   iconView.showTouchIconAnimate = YES;
   [self.view addSubview:iconView];
    
    
}



@end
