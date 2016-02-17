//
//  PageViewController.swift
//  news
//
//  Created by ryan_ho on 2015/5/6.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import UIKit

class PageViewController:UIPageViewController, UIPageViewControllerDataSource{
    
    var pageHeadings = ["訂閱喜歡的網站", "搜集最新的網站資訊", "專注在重要的資訊上！"]
    var pageImages = ["orderPage", "mainPage", "mountain-page"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the data source to itself
        dataSource = self
        
        // Create the first walkthrough screen
        if let startingViewController = self.viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        
        index++
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        
        if index == NSNotFound || index < 0 || index >= self.pageHeadings.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
            
            pageContentViewController.imageStr = pageImages[index]
            pageContentViewController.contentStr = pageHeadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    //    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    //        return pageHeadings.count
    //    }
    //
    //    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    //        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
    //
    //            return pageContentViewController.index
    //        }
    //
    //        return 0
    //    }
    
    func forward(index: Int) {
        
        if let nextViewController = self.viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
        }
    }
    
}
