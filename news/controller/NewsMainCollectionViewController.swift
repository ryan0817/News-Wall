//
//  NewsMainCollectionViewController.swift
//  news
//
//  Created by ryan_ho on 2015/5/11.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import KVNProgress

let reuseIdentifier = "collectionCell"

class NewsMainCollectionViewController: UICollectionViewController {
    
    var newsList = [News]()
    
    // favorite news list
    var favoriteList:[NewsCD]?
    
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var addAlert:UIAlertView?
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var basicConfiguration:KVNProgressConfiguration?
    
    var formatter = NSDateFormatter()
    
    // 加油！ 賺錢就靠你了!
//    @IBOutlet var bannerView:ADBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "News Wall"
        formatter.dateFormat  =  "yyyy-MM-dd HH:mm:ss.SSS"
        
        // 微調collection view的高度
        // 避免底部留白
        var viewSize = CGSize(width: self.collectionView!.frame.size.width, height: self.collectionView!.frame.size.height+20)
        self.collectionView!.frame.size = viewSize

        // 第一次使用APP的設定
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasSetupDefault")
        if hasViewedWalkthrough == false {
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            if managedObjectContext == nil{
                println("managedObjectContext is nil")
            }
            var orderCD = NSEntityDescription.insertNewObjectForEntityForName("Order", inManagedObjectContext: managedObjectContext!) as! OrderCD
            // 設定inside為初始網站
            orderCD.webSiteId = "f26e205f-c0ff-41bb-bd39-8f9235e4fb3f"
//            orderCD.webSiteId = "d453b032-c087-427e-93ec-d8ae16237e7c"
            
            // 初次將網站資料寫入Core Data中
            CoreDataUtil().setupFirstWebsite()
            
            // 下次不再設定初始網站
            defaults.setBool(true, forKey: "hasSetupDefault")
            
        }
        
        // 若Core Data沒有網站資料則上iCloud下載
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
            // 這裡寫需要放到子線程做的耗時的代碼
            
            // 從iColoud更新資料至device上的Core Data
            CloudUtil().getWebsiteFromiCloud()
            
            dispatch_async(dispatch_get_main_queue(), {
                // 這裡返回主線程，寫需要主線程執行的代碼
                
                //取得新聞資料
                self.getNewsList()
            })
        })
        
        
        // 瀏覽列
        self.setNavigationBarItem()
        
        // 下拉更新
        refreshControl.backgroundColor = UIColor.whiteColor()
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: "getNewsList", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView?.addSubview(refreshControl)
        self.collectionView?.alwaysBounceVertical = true
        
        // Configure the activity indicator and start animating
        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        self.parentViewController?.view.addSubview(spinner)
        spinner.startAnimating()
        
        // 初始化等待指示器
//        self.basicConfiguration = KVNProgressConfiguration.defaultConfiguration()
//        self.basicConfiguration!.backgroundType = KVNProgressBackgroundType.Solid
//        KVNProgress.showWithStatus("最新資料下載中")
        
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
//            Int64(3 * Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
//            KVNProgress.dismiss()
//            self.basicConfiguration!.backgroundType = KVNProgressBackgroundType.Blurred
//        }
        
        // 手勢向左滑打開menu bar
        var swipRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipRight")
        swipRight.direction = UISwipeGestureRecognizerDirection.Right
        self.collectionView?.addGestureRecognizer(swipRight)
        
        // 建立我的最愛暫存
        favoriteList = CoreDataUtil().getFavoriteList()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Configure the activity indicator and start animating
//        spinner.activityIndicatorViewStyle = .Gray
//        spinner.center = self.view.center
//        spinner.hidesWhenStopped = true
//        self.parentViewController?.view.addSubview(spinner)
//        spinner.startAnimating()
        
        //取得新聞資料
//        getNewsList()
        
    }
    
    func swipRight(){
        var menuController:SlideMenuController = self.collectionView?.window?.rootViewController as! SlideMenuController
        menuController.openLeft()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.hidesBarsOnSwipe = true
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return newsList.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((collectionView.bounds.size.width-20)/2, 300)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MainCollectionViewCell
    
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
            
            // 做一個default圖片
            if cell.img?.image == nil{
                cell.img?.image = UIImage(named: "logo-228")
            }
        }
        
        cell.img?.contentMode = .ScaleAspectFit
        cell.subject?.text = news.subject
        cell.webSiteName?.text = news.webSiteName
        
        // set up like button
        if favoriteList != nil{
            if CoreDataUtil().checkFavorite(news.url!, newsCDList: favoriteList!){
                cell.like!.setImage(UIImage(named: "likeF"), forState: nil)
            } else {
                cell.like!.setImage(UIImage(named: "like"), forState: nil)
            }
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let indexPathItems = self.collectionView?.indexPathsForSelectedItems(){
            let indexPathItem = indexPathItems[0] as! NSIndexPath
            let news = self.newsList[indexPathItem.item] as News
            
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let webViewController = storyboard.instantiateViewControllerWithIdentifier("WebController") as! NewsWebViewController
            webViewController.urlStr = news.url!
            
            if let navCon = self.navigationController {
                navCon.pushViewController(webViewController, animated: true)
            }
        }
    }
    
    // iAD
//    func bannerViewDidLoadAd(banner: ADBannerView!) {
//        self.bannerView?.hidden = false
//        banner.frame = CGRectMake(0,self.view.frame.size.height,banner.frame.size.width,banner.frame.size.height);
//    }
//    
//    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
//        return willLeave
//    }
//    
//    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
//        self.bannerView?.hidden = true
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
//    // 取得新聞資訊
//    func getNewsList(){
//        var nowDate = NSDate()
//        println("All start : " + formatter.stringFromDate (nowDate))
//        
//        // Start Core Data
//        var coreDateS = NSDate()
//        println("Core Data start : " + formatter.stringFromDate (coreDateS))
//
//        // 從Core Data取得訂閱網站的website ID
//        let orderList = CoreDataUtil().getOrderList()
//        if orderList.count == 0{
//            // 停止等待動畫
//            if self.spinner.isAnimating() {
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.spinner.stopAnimating()
//                })
//            }
//            
//            //Hide the refresh control
//            self.refreshControl.endRefreshing()
//            
//            self.addAlert = UIAlertView(title: "", message: "目前還沒有訂閱的網站,請您至訂閱功能訂閱喜歡的網站!", delegate: self, cancelButtonTitle: "OK")
//            self.addAlert!.show()
//            
//            return
//        }
//        
//        // End Core Data
//        var coreDateE = NSDate()
//        println("Core Data End : " + formatter.stringFromDate (coreDateE))
//        
//        // Strart - iCloud
//        
//        var ckReferences:[CKReference] = []
//        for orderStr in orderList {
//            var recordId = CKRecordID (recordName: orderStr)
//            // 建立雲端搜尋條件的可用物件
//            ckReferences.append(CKReference(recordID: recordId, action: CKReferenceAction.None))
//        }
//        
//        // 從iCloud上取得website資訊
//        // Initialize an empty website array
//        var websites:[CKRecord] = []
//        
//        // Get the Public iCloud Database
//        let cloudContainer = CKContainer.defaultContainer()
//        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
//        
//        // Prepare the query
//        let predicate = NSPredicate(format:"recordID IN %@",ckReferences)
//        let query = CKQuery(recordType: "WebSite", predicate: predicate)
//        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
//        
//        // Create the query operation with the query
//        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.desiredKeys = ["apiurl"]
//        queryOperation.queuePriority = .VeryHigh
//        //        queryOperation.resultsLimit = 50
//        
//        queryOperation.queryCompletionBlock = { (cursor:CKQueryCursor!, error:NSError!) -> Void in
//            //Hide the refresh control
//            self.refreshControl.endRefreshing()
//            
//            if (error != nil) {
//                println("Failed to get data from iCloud - \(error.localizedDescription)")
//                self.addAlert = UIAlertView(title: "", message: "請確認是否已登入iCloud", delegate: self, cancelButtonTitle: "OK")
//                self.addAlert!.show()
//                return
//                
//            } else {
//                println("Successfully retrieved the data from iCloud")
//                
////                dispatch_async(dispatch_get_main_queue(), {
////                    self.collectionView?.reloadData()
////                })
//            }
//            
//        }
//        
//        
//        // 清空News List(newsList)再重新執行取得新聞資料
//        self.newsList = []
//        queryOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
//            if let webSiteRecord = record {
//                var apiDateS = NSDate()
//                println("API start : " + self.formatter.stringFromDate (apiDateS))
//                
//                // 從Kimono取得新聞資訊
//                var api = NewsApi()
//                var websiteUrl = webSiteRecord.objectForKey("apiurl") as! String
//                
//                // Start API
//                api.getNewsList(websiteUrl,completionHandler: {json, error -> Void in
//                    if error != nil {
//                        dispatch_async(dispatch_get_main_queue(), {
//                            let alert = UIAlertView()
//                            alert.title = "Network issue"
//                            alert.message = "Please check your network.)"
//                            alert.addButtonWithTitle("ok")
//                            alert.delegate = self
//                            alert.show()
//                            println(error)
//                        })
//                    }
//                    if (json != nil) {
//                        var webSiteName = json["websiteName"]
//                        if (webSiteName == nil) {
//                            webSiteName = json["name"]
//                        }
//                        for (key:String, newsJson:JSON) in json["results"]["News"]{
//                            // 加入News List,依序顯示
//                            var imgUrl = newsJson["Img"]["src"].stringValue
//
//                            self.newsList.append(News(img: imgUrl, subject: newsJson["Subject"]["text"].string!, url: newsJson["Subject"]["href"].string!,webSiteName: webSiteName.string!))
//                        }
//                        
//                        // 停止等待動畫
//                        if self.spinner.isAnimating() {
//                            dispatch_async(dispatch_get_main_queue(), {
//                                self.spinner.stopAnimating()
//                            })
//                        }
//                        
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.collectionView?.reloadData()
//                        })
//                    }
//                })
//                var apiDateE = NSDate()
//                println("API End : " + self.formatter.stringFromDate (apiDateE))
//                // End API
//            }
//        }
//        
//        
//        
//        // Execute the query
//        publicDatabase.addOperation(queryOperation)
//        
//        // iCloud End
//        var nowDateE = NSDate()
//        println("All End : " + formatter.stringFromDate (nowDateE))
//        
//    }
    
    // 取得新聞資訊
    func getNewsList(){
        println("Get News List")
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
            self.refreshControl.endRefreshing()
            
            self.addAlert = UIAlertView(title: "", message: "目前還沒有訂閱的網站,請您至訂閱功能訂閱喜歡的網站!", delegate: self, cancelButtonTitle: "OK")
            self.addAlert!.show()
            
            return
        }
        
        // 取得網站資訊清單
        let websiteList:[WebsiteCD] = CoreDataUtil().getWebsiteList(orderList)
        
        // 清空News List(newsList)再重新執行取得新聞資料
        self.newsList = []
        
        for website : WebsiteCD in websiteList {
            
            // 從Kimono取得新聞資訊
            var api = NewsApi()
            var websiteUrl = website.apiurl
            api.getNewsList(websiteUrl, completionHandler: {json, error -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertView()
                        alert.title = "Network issue"
                        alert.message = "Please check your network.)"
                        alert.addButtonWithTitle("ok")
                        alert.delegate = self
                        alert.show()
                        println(error)
                    })
                }
                if (json != nil) {
                    var webSiteName = json["websiteName"]
                    if (webSiteName == nil) {
                        webSiteName = json["name"]
                    }
                    for (key:String, newsJson:JSON) in json["results"]["News"]{
                        // 加入News List,依序顯示
                        var imgUrl = newsJson["Img"]["src"].stringValue
                        
                        self.newsList.append(News(img: imgUrl, subject: newsJson["Subject"]["text"].string!, url: newsJson["Subject"]["href"].string!,webSiteName: webSiteName.string!))
                    }
                }
                
                // 停止等待動畫
                if self.spinner.isAnimating() {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.stopAnimating()
                    })
                }

                dispatch_async(dispatch_get_main_queue(), {
                    //Hide the refresh control
                    self.refreshControl.endRefreshing()
                    self.collectionView?.reloadData()
                })
            })

        }
    }
    
    @IBAction func clickFavorite(sender:AnyObject){
        
        let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.collectionView)
//        let cellIndexPath = self.collectionView.indexPathForRowAtPoint(pointInTable)
        let cellIndexPath = self.collectionView?.indexPathForItemAtPoint(pointInTable)
//        var cell = self.collectionView.cellForRowAtIndexPath(cellIndexPath!) as! NewsMainCell
        var cell = self.collectionView?.cellForItemAtIndexPath(cellIndexPath!) as! MainCollectionViewCell

        
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
                
                var newsCD = NSEntityDescription.insertNewObjectForEntityForName("News",inManagedObjectContext: managedObjectContext) as! NewsCD
                
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
        
        // 更新我的最愛暫存(favoriteList)
        favoriteList = CoreDataUtil().getFavoriteList()
        
        self.collectionView!.reloadData()
        
        var alertView:UIAlertView = UIAlertView(title: "", message: alertMsg, delegate: self, cancelButtonTitle: nil)
        self.addAlert = alertView
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: Selector("dismissAlert"), userInfo: nil, repeats: false)
        self.addAlert!.show()
        
    }
    
    func dismissAlert(){
        self.addAlert?.dismissWithClickedButtonIndex(0, animated: true)
        self.addAlert = nil
    }
    
//    func disableScrollsToTopPropertyOnAllSubviewsOf(view: UIView) {
//        for subview in view.subviews {
//            if let scrollView = subview as? UIScrollView {
//                (scrollView as UIScrollView).scrollsToTop = false
//            }
//            self.disableScrollsToTopPropertyOnAllSubviewsOf(subview as! UIView)
//        }
//    }

}
