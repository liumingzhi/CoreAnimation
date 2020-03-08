//
//  CATransitionVC.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 2020/3/8.
//  Copyright © 2020 mingzhi.liu. All rights reserved.
//

#import "CATransitionVC.h"

@interface CATransitionVC ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) NSInteger clickIndex;

@property (nonatomic, strong) CATransition *cellAnimation;



@end

@implementation CATransitionVC

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = @[@"测试文案1111",@"测试文案2",@"测试文案33"];
    [self.view addSubview:self.textLabel];
    
    [self beginAnimate];
    
  //  self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginAnimate) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)beginAnimate {
    self.textLabel.text = [self.dataArray objectAtIndex:self.clickIndex];;
    [self.textLabel.layer addAnimation:self.cellAnimation forKey:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.clickIndex ++;
    
    if (self.clickIndex == 3) {
        self.clickIndex = 0;
    }

    [self beginAnimate];
}


- (CATransition *)cellAnimation {
    if (!_cellAnimation) {
        _cellAnimation = [CATransition animation];
        _cellAnimation.type = kCATransitionPush;
        _cellAnimation.subtype =  kCATransitionFromTop;
        _cellAnimation.duration = 0.3;
    }
    return _cellAnimation;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.frame = CGRectMake(100, 100, 200, 20);
    }
    return _textLabel;
}
@end
