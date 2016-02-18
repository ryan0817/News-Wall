//
//  MainNewsTableViewController.swift
//  news
//
//  Created by ryan_ho on 2015/3/18.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CloudKit
import iAd

class NewsMainTableViewController: UITableViewController, ADBannerViewDelegate {
    
    let cellIdentifier = "NewsMainCell"
    var newsList = [News]()
    
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var addAlert:UIAlertView?
    
    @IBOutlet var bannerView:ADBannerView?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Launch walkthrough screens
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        
        if hasViewedWalkthrough == false {
            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
                
                self.presentViewController(pageViewController, animated: true, completion: nil)
            }
        }
        
        
        // 瀏覽列
        self.setNavigationBarItem()
        
        // 分隔線
        self.tableView.separatorColor = UIColor(red: 115.0/255.0, green: 162.0/255.0, blue: 177.0/255.0, alpha: 1)
        
        // Configure the activity indicator and start animating
        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        self.parentViewController?.view.addSubview(spinner)
        spinner.startAnimating()
        
        // 下拉更新
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "getNewsList", forControlEvents: UIControlEvents.ValueChanged)
        
        // iAd
        self.bannerView?.frame = CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)
        self.canDisplayBannerAds = true
        self.bannerView?.delegate = self
        self.bannerView?.hidden = true
        
        //取得新聞資料
        getNewsList()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = true

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let indexPath = self.tableView.indexPathForSelectedRow(){
            let news = self.newsList[indexPath.row] as News
            
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let webViewController = storyboard.instantiateViewControllerWithIdentifier("WebController") as! NewsWebViewController
            webViewController.urlStr = news.url!

            if let navCon = self.navigationController {
                navCon.pushViewController(webViewController, animated: true)
            }
        }
    }
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return newsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsMainCell
//        cell.news = self.newsList[indexPath.row]
        
        let news:News = self.newsList[indexPath.row]
        
        if let imgUrl = news.img{
            // Do any additional setup after loading the view, typically from a nib.
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                //                			println(self)
            }
            let url = NSURL(string: imgUrl)
            // 使用SDWebImage工具,異步抓取圖片
            // 避免要等圖片下載完才可以秀出cell,造成卡卡的現象
            cell.img?.sd_setImageWithURL(url, completed: block)
            
            // todo
            // 做一個default圖片
        }
        
        cell.img?.contentMode = .ScaleAspectFit
        cell.subject?.text = news.subject
        cell.webSiteName?.text = news.webSiteName
        
        // set up like button
        if CoreDataUtil().checkFavorite(news.url!){
            cell.like!.setImage(UIImage(named: "likeF"), forState: nil)
        } else {
            cell.like!.setImage(UIImage(named: "like"), forState: nil)
        }
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
//        var index = indexPath!.row
//        var data = self.dataArray[index] as NSDictionary
        return  450
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.bannerView?.hidden = false
        banner.frame = CGRectMake(0,self.view.frame.size.height,banner.frame.size.width,banner.frame.size.height);
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView?.hidden = true
    }
    
    // 取得新聞資訊
    func getNewsList(){
        // 從Core Data取得訂閱網站的website ID
        let orderList = CoreDataUtil().getOrderList()
        if orderList.count == 0{
            // 停止等待動畫
            if self.spinner.isAnimating() {
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.stopAnimating()
                })
            }
            //Hide the refresh control
            self.refreshControl?.endRefreshing()
            
            self.addAlert = UIAlertView(title: "", message: "目前還沒有訂閱的網站,請您至訂閱功能訂閱喜歡的網站", delegate: self, cancelButtonTitle: "OK")
            self.addAlert!.show()
            
            return
        }
        var ckReferences:[CKReference] = []
        for orderStr in orderList {
            var recordId = CKRecordID (recordName: orderStr)
            // 建立雲端搜尋條件的可用物件
            ckReferences.append(CKReference(recordID: recordId, action: CKReferenceAction.None))
        }
        
        // 從iCloud上取得website資訊
        
        // Initialize an empty website array
        var websites:[CKRecord] = []
        
        // Get the Public iCloud Database
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        // Prepare the query
        let predicate = NSPredicate(format:"recordID IN %@",ckReferences)
        let query = CKQuery(recordType: "WebSite", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        // Create the query operation with the query
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["apiurl"]
        queryOperation.queuePriority = .VeryHigh
//        queryOperation.resultsLimit = 50
        
        queryOperation.queryCompletionBlock = { (cursor:CKQueryCursor!, error:NSError!) -> Void in
            //Hide the refresh control
            self.refreshControl?.endRefreshing()
            
            if (error != nil) {
                println("Failed to get data from iCloud - \(error.localizedDescription)")
                self.addAlert = UIAlertView(title: "", message: "請確認是否已登入iCloud", delegate: self, cancelButtonTitle: "OK")
                self.addAlert!.show()
                return
                
            } else {
                println("Successfully retrieved the data from iCloud")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
            
        }
        
        self.newsList = []
        queryOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
            if let webSiteRecord = record {
                // 從Kimono取得新聞資訊
                var api = NewsApi()
                var websiteUrl = webSiteRecord.objectForKey("apiurl") as! String
            }
        }
        
        
        
        // Execute the query
        publicDatabase.addOperation(queryOperation)
        
        
    }
    
    @IBAction func clickFavorite(sender:AnyObject){

        let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRowAtPoint(pointInTable)
        var cell = self.tableView.cellForRowAtIndexPath(cellIndexPath!) as! NewsMainCell
//        cell.like!.setImage(UIImage(named: "likeF"), forState: nil)
        
        var news:News = self.newsList[cellIndexPath!.row]
        // 判斷是否曾經加入過我的最愛
        let isFavorite = CoreDataUtil().checkFavorite(news.url!)
        var alertMsg = ""
        if isFavorite {
            // 刪除掉我的最愛
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

            var fetchRequest = NSFetchRequest(entityName: "News")
            if news.url == nil{
                return
            }
            let predicate = NSPredicate(format:"url == %@", news.url!)
            fetchRequest.predicate = predicate
            let fetchedResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [NewsCD]
            
            if fetchedResults.count != 0 {
                let newsFet = fetchedResults[0]
                managedObjectContext?.deleteObject(newsFet)
                println("Delete \(news.url) success!")
            }
            
            var e: NSError?
            if managedObjectContext!.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
            alertMsg = "已從我的最愛中刪除"
        } else {
            // 新增我的最愛
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                
                var newsCD = NSEntityDescription.insertNewObjectForEntityForName("News",
                    inManagedObjectContext: managedObjectContext) as! NewsCD
                
                newsCD.subject = news.subject
                newsCD.url = news.url
                
                //取得圖片資料
                if let imgUrl = news.img{
                    // Do any additional setup after loading the view, typically from a nib.
                    let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                        
                    }
                    let url = NSURL(string: imgUrl)
                    var img = UIImageView()
                    img.sd_setImageWithURL(url, completed: block)
                    newsCD.img = UIImagePNGRepresentation(img.image)
                    println("Add Favorite")
                }
                
                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("insert error: \(e!.localizedDescription)")
                    return
                }
            }
            alertMsg = "已加入至我的最愛"
        }
        
        self.tableView.reloadData()
        
        var alertView:UIAlertView = UIAlertView(title: "", message: alertMsg, delegate: self, cancelButtonTitle: nil)
        self.addAlert = alertView
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: Selector("dismissAlert"), userInfo: nil, repeats: false)
        self.addAlert!.show()
        
    }
    
    func dismissAlert(){
        self.addAlert?.dismissWithClickedButtonIndex(0, animated: true)
        self.addAlert = nil
    }


}
