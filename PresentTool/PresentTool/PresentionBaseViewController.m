//
//  PresentionSuperViewController.m
//  URLRoute
//
//  Created by WZH on 2017/9/20.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

#import "PresentionBaseViewController.h"

@interface PresentionBaseViewController ()
@end

@implementation PresentionBaseViewController

- (instancetype)initWithPresentingVC: (UIViewController *)presentingVC {
    if (self = [super init]) {
        self.animationType = PresentionBaseAnimationAlert;
        self.duration = 0.3;

        self.delegate = [[PresentationBaseController alloc] initWithPresentedViewController:self presentingViewController:presentingVC];
        self.transitioningDelegate  = self.delegate;
    }
    return self;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:^{
        if (completion != nil) {
            completion();
        }
        if (_completeBlc != nil) {
            _completeBlc();
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
@interface PresentationBaseController  ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, weak) PresentionBaseViewController *presentedVC;
@end

@implementation PresentationBaseController

- (instancetype)initWithPresentedViewController:(PresentionBaseViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        self.presentedVC = presentedViewController;
    }
    return self;
}

- (void)presentationTransitionWillBegin {
    
    _bgView = [[UIView alloc] initWithFrame: self.containerView.bounds];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.containerView addSubview:_bgView];
    _bgView.alpha = 0.0;
    __weak typeof(self) weakSelf = self;
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        weakSelf.bgView.alpha = 1.0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)dismissalTransitionWillBegin {
    __weak typeof(self) weakSelf = self;
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        weakSelf.bgView.alpha = 0.0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

#pragma mark UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0) {
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _presentedVC.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contaView = transitionContext.containerView;
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    BOOL isPresenting = fromVC == self.presentingViewController;
    
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    
    [contaView addSubview:isPresenting ? toView : fromView];
    
    CGRect normalFrame = CGRectMake(CGRectGetMinX(contaView.bounds), CGRectGetMinY(contaView.bounds), toViewFinalFrame.size.width, toViewFinalFrame.size.height);
    if (isPresenting) {
        toView.frame = normalFrame;
    } else {
        fromView.frame = normalFrame;
    }
    
    NSTimeInterval duration = _presentedVC.duration;
    switch (_presentedVC.animationType) {
        case PresentionBaseAnimationAlert:
            if (isPresenting) {
                _presentedVC.mainView.center = CGPointMake(_presentedVC.view.frame.size.width / 2.0, _presentedVC.view.frame.size.height / 2.0);
                _presentedVC.mainView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }
            break;
        case PresentionBaseAnimationActionSheet:
        {
            CGFloat frameHeight = _presentedVC.view.frame.size.height;
            CGFloat frameWidth = _presentedVC.view.frame.size.width;
            if (isPresenting) {
                _presentedVC.mainView.frame = CGRectMake((frameWidth - _presentedVC.mainView.frame.size.width) / 2.0, frameHeight, _presentedVC.mainView.frame.size.width, _presentedVC.mainView.frame.size.height);
            } else {
                _presentedVC.mainView.frame = CGRectMake(_presentedVC.mainView.frame.origin.x, frameHeight - _presentedVC.mainView.frame.size.height, _presentedVC.mainView.frame.size.width, _presentedVC.mainView.frame.size.height);
            }

        }
            break;

        case PresentionBaseAnimationMode_0:
        {
            CGFloat changeY = isPresenting ? normalFrame.size.height + _presentedVC.mainView.frame.size.height / 2.0 : normalFrame.size.height / 2.0;
            _presentedVC.mainView.center = CGPointMake(normalFrame.size.width / 2.0, changeY);
        }
            break;

        case PresentionBaseAnimationMode_1:
        {
            (isPresenting ? toView : fromView).alpha = isPresenting ? 0.0 : 1.0;
            _presentedVC.mainView.center = CGPointMake(_presentedVC.view.frame.size.width / 2.0, _presentedVC.view.frame.size.height / 2.0);
        }
            break;
        default:
            break;
    }
    
    // 动画中
    [UIView animateWithDuration:duration animations:^{
        switch (_presentedVC.animationType) {
            case PresentionBaseAnimationAlert:
            {
                (isPresenting ? toView : fromView).alpha = isPresenting ? 1.0 : 0.0;
                if (isPresenting) {
                    _presentedVC.mainView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }
            }
                break;
            case PresentionBaseAnimationActionSheet:
            {
                CGFloat frameHeight = _presentedVC.view.frame.size.height;
                CGFloat frameWidth = _presentedVC.view.frame.size.width;
                if (!isPresenting) {
                    _presentedVC.mainView.frame = CGRectMake((frameWidth - _presentedVC.mainView.frame.size.width) / 2.0, frameHeight, _presentedVC.mainView.frame.size.width, _presentedVC.mainView.frame.size.height);
                } else {
                    _presentedVC.mainView.frame = CGRectMake(_presentedVC.mainView.frame.origin.x, frameHeight - _presentedVC.mainView.frame.size.height, _presentedVC.mainView.frame.size.width, _presentedVC.mainView.frame.size.height);
                }
                
            }
                break;

            case PresentionBaseAnimationMode_0:
                if (isPresenting) {
                    _presentedVC.mainView.center = CGPointMake(normalFrame.size.width / 2.0, normalFrame.size.height / 2.0);
                } else {
                    _presentedVC.mainView.center = CGPointMake(normalFrame.size.width / 2.0, normalFrame.size.height + _presentedVC.mainView.frame.size.height / 2.0);
                }
                break;

            case PresentionBaseAnimationMode_1:
                (isPresenting ? toView : fromView).alpha = isPresenting ? 1.0 : 0.0;
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end




