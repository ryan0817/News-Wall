//
//  NewsMainCellTableViewCell.swift
//  news
//
//  Created by ryan_ho on 2015/3/19.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import UIKit

class NewsMainCell: UITableViewCell {
    
    @IBOutlet var img:UIImageView?
    @IBOutlet var subject:UILabel?
    @IBOutlet var like:UIButton?
    @IBOutlet var webSiteName:UILabel?
    
//    var news:News!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
