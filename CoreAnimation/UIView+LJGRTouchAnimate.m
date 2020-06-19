//
//  UIView+TouchAnimate.m
//  Lianjia_Beike_SecondHand_Private
//
//  Created by Ryan on 2018/11/7.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#pragma mark - LJRGTouchAnimateHandler

typedef NS_ENUM(NSUInteger, LJViewTouchAnimateStatus) {
    LJViewTouchAnimateStatusStart,
    LJViewTouchAnimateStatusAnimating,
    LJViewTouchAnimateStatusFinished,
};

@interface LJRGTouchAnimateHandler : UIPanGestureRecognizer <UIGestureRecognizerDelegate>
// @property (nonatomic, assign) BOOL didFinished; // 动画执行结束
@property (nonatomic, assign) LJViewTouchAnimateStatus animateStatus;
@property (nonatomic, assign) BOOL needFeedback; // 需要震动
@property (nonatomic, assign) float responseDelay; // 响应延迟，为了点击时才响应，单位秒
@end

@implementation LJRGTouchAnimateHandler

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"state"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.cancelsTouchesInView = NO;
//        self.didFinished = NO;
        self.animateStatus = LJViewTouchAnimateStatusStart;
        self.needFeedback = YES;
        self.responseDelay = 0.0;
        
        
        [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

// 监听手势状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    
    // 处理tapAnimate时，未开始t动画之前触发复原时，直接移除动画
    if (self.responseDelay > 0.0 && self.animateStatus == LJViewTouchAnimateStatusStart) {
        self.animateStatus = LJViewTouchAnimateStatusFinished;
        return;
    }
    
    // 动画结束时，触发复原时，立即执行复原动画
    // 动画未开始或者执行中，延迟0.1秒再复原，避免复原的太突兀
    float delay = (self.animateStatus == LJViewTouchAnimateStatusFinished) ? 0 : 0.1;
    [UIView animateWithDuration:0.2 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    NSNumber *old = change[NSKeyValueChangeOldKey];
    NSNumber *new = change[NSKeyValueChangeNewKey];
    
    if ([old integerValue] == 0 &&
        ([new integerValue] == UIGestureRecognizerStateCancelled ||
         [new integerValue] == UIGestureRecognizerStateFailed)) {
            
        // 震动
        if (@available(iOS 10.0, *) && self.needFeedback) {
            UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [generator prepare];
            [generator impactOccurred];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

// 手指触摸屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 缩小动画
    self.animateStatus = LJViewTouchAnimateStatusStart;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.responseDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.animateStatus == LJViewTouchAnimateStatusFinished) {
            return ;
        }
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.view.transform = CGAffineTransformMakeScale(0.96, 0.96);
            self.animateStatus = LJViewTouchAnimateStatusAnimating;
        } completion:^(BOOL finished) {
            self.animateStatus = LJViewTouchAnimateStatusFinished;
        }];
    });
    
    return YES;
}

// 是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// 这个方法返回YES，第一个手势和第二个互斥时，第一个会失效，即当前手势失效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

#pragma mark - UIView (TouchAnimate)

@implementation UIView (LJGRTouchAnimate)

// 触摸 缩放、震动效果
- (void)setShowTouchAnimate:(BOOL)showTouchAnimate {
    [self handlerAnimate:showTouchAnimate isTap:NO];
}

- (BOOL)showTouchAnimate {
    return objc_getAssociatedObject(self, &self) != nil;
}

// 点击 缩放效果
- (void)setShowTapAnimate:(BOOL)showTapAnimate {
    [self handlerAnimate:showTapAnimate isTap:YES];
}

- (BOOL)showTapAnimate {
    return objc_getAssociatedObject(self, &self) != nil;
}

// 动效处理
- (void)handlerAnimate:(BOOL)showAnimate isTap:(BOOL)isTap {
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, &self);
    
    // 添加动效
    if (showAnimate && !gesture) {
        LJRGTouchAnimateHandler *gesture = [[LJRGTouchAnimateHandler alloc] init];
        gesture.cancelsTouchesInView = !self.userInteractionEnabled;
        if (isTap) {
            gesture.needFeedback = NO;
            gesture.responseDelay = 0.1;
        }
        [self addGestureRecognizer:gesture];
        
        self.userInteractionEnabled = YES;
        
        objc_setAssociatedObject(self, &self, gesture, OBJC_ASSOCIATION_ASSIGN);
    }
    // 移除动效
    else if (!showAnimate && gesture) {
        [self removeGestureRecognizer:gesture];
    }
}

@end


