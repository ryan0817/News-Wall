//
//  CellSubUIView.swift
//  news
//
//  Created by ryan_ho on 2015/5/11.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import UIKit

class CellSubUIView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let lineColor:CGColor = UIColor(red: 115.0/255.0, green: 162.0/255.0, blue: 177.0/255.0, alpha: 0.3).CGColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.layer.borderColor = lineColor
//        self.layer.borderWidth = 3.0
        var topBoarder:CALayer = CALayer()
        topBoarder.frame = CGRectMake(0, 0, self.frame.size.width, 3)
        
        topBoarder.backgroundColor = lineColor
        self.layer.addSublayer(topBoarder)
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
//        self.layer.borderColor = lineColor
//        self.layer.borderWidth = 3.0
        
        var topBoarder:CALayer = CALayer()
        topBoarder.frame = CGRectMake(0, 0, self.frame.size.width, 3)
        topBoarder.backgroundColor = lineColor
        self.layer.addSublayer(topBoarder)
        
    }

}
