//
//  MenuCell.swift
//  news
//
//  Created by ryan_ho on 2015/4/29.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation

class MenuCell:UITableViewCell{
    
    @IBOutlet var img:UIImageView?
    @IBOutlet var label:UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
    }
    
}