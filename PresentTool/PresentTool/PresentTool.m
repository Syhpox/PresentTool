//
//  PresentTool.m
//  PresentTool
//
//  Created by 吴志华 on 2018/4/16.
//  Copyright © 2018年 wzh. All rights reserved.
//

#import "PresentTool.h"
@interface PresentTool() <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIViewController *presentedVC;
@property (nonatomic, strong) UIViewController *presentingVC;
@end

@implementation PresentTool
- (instancetype)initWithPresentedVC: (UIViewController *)vc {
    if (self = [super init]) {
        self.duration = 0.35;
        self.animationType = PresentionBaseAnimationAlert;
        self.presentedVC = vc;
        self.presentedVC.transitioningDelegate = self;
    }
    return self;
}

#pragma mark UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    self.presentingVC = source;
    return [[PresentConfigPresentationController alloc] initWithPresentTool:self];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 动画过程
}
@end

@interface PresentConfigPresentationController()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) PresentTool *tool;
@end
@implementation PresentConfigPresentationController
- (instancetype)initWithPresentTool: (PresentTool *)tool {
    if (self = [super initWithPresentedViewController:tool.presentedVC presentingViewController:tool.presentingVC]) {
        self.tool = tool;
    }
    return self;
}
- (void)presentationTransitionWillBegin {
    self.bgView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.containerView addSubview:self.bgView];
    self.bgView.alpha = 0.0;
    [[self.presentingViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.bgView.alpha = 1.0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)dismissalTransitionWillBegin {
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.bgView.alpha = 0.0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.tool.presentedVC = nil;
    }];
}
@end
