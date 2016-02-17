//
//  NewsApi.swift
//  news
//
//  Created by ryan_ho on 2015/3/24.
//  Copyright (c) 2015年 ryan_ho. All rights reserved.
//

import Foundation

class NewsApi {

//    var getListUrl = NSURL(string: "https://www.kimonolabs.com/api/b6w2fcwk?apikey=PPcS4q0C25MXV7e4PitGj51l6f5AuZdR")
    
    func getNewsList(url:String,completionHandler: ((JSON!, NSError!) -> Void)!) {
        var session = NSURLSession.sharedSession()
        var nsurl = NSURL(string: url)
        var request = NSMutableURLRequest(URL: nsurl!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {dataFromNetwork, response, error -> Void in
            if (error != nil) {
                return completionHandler(nil, error)
            }
            
            var error: NSError?
            let json = JSON(data:dataFromNetwork)
            
            if (error != nil) {
                return completionHandler(nil, error)
            } else {
                return completionHandler(json, nil)
            }
        })
        
        task.resume()
    }
    
    func getNewsList(url:String) -> JSON{
        let urlPath: String = url
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse? >= nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:error)!
        
        if error != nil{
            return nil
        }
        
        let json = JSON(data: dataVal)
        
        return json
    }
    
}