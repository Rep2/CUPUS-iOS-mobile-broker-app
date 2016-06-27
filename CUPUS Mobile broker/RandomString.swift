//
//  RandomString.swift
//  CUPUS Mobile broker
//
//  Created by Ivan Rep on 6/23/16.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation



func randomStringWithLength (len : Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 0..<len{
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    
    return randomString
}

enum LogFiles: String{
    case Subscriber = "Subscriber.txt"
    case Publisher = "Publisher.txt"
}

func writeToLog(fileName:String, content:String){
    
    do {
        let dir:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last! as NSURL
        let fileurl =  dir.URLByAppendingPathComponent(fileName)
        
        try content.appendLineToURL(fileurl)
    }
    catch {
        print("Could not write to " + fileName + " file")
    }
    
}