//
//  NewsOrderCell.swift
//  news
//
//  Created by ryan_ho on 2015/4/22.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import CoreData

class NewsOrderCell:UITableViewCell{
    
    @IBOutlet var img:UIImageView?
    @IBOutlet var label:UILabel?
    @IBOutlet var isOrder:UISwitch?
    
    var recordId:String?
    var delegate:NewsOrderCellDelegate?
    
//    var webSite:WebSite?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchOrder(state:UISwitch){
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        if managedObjectContext == nil{
            println("managedObjectContext is nil")
        }
        
        
        if state.on {
            // 新增訂閱網站
            var orderCD = NSEntityDescription.insertNewObjectForEntityForName("Order", inManagedObjectContext: managedObjectContext!) as! OrderCD
            orderCD.webSiteId = self.recordId
            
        } else {
            // 依website ID取得core date中的WebSiteCD 物件
            let fetchRequest = NSFetchRequest(entityName: "Order")
            let predicate = NSPredicate(format:"webSiteId == %@", recordId!)
            fetchRequest.predicate = predicate
            let fetchedResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [OrderCD]
            
            if fetchedResults.count != 0 {
                let order = fetchedResults[0]
                managedObjectContext?.deleteObject(order)
            }

        }
        
        var e: NSError?
        if managedObjectContext!.save(&e) != true {
            println("insert error: \(e!.localizedDescription)")
            return
        } else {
            // 更新NewsOrderTableViewController中的orderList
            // 如此當Cell在更新時可以檢查是否該網站有被訂閱
            // 以便switch能保持在最新狀態
            delegate?.update()
        }
    }
    
}

protocol NewsOrderCellDelegate{
    func update()
}
