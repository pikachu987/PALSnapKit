//
//  ViewController.swift
//  PALSnapKit
//
//  Created by pikachu987 on 01/16/2021.
//  Copyright (c) 2021 pikachu987. All rights reserved.
//

import UIKit
import PALSnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let view = UIView()
        view.backgroundColor = .blue
        self.view.addSubview(view)
        view.make { (make) in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50).labeled(.height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            view.constraints(labelType: .height).first?.constant = 100
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

