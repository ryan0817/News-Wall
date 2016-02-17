//
//  MainCollectionViewCell.swift
//  news
//
//  Created by ryan_ho on 2015/5/11.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet var img:UIImageView?
    @IBOutlet var subject:UILabel?
    @IBOutlet var like:UIButton?
    @IBOutlet var webSiteName:UILabel?
    
    let borderColor:CGColor = UIColor(red: 115.0/255.0, green: 162.0/255.0, blue: 177.0/255.0, alpha: 0.3).CGColor
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        // 設定Cell框線
        self.layer.borderWidth = 3.0
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = 7.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 設定Cell框線
        self.layer.borderWidth = 3.0
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = 7.5
    }
}
