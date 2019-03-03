//
//  MHAlertView.m
//  MHLibrary
//
//  Created by huxb on 14-10-9.
//  Copyright (c) 2014年 Outsourcing. All rights reserved.
//

#import "MHAlertView.h"

/* 获取iphone参数 */
#define kSCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface MHAlertView ()
{
    UIView *bgView;
}

@end

@implementation MHAlertView

-(id)init
{
    self = [super init];
    if (self)
    {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_SIZE.width, kSCREEN_SIZE.height)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.6;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:bgView];
    [topVC.view addSubview:self];
    self.center = topVC.view.center;
    self.layer.cornerRadius = 5;
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:animation forKey:nil];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//    [bgView addGestureRecognizer:tapGesture];
}

- (void)localShow
{
    [self.superview addSubview:bgView];
    [self.superview bringSubviewToFront:self];
    self.center = self.superview.center;
    self.layer.cornerRadius = 5;
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:animation forKey:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tapGesture];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^
    {
        bgView.alpha = 0;
        self.alpha = 0.2;
    }
    completion:^(BOOL finished)
    {
        [bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
