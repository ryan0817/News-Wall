//
//  CoreDataUtil.swift
//  news
//
//  Created by ryan_ho on 2015/4/24.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class CoreDataUtil: NSFetchedResultsControllerDelegate{
    
    func getOrderList() -> [String]{
        
        var orderList = [String]()
        let fetchRequest = NSFetchRequest(entityName: "Order")
        let sortDescriptor = NSSortDescriptor(key: "webSiteId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            var fetchResultController:NSFetchedResultsController!
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            var orderCDList = fetchResultController.fetchedObjects as! [OrderCD]
            
            for orderCD in orderCDList{
                orderList.append(orderCD.webSiteId!)
            }
            
            if result != true {
                println(e?.localizedDescription)
            }
        }
        
        return orderList
    }
    
    func checkFavorite(url:String) ->Bool{
        var orderList = [String]()
        let fetchRequest = NSFetchRequest(entityName: "News")
        let sortDescriptor = NSSortDescriptor(key: "url", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            var fetchResultController:NSFetchedResultsController!
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            var newsCDList = fetchResultController.fetchedObjects as! [NewsCD]
            if newsCDList.count == 0{
                return false
            }
            
            for newsCD in newsCDList{
                if newsCD.url == url{
                    // 若找到則返回true
                    return true
                }
            }
            
            if result != true {
                println(e?.localizedDescription)
            }
        }
        
        return false
    }
    
    func checkFavorite(url:String, newsCDList:[NewsCD]) -> Bool{
        if newsCDList.count == 0{
            return false
        }
        
        for newsCD in newsCDList{
            if newsCD.url == nil{
                return false
            }
            if newsCD.url == url{
                return true
            }
        }
        return false
    }
    
    func getFavoriteList() -> [NewsCD]?{
        var newsCDList:[NewsCD]?
        var orderList = [String]()
        let fetchRequest = NSFetchRequest(entityName: "News")
        let sortDescriptor = NSSortDescriptor(key: "url", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            var fetchResultController:NSFetchedResultsController!
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
    
            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            newsCDList = fetchResultController.fetchedObjects as? [NewsCD]
    
        }
        return newsCDList
    }
    
    func updateWebsite(record : CKRecord) -> Void{
        if (record.isEqual(nil)) {
            return
        }
        
        let webSiteId : String = record.recordID.recordName
        let apiurl : String = record.objectForKey("apiurl") as! String
        let imgurl : String = record.objectForKey("imgurl") as! String
        let name : String = record.objectForKey("name") as! String
        
        // 搜尋Website in Core Data
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        if managedObjectContext == nil {
            return
        }
        
        let fetchRequest = NSFetchRequest()
        let predicate = NSPredicate(format:"webSiteId == %@", webSiteId)
        fetchRequest.predicate = predicate
        var entityName = NSEntityDescription.entityForName("Website", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entityName
        
        var error : NSError?
        var fetchedObjects = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)
        
        if let websiteList = fetchedObjects{
            if error != nil {
                println("Get Website error" + error!.description)
                return
            }
            
            // 若已有資料則更新,若沒有資料則新增
            if let website: WebsiteCD = websiteList.first as? WebsiteCD{
                // update website
                website.apiurl = apiurl
                website.imgurl = imgurl
                website.name = name
                
            } else {
                // save website
                // 新增訂閱網站
                var websiteCD = NSEntityDescription.insertNewObjectForEntityForName("Website", inManagedObjectContext: managedObjectContext!) as! WebsiteCD
                websiteCD.webSiteId = webSiteId
                websiteCD.apiurl = apiurl
                websiteCD.imgurl = imgurl
                websiteCD.name = name
            }
            
            var e: NSError?
            if managedObjectContext!.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
    }
    
    func getWebsiteList(recordIds:[String]) -> [WebsiteCD]{
        var retWebsiteList:[WebsiteCD] = []
        
        for recoredId in recordIds{
            // 搜尋Website in Core Data
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            if managedObjectContext == nil {
                return []
            }
            
            let fetchRequest = NSFetchRequest()
            let predicate = NSPredicate(format:"webSiteId == %@", recoredId)
            fetchRequest.predicate = predicate
            var entityName = NSEntityDescription.entityForName("Website", inManagedObjectContext: managedObjectContext!)
            fetchRequest.entity = entityName
            
            var error : NSError?
            var fetchedObjects = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)
            
            if let websiteList = fetchedObjects{
                if error != nil {
                    println("Get Website error" + error!.description)
                    return []
                }
                
                // 是否有找到website
                if let website: WebsiteCD = websiteList.first as? WebsiteCD{
                    retWebsiteList.append(website)
                }
            }
        }

        return retWebsiteList
    }
    
    func isWebsiteNew() -> Bool{
        var isNew = true
        
        // 搜尋Website in Core Data
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest()
        let predicate = NSPredicate(value: true)
        fetchRequest.predicate = predicate
        var entityName = NSEntityDescription.entityForName("Website", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entityName
        
        var error : NSError?
        var fetchedObjects = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)
        
        if let websiteList = fetchedObjects{
            if error != nil {
                println("Get Website error" + error!.description)
            }

            if let website: WebsiteCD = websiteList.first as? WebsiteCD{
                // Core Data 中有網站資料, 不需要再從iCloud上拿
                isNew = false
            }
        }
        
        return isNew
    }
    
    func setupFirstWebsite(){
        var websiteList:[[String]] = []
        
        var website1:[String] = []
        website1.append("2107b7e4-404b-4f8e-8e49-7658ab67f5d1")
        website1.append("https://www.kimonolabs.com/api/4sxeut0w?apikey=PPcS4q0C25MXV7e4PitGj51l6f5AuZdR&kimmodify=1")
        website1.append("http://i.imgur.com/9NGxRn3.png")
        website1.append("運動筆記")
        websiteList.append(website1)
        
        var website2:[String] = []
        website2.append("5b5bbcfb-8fad-476f-9c50-8eb36963eae1")
        website2.append("https://www.kimonolabs.com/api/684i89xy?apikey=PPcS4q0C25MXV7e4PitGj51l6f5AuZdR&kimmodify=1")
        website2.append("http://ibw.bwnet.com.tw/bw/images/LOGOslogan_160.jpg")
        website2.append("商業週刊")
        websiteList.append(website2)
        
        var website3:[String] = []
        website3.append("f26e205f-c0ff-41bb-bd39-8f9235e4fb3f")
        website3.append("https://www.kimonolabs.com/api/6nw19uq8?apikey=PPcS4q0C25MXV7e4PitGj51l6f5AuZdR&kimmodify=1")
        website3.append("http://cdn.inside.com.tw/wp-content/uploads/2013/06/logo-2013.png")
        website3.append("Inside")
        websiteList.append(website3)
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            
            for website in websiteList {
                var websiteCD = NSEntityDescription.insertNewObjectForEntityForName("Website",inManagedObjectContext: managedObjectContext) as! WebsiteCD
                
                websiteCD.webSiteId = website[0]
                websiteCD.apiurl = website[1]
                websiteCD.imgurl = website[2]
                websiteCD.name = website[3]
                
                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("insert error: \(e!.localizedDescription)")
                    return
                }
            }
            
        }
    }
}
