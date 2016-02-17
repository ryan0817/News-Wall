//
//  NewsFavoriteTableViewController.swift
//  news
//
//  Created by ryan_ho on 2015/4/1.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import CoreData
import iAd

class NewsFavoriteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ADBannerViewDelegate  {
    
    var newsList:[NewsCD] = []
    
    var fetchResultController:NSFetchedResultsController!
    
    // 加油！ 賺錢就靠你了!
    @IBOutlet var bannerView:ADBannerView?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.navigationItem.title = "Favorite"
        
        // iAd
        self.bannerView?.frame = CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)
        self.canDisplayBannerAds = true
        self.bannerView?.delegate = self
        self.bannerView?.hidden = true
        
        // Retrieve content from persistent store
        self.newsList = CoreDataUtil().getFavoriteList()!
        
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
        return newsList.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell", forIndexPath: indexPath) as! NewsFavoriteCell
        

        cell.subject!.text = self.newsList[indexPath.row].subject
        if self.newsList[indexPath.row].img != nil{
            cell.imageFav!.image = UIImage(data: self.newsList[indexPath.row].img)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let indexPath = self.tableView.indexPathForSelectedRow(){
            let news = self.newsList[indexPath.row] as NewsCD
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let webViewController = storyboard.instantiateViewControllerWithIdentifier("WebController") as! NewsWebViewController
            webViewController.urlStr = news.url!
            if let navCon = self.navigationController {
                navCon.pushViewController(webViewController, animated: true)
            }
        }
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let news = newsList[indexPath.row] as NewsCD
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        if editingStyle == .Delete{
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
            newsList.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
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
}
