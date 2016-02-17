//
//  SlideBarButton.swift
//  news
//
//  Created by ryan_ho on 2015/3/31.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation

class SlideBarButton: UIButton {
//        self.frame = CGRectMake(20, 20, 19, 22)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let burBut = UIImage(named: "burger")
        self.setImage(burBut, forState: .Normal)
    }

}