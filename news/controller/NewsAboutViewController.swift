//
//  NewsAboutController.swift
//  news
//
//  Created by ryan_ho on 2015/4/14.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation

class NewsAboutViewController:UIViewController{
    
    @IBOutlet var contract:UIButton?
    @IBOutlet var message:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.navigationItem.title = "About us"
        
        self.contract!.layer.cornerRadius = 5
        self.contract!.clipsToBounds = true
        
        self.message!.text = "訂閱喜歡的網站\n讓您專注在重要的資訊上！"
        
        // 手勢向左滑打開menu bar
        var swipRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipRight")
        swipRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view?.addGestureRecognizer(swipRight)
    }
    
    func swipRight(){
        var menuController:SlideMenuController = self.view?.window?.rootViewController as! SlideMenuController
        menuController.openLeft()
    }
}