//
//  WebsiteCD.swift
//  news
//
//  Created by ryan_ho on 2015/7/6.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import CoreData

class WebsiteCD:NSManagedObject{
    @NSManaged var webSiteId:String!
    @NSManaged var apiurl:String!
    @NSManaged var imgurl:String!
    @NSManaged var name:String!
}
