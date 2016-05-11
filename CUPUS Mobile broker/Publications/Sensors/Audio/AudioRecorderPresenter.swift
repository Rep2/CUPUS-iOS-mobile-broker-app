//
//  AudioRecorderPresenter.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 10/05/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation
import CoreLocation

struct AudioReading{
    
    let value: Float
    let date: NSDate
    let location: CLLocationCoordinate2D
    
}

class AudioRecorderPresenter{
    
    static let instance = AudioRecorderPresenter()
    
    var readings = [AudioReading]()
    
    var recordingAudio = false
    
    var observers:[String: () -> Void]
    
    init(){
        observers = [:]
    }
    
    func startStopRecording(){
        if (recordingAudio == false){
            AudioLevelRecording.instance.addObserver("RecordingView", observer: audioResultIn)
            
            AudioLevelRecording.instance.startRecording()
        }else{
            AudioLevelRecording.instance.removeObserver("RecordingView")
        }
        
        recordingAudio = !recordingAudio
    }
    
    func audioResultIn(value: Float){
     //   readings.append(AudioReading(value: value, date: NSDate(), location: LocationManager.instance.lastLocation!.coordinate))
        
        for observer in observers{
            observer.1()
        }
    }
}