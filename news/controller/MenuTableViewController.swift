//
//  MenuTableViewController.swift
//  news
//
//  Created by ryan_ho on 2015/4/13.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import UIKit


class MenuTableViewController : UITableViewController  {
    
    let backGroundColor:UIColor = UIColor(red: 115.0/255.0, green: 162.0/255.0, blue: 177.0/255.0, alpha: 1)
    
    enum Menu: Int {
        case Main = 0
        case Favorite = 1
        case Order = 2
        case About = 3
    }
    
//    @IBOutlet weak var tableView: UITableView!
    var menus = ["新聞", "我的最愛","訂閱","關於我們"]
    var imgStr = ["home","favorite","order","about"]
    var mainViewController: UIViewController!
    var favoriteViewController: UIViewController!
    var orderViewController:UIViewController!
    var aboutViewController:UIViewController!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.backgroundColor = backGroundColor
        
        // 若不將menu的scrollsToTop關掉
        // 會影響collection view, table view點選status bar無法拉到最上面
        // 因為兩個以上的scroll view就會失效, 而collection view, table view包含scroll view
        self.tableView.scrollsToTop = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        
        cell.backgroundColor = backGroundColor
        cell.label?.text = menus[indexPath.row]
        cell.img?.image = UIImage(named: imgStr[indexPath.row])
        
        return cell
    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        println("test")
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
////        cell.backgroundColor = UIColor(red: 64/255, green: 170/255, blue: 239/255, alpha: 1.0)
//        cell.textLabel!.font = UIFont.italicSystemFontOfSize(18)
////        cell.textLabel!.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        cell.textLabel!.text = menus[indexPath.row]
//        return cell
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let favoriteTableViewController = storyboard.instantiateViewControllerWithIdentifier("FavoriteController") as! NewsFavoriteTableViewController
        self.favoriteViewController = UINavigationController(rootViewController: favoriteTableViewController)
        
        let oredrTableViewController = storyboard.instantiateViewControllerWithIdentifier("OrderController") as! NewsOrderTableViewController
        self.orderViewController = UINavigationController(rootViewController: oredrTableViewController)
        
        let aboutViewController = storyboard.instantiateViewControllerWithIdentifier("AboutController") as! NewsAboutViewController
        self.aboutViewController = UINavigationController(rootViewController: aboutViewController)
        
        if let menu = Menu(rawValue: indexPath.item) {
            switch menu {
            case .Main:
                self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
            case .Favorite:
                self.slideMenuController()?.changeMainViewController(self.favoriteViewController, close: true)
            case .Order:
                self.slideMenuController()?.changeMainViewController(self.orderViewController, close: true)
            case .About:
                self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
            default:
                break
            }
        }
    }
    
}

