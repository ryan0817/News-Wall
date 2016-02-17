//
//  NewsContractViewController.swift
//  news
//
//  Created by ryan_ho on 2015/4/27.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation
import CloudKit

class NewsContractViewController : UIViewController{
    
    @IBOutlet var email:UITextField?
    @IBOutlet var content:UITextView?
    
    @IBOutlet var sendBut:UIButton?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.sendBut!.layer.cornerRadius = 5
        self.sendBut!.clipsToBounds = true

    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBAction func send(){
        var record = CKRecord(recordType: "Feedback")
        record.setValue(email?.text, forKey: "email")
        record.setValue(content?.text, forKey: "content")
        
        // Get the Public iCloud Database
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        // Save the record to iCloud
        publicDatabase.saveRecord(record, completionHandler: { (record:CKRecord!, error:NSError!) -> Void  in
            if (error != nil) {
                println("Failed to save record to the cloud: \(error.description)")
            }
        })
        
        // Show thank message
        let alert = UIAlertController(title: nil, message: "謝謝您的建議,讓我們有進步的機會！", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        email?.resignFirstResponder()
        content?.resignFirstResponder()
    }
    
}
