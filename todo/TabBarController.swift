//
//  TabBarController.swift
//  todo
//
//  Created by Kohei Hisakuni on 12/14/18.
//  Copyright © 2018 Kohei Hisakuni. All rights reserved.
//

import UIKit

protocol Injectable {
    func inject(data: List)
}

class TabBarController: UITabBarController {
    var list = List()
    override func viewDidLoad() {
        super.viewDidLoad()
        for navController in viewControllers! {
            if let navController = navController as? UINavigationController,
                let viewController = navController.viewControllers.first as? Injectable {
                viewController.inject(data: list)
            }
        }
    }
}
