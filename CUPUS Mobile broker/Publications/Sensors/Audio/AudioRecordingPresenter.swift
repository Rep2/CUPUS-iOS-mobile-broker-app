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
    
    var log = [(NSDate, Float)]()
    var minValue:Float?
    var maxValue:Float?
    
    var currentValue:Float = 0.00
    var dateRead:NSDate = NSDate()
    
    func reciveAudioRecording(value: Float) {
        
        print(value)
        currentValue = value
        dateRead = NSDate()
        
        if value > maxValue{
            maxValue = value
        }
        
        if value < minValue || minValue == nil{
            minValue = value
        }
    }
    
}