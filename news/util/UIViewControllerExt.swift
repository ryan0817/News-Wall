//
//  UIViewControllerExt.swift
//  news
//
//  Created by ryan_ho on 2015/4/13.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "burger")!)
//        self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
    }
}