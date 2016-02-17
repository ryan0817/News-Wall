//
//  NewsWebViewController.swift
//  news
//
//  Created by ryan_ho on 2015/3/30.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import iAd

class NewsWebViewController:UIViewController, ADBannerViewDelegate{
    
    @IBOutlet var webView:UIWebView!
    
    // 加油！ 賺錢就靠你了!!
        @IBOutlet var bannerView:ADBannerView?
    
    var urlStr:String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        
    }
    
    func swipRight(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 手勢向左滑打開menu bar
        var swipRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipRight")
        swipRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view?.addGestureRecognizer(swipRight)
        
        if urlStr == nil{
            return
        }
        
        // 將URL中文轉為UTF-8
        let nsUrlStr = NSString(string: urlStr!)
        
        // Load web content
        if let url = NSURL(string: nsUrlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // iAD
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
    
//    @IBAction func doRefresh(AnyObject) {
//        webView.reload()
//    }
//    
//    @IBAction func goBack(AnyObject) {
//        webView.goBack()
//    }
//    
//    @IBAction func stop(AnyObject) {
//        webView.stopLoading()
//    }
    
}
