//
//  TestPresentViewController.swift
//  PresentTool
//
//  Created by 吴志华 on 2018/3/26.
//  Copyright © 2018年 wzh. All rights reserved.
//

import Foundation
import UIKit

class TestPresentViewController: UIViewController {
    var presentConfig: PresentConfig!
    
    required init(presentingVC: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        presentConfig = PresentConfig(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试Present"
        
        let mainView = UIView.init(frame: CGRect(x: 0, y: 0, width: 240, height: 180))
        mainView.backgroundColor = .blue
        view.addSubview(mainView)
        
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        btn.setTitle("Present", for: .normal)
        btn.backgroundColor = .brown
        mainView.addSubview(btn)
        presentConfig.mainView = mainView
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        // 动画类型
        presentConfig.animationType = .fade
        // 动画View
        presentConfig.mainView = mainView
    }
    
    @objc private func btnClick() {
        self.dismiss(animated: true, completion: nil)
    }
}
