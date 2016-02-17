//
//  PageContentViewController.swift
//  news
//
//  Created by ryan_ho on 2015/5/6.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import UIKit

class PageContentViewController: UIViewController{
    @IBOutlet weak var content:UILabel!
    @IBOutlet weak var contentImageView:UIImageView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var getStartedButton:UIButton!
    @IBOutlet weak var forwardButton:UIButton!
    
    var index : Int = 0
    var contentStr : String = ""
    var imageStr: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.text = contentStr
        contentImageView.image = UIImage(named: imageStr)
        pageControl.currentPage = index
        
        getStartedButton.hidden = (index == 2) ? false : true
        forwardButton.hidden = (index == 2) ? true: false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func close(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "hasViewedWalkthrough")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextScreen(sender: AnyObject) {
        let pageViewController = self.parentViewController as! PageViewController
        pageViewController.forward(index)
    }


}
