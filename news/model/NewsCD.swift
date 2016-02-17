//
//  newsCD.swift
//  news
//
//  Created by ryan_ho on 2015/4/15.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import CoreData

class NewsCD:NSManagedObject{
    @NSManaged var subject:String!
    @NSManaged var url:String!
    @NSManaged var img:NSData!
}
