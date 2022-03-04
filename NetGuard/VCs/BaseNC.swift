//
//  BaseNC.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 24.01.2021.
//

import UIKit

class BaseNC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            let appearance = navigationBar.standardAppearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        
    }
}
