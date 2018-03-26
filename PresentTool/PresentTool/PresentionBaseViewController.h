//
//  PresentionSuperViewController.h
//  URLRoute
//
//  Created by WZH on 2017/9/20.
//  Copyright © 2017年 Zhihua. All rights reserved.
//  PresentConfig OC版

#import <UIKit/UIKit.h>
@class PresentationBaseController;

typedef NS_ENUM(NSInteger, PresentionBaseAnimation) {
    PresentionBaseAnimationAlert = 0, // 系统Alert样式
    PresentionBaseAnimationActionSheet = 1, // 系统actionSheet样式
    PresentionBaseAnimationMode_0 = 2,   // 下到上
    PresentionBaseAnimationMode_1 = 3    // fade 透明度
};

@interface PresentionBaseViewController : UIViewController
@property (nonatomic, strong) UIView *mainView; // 核心view 动画主体视图
@property (nonatomic, strong) PresentationBaseController *delegate;
@property (nonatomic, assign) PresentionBaseAnimation animationType; // 动画样式
@property (nonatomic, assign) NSTimeInterval duration; // 动画时间
@property (nonatomic, strong) void (^completeBlc)();
- (instancetype)initWithPresentingVC: (UIViewController *)presentingVC;
@end
@interface PresentationBaseController : UIPresentationController <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
- (instancetype)initWithPresentedViewController:(PresentionBaseViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController;
@end
