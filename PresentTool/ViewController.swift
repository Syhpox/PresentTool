//
//  ViewController.swift
//  PresentTool
//
//  Created by 吴志华 on 2018/3/26.
//  Copyright © 2018年 wzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect(x: 100, y: 200, width: 100, height: 80)
        btn.setTitle("Present", for: .normal)
        view.addSubview(btn)
        
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    @objc private func btnClick() {
        let vc = TestPresentViewController.init(presentingVC: self)
        self.present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

