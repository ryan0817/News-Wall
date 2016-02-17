//
//  NSStringExt.swift
//  news
//
//  Created by ryan_ho on 2015/3/19.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat
        
    {
        var font = UIFont.systemFontOfSize(fontSize)
        var size = CGSizeMake(width,CGFloat.max)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        var  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        var text = self as NSString
        var rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
    func dateStringFromTimestamp(timeStamp:NSString)->String
    {
        var ts = timeStamp.doubleValue
        var  formatter = NSDateFormatter ()
        formatter.dateFormat = "yyyy年MM月dd日 HH:MM:ss"
        var date = NSDate(timeIntervalSince1970 : ts)
        return  formatter.stringFromDate(date)
        
    }
    
    
    func replace(target: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
}
