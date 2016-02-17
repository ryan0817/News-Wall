//
//  NewsOrderTableController.swift
//  news
//
//  Created by ryan_ho on 2015/4/14.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

class NewsOrderTableViewController: UITableViewController, NewsOrderCellDelegate {
    
    var websites:[CKRecord] = []
    var orderList:[String] = []
    
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.getRecordsFromCloud()
        orderList = CoreDataUtil().getOrderList()
        self.navigationItem.title = "Order"
        
        // Configure the activity indicator and start animating
        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        self.parentViewController?.view.addSubview(spinner)
        spinner.startAnimating()
        
        // 手勢向左滑打開menu bar
        var swipRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipRight")
        swipRight.direction = UISwipeGestureRecognizerDirection.Right
        self.tableView?.addGestureRecognizer(swipRight)
        
    }
    
    func swipRight(){
        var menuController:SlideMenuController = self.tableView?.window?.rootViewController as! SlideMenuController
        menuController.openLeft()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return websites.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! NewsOrderCell
        cell.delegate = self
        
        let webSiteCk = self.websites[indexPath.row]
        let recordId = webSiteCk.recordID.recordName
        let webSiteName = webSiteCk.objectForKey("name") as! String
        let webSiteImgUrl = webSiteCk.objectForKey("imgurl") as? String
        if let imgUrl = webSiteImgUrl{
            // Do any additional setup after loading the view, typically from a nib.
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                //                			println(self)
            }
            let url = NSURL(string: imgUrl)
            // 使用SDWebImage工具,異步抓取圖片
            // 避免要等圖片下載完才可以秀出cell,造成卡卡的現象
            cell.img?.sd_setImageWithURL(url, completed: block)
        }
        
        // 確認是否訂閱此網站新聞
        if contains(orderList, recordId){
            cell.isOrder!.on = true
        } else {
            cell.isOrder!.on = false
        }
        cell.recordId = recordId
        cell.img?.contentMode = .ScaleAspectFit
        cell.label?.text = webSiteName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {

        return  70
    }
    
    // MARK: - Data Methods for iCloud
    func getRecordsFromCloud() {
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "WebSite", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {
            results, error in
            if error == nil {
                println("Completed the download of WebSite data")
                self.websites = results as! [CKRecord]
//                println(self.websites[0].recordID.recordName)
                
                // 停止等待動畫
                if self.spinner.isAnimating() {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.stopAnimating()
                    })
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            } else {
                println("Failed to retrieve data: \(error.description)")
                
            }
        })
        
    }
    
    // 當訂閱動作被執行時,會在NewsOrderCell中呼叫Protocol方法
    // 但真正在以下被實作,類似於java的abstract class
    func update(){
        orderList = CoreDataUtil().getOrderList()
    }
}
