//
//  AudioRecordingPresenter.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 17/05/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation
import Wrap

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
    private let ps:Float = 20/1000000
    private let kal:Float = 5
    
    let dateConverter:NSDateFormatter = {
        let formater = NSDateFormatter()
        formater.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        return formater
    }()
    
    func reciveAudioRecording(value: Float) {
        
        let SPL = 20 * log10(pow(10, (value/20)) / ps) + kal
        
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
            
          /*  LocationManager.instance.getLocation({ (location, success) in
                
                if !success{
                    print("could not get last location")
                }else{
                    
                    if let location = location{
                        let message = CUPUSPublisher.createPublication(CUPUSValueType.CUPUSSensor, startTime: Int(NSDate.timeIntervalSinceReferenceDate()), coordinates: [location.coordinate.latitude, location.coordinate.longitude])
                        
                        do{
                            try PublicationsManager.instance.send(message)
                            
                            let str = NSString(data: try Wrap(message), encoding: NSUTF8StringEncoding)! as String
                            
                            writeToLog(LogFiles.Publisher.rawValue, content: "Sent publication " + str + " \(NSDate())")
                        }catch{
                            writeToLog(LogFiles.Publisher.rawValue, content: "FAILED: Sent publication \(NSDate())")
                        }
                    }else{
                        print("location not sent")
                    }
                }
                
                
            })*/
            
            
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
