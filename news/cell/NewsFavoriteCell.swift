//
//  NewsFavoriteCell.swift
//  news
//
//  Created by ryan_ho on 2015/4/16.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation

class NewsFavoriteCell:UITableViewCell{
    
    @IBOutlet var imageFav:UIImageView?
    @IBOutlet var subject:UILabel?
    
//    var news:NewsCD?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        self.subject!.text = news!.subject
//        if news!.img != nil{
//            self.imageFav!.image = UIImage(data: news!.img)
//        }
//        
//    }
    
}
