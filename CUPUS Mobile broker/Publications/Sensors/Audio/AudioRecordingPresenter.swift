//
//  AudioRecordingPresenter.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 17/05/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation

class AudioRecordingPresenter: AudioRecorderSubscriber{
    
    static let instance = AudioRecordingPresenter()
    
    
    
    var id:String?
    
    var recordingStartTime:NSDate?
    
    var minValue:Float?
    var maxValue:Float?
    
    var currentValue:Float = 0.00
    var dateRead:NSDate = NSDate()
    
    var log = [(NSDate, Float, Float)]()
    
    // Values used to convert read value to SPL
    private let referenceLevel:Float = 5
    private let range:Float = 180
    private let offset:Float = 20
    
    let dateConverter:NSDateFormatter = {
        let formater = NSDateFormatter()
        formater.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        return formater
    }()
    
    func reciveAudioRecording(value: Float) {
        
        let SPL = 20 * log10(referenceLevel * powf(10, (value/20)) * range) + offset
        
        currentValue = SPL
        dateRead = NSDate()
        
        if SPL > maxValue{
            maxValue = SPL
        }
        
        if SPL < minValue || minValue == nil{
            minValue = SPL
        }
        
        log.append((dateRead, value, SPL))
        
        do {
            let dir:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last! as NSURL
            let fileurl =  dir.URLByAppendingPathComponent("CUPUSAudioRecordingLog.txt")
       
            try "\(dateConverter.stringFromDate(dateRead)) value: \(value), converted value: \(SPL)".appendLineToURL(fileurl)
        }
        catch {
            print("Could not write to file")
        }
    }
    
}

extension String {
    func appendLineToURL(fileURL: NSURL) throws {
        try self.stringByAppendingString("\n").appendToURL(fileURL)
    }
    
    func appendToURL(fileURL: NSURL) throws {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        try data.appendToURL(fileURL)
    }
}

extension NSData {
    
    func appendToURL(fileURL: NSURL) throws {
        if let fileHandle = try? NSFileHandle(forWritingToURL: fileURL) {
            defer {
                fileHandle.closeFile()
            }
            
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(self)
        }
        else {
            try writeToURL(fileURL, options: .DataWritingAtomic)
        }
    }
}
