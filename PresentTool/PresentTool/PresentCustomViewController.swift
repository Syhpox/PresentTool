//
//  URLNavigatorViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/8/14.
//  Copyright © 2017年 Zhihua. All rights reserved.
//  PresentConfig v1.0

import UIKit
/// 自定义弹出动画接口协议
protocol PresentCustomViewControllerAnimationProtocol {
    /// 刚弹出  动画初始状态
    func animatedBegin()
    /// 刚弹出  动画末状态
    func animated()
    /// 弹回消失 动画末状态
    func animatedDismiss()
}
/// 动画样式
enum PresentCustomViewControllerAnimation {
    case alert          // 系统Alert样式
    case actionSheet    // 系统actionSheet样式
    
    case mode_0         // 下到上
    case mode_1         // fade 透明度
    
    case custom(PresentCustomViewControllerAnimationProtocol)
}

class PresentCustomViewController: UIViewController {
    /// 核心视图
    open var mainView: UIView!
    
    /// present代理
    fileprivate var delegate: PresentCustomPresentationController!
    
    /// 动画类型
    var animationType: PresentCustomViewControllerAnimation = .alert
    
    /// 动画持续时间
    var duration: TimeInterval!
    
    /// 结束block
    var completeBlc:(() -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(presentingVC: UIViewController, type: PresentCustomViewControllerAnimation = .alert, duration: TimeInterval = 0.35) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = PresentCustomPresentationController.init(presentedVC: self, presenting: presentingVC)
        self.transitioningDelegate = self.delegate
        self.animationType = type
        self.duration = duration
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            if completion != nil {
                completion!()
            }
            if let blc = self.completeBlc {
                blc()
            }
        }
    }
}

class PresentCustomPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    fileprivate var bgView: UIView!
    fileprivate weak var presentedVC: PresentCustomViewController!
    
    private override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }
    
    convenience init(presentedVC: PresentCustomViewController, presenting presentingVC: UIViewController?) {
        self.init(presentedViewController: presentedVC, presenting: presentingVC)
        self.presentedVC = presentedVC
    }
    
    override func presentationTransitionWillBegin() {
        bgView = UIView.init(frame: (containerView?.bounds)!)
        bgView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        containerView?.addSubview(bgView)
        bgView.alpha = 0.0
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] (context) in
            self?.bgView.alpha = 1.0
            }, completion: { (context) in
                
        })
    }
    
    /// dismiss刚开始
    override func dismissalTransitionWillBegin() {
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] (context) in
            self?.bgView.alpha = 0.0
            }, completion: { (context) in
        })
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    @available(iOS 2.0, *)
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // 动画时间
        return presentedVC.duration
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        let containView = transitionContext.containerView
        
        let fromView: UIView! = transitionContext.view(forKey: .from)
        let toView: UIView! = transitionContext.view(forKey: .to)
        
        let isPresenting = fromVC == self.presentingViewController
        //        let fromViewInitFrame = transitionContext.initialFrame(for: fromVC!)
//        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC!)
        //        var toViewInitFrame = transitionContext.initialFrame(for: toVC!)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC!)
        
        containView.addSubview(isPresenting ? toView : fromView)
        
        let normalFrame = CGRect(origin: CGPoint(x: containView.bounds.minX, y: containView.bounds.minY), size: toViewFinalFrame.size)
        if isPresenting {
            toView.frame = normalFrame
        } else {
            fromView.frame = normalFrame
        }
        
        // 动画时间
        let duration = presentedVC.duration
        
        switch presentedVC.animationType {
        case .alert:
            if isPresenting {
                presentedVC.mainView.center = CGPoint(x: presentedVC.view.frame.width / 2.0, y: presentedVC.view.frame.height / 2.0)
                presentedVC.mainView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            }
        case .actionSheet:
            let frameHeight = presentedVC.view.frame.height
            let frameWidth = presentedVC.view.frame.width
            if isPresenting {
                presentedVC.mainView.frame = CGRect(x: (frameWidth - presentedVC.mainView.frame.width) / 2.0, y: frameHeight, width: presentedVC.mainView.frame.width, height: presentedVC.mainView.frame.height)
            } else {
                self.presentedVC.mainView.frame = CGRect(x: self.presentedVC.mainView.frame.origin.x, y: frameHeight - self.presentedVC.mainView.frame.height, width: self.presentedVC.mainView.frame.width, height: self.presentedVC.mainView.frame.height)
            }
        case .mode_0:
            let changeY = isPresenting ? normalFrame.size.height + self.presentedVC.mainView.frame.size.height / 2.0 : normalFrame.size.height / 2.0
            presentedVC.mainView.center = CGPoint(x: normalFrame.size.width / 2.0, y: changeY)
        case .mode_1:
            (isPresenting ? toView : fromView)?.alpha = isPresenting ? 0.0 : 1.0
            
            presentedVC.mainView.center = CGPoint(x: presentedVC.view.frame.width / 2.0, y: presentedVC.view.frame.height / 2.0)
        case .custom(let animationView):
            if isPresenting {
                animationView.animatedBegin()
            } else {
                animationView.animated()
            }
        }
        
        // 动画中
        UIView.animate(withDuration: duration ?? 0.35, animations: {
            switch self.presentedVC.animationType {
            case .alert:
                (isPresenting ? toView : fromView)?.alpha = isPresenting ? 1.0 : 0.0
                if isPresenting {
                    self.presentedVC.mainView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                }
            case .actionSheet:
                let frameHeight = self.presentedVC.view.frame.height
                let frameWidth = self.presentedVC.view.frame.width
                if !isPresenting {
                    self.presentedVC.mainView.frame = CGRect(x: (frameWidth - self.presentedVC.mainView.frame.width) / 2.0, y: frameHeight, width: self.presentedVC.mainView.frame.width, height: self.presentedVC.mainView.frame.height)
                } else {
                    self.presentedVC.mainView.frame = CGRect(x: self.presentedVC.mainView.frame.origin.x, y: frameHeight - self.presentedVC.mainView.frame.height, width: self.presentedVC.mainView.frame.width, height: self.presentedVC.mainView.frame.height)
                }
                
            case .mode_0:
                if isPresenting {
                    self.presentedVC.mainView.center = CGPoint(x: normalFrame.size.width / 2.0, y: normalFrame.size.height / 2.0)
                } else {
                    self.presentedVC.mainView.center = CGPoint(x: normalFrame.size.width / 2.0, y: normalFrame.size.height + self.presentedVC.mainView.frame.size.height / 2.0)
                }
            case .mode_1:
                (isPresenting ? toView : fromView)?.alpha = isPresenting ? 1.0 : 0.0
            case .custom(let animationView):
                if isPresenting {
                    animationView.animated()
                } else {
                    animationView.animatedDismiss()
                }
            }
            
        }) { (finish) in
            let cancel = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancel)
        }
        
    }
    
}

