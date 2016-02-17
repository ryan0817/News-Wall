//
//  news.swift
//  news
//
//  Created by ryan_ho on 2015/3/19.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation

class News {
    var img:String?
    var subject:String?
    var url:String?
    var webSiteName:String?
    
    init(img:String, subject:String, url:String, webSiteName:String){
        self.img = img
        self.subject = subject
        self.url = url
        self.webSiteName = webSiteName
    }
    
}
