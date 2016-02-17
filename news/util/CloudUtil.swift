//
//  CloudUtil.swift
//  news
//
//  Created by ryan_ho on 2015/7/3.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import CloudKit

class CloudUtil {
    
    // 從iCloud上取得website資訊
    func getWebsiteFromiCloud() {
        
        // Initialize an empty website array
        var websites:[CKRecord] = []
        
        // Get the Public iCloud Database
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        // Prepare the query
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "WebSite", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        // Create the query operation with the query
        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.desiredKeys = ["apiurl"]
        queryOperation.queuePriority = .VeryHigh
        queryOperation.queryCompletionBlock = { (cursor:CKQueryCursor!, error:NSError!) -> Void in
            
            if (error != nil) {
                println("Failed to get data from iCloud - \(error.localizedDescription)")
            } else {
                println("Successfully retrieved the data from iCloud. (getWebsiteFromiCloud)")
                
            }
        }
        
        // 取得資料後的處理過程
        queryOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
            if let webSiteRecord = record {
                websites.append(record)
                // 更新Core Data網站資料
                CoreDataUtil().updateWebsite(record)

            }
        }

        // Execute the query
        publicDatabase.addOperation(queryOperation)

    }
}