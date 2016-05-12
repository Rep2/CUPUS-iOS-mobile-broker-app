//
//  AudioLevelRecording.swift
//  CUPUSMobilBroker
//
//  Created by Rep on 1/21/16.
//  Copyright © 2016 IN2. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioRecorderSubscriber{
    var id:String? {get set}
    
    func reciveAudioRecording(value: Float)
}

extension AudioRecorderSubscriber{
    
    func subscribe() -> String?{
        return AudioLevelRecording.instance.subscribe(self)
    }
    
    func unsubscribe(id: String){
        AudioLevelRecording.instance.unsubscribe(id)
    }
    
}

class AudioLevelRecording: NSObject, AVAudioRecorderDelegate{
    
    /// AudioRecorder
    static let instance = AudioLevelRecording(readPeriod: 1)
    
    /// Is audio recorder available
    var isAvailable = false
    
    /// Is audio recorder recording
    var isRecording = false
    
    
    private var readPeriod: Double
    
    /// Initializes recorder and checks availability
    init(readPeriod: Double){
        self.readPeriod = readPeriod
        
        super.init()
        
        checkIfAudioRecordingAvailable()
    }
    
    /**
     Checks if audio recording is available
     - parameter observer:((Bool) -> Void)? callback function returing if audio recording is available
     */
    func checkIfAudioRecordingAvailable(observer: ((Bool) -> Void)? = nil){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            
            AVAudioSession.sharedInstance().requestRecordPermission() {
                (allowed: Bool) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    if let observer = observer{
                        observer(allowed)
                        self.isAvailable = allowed
                    }
                }
                
            }
        } catch {
            if let observer = observer{
                observer(false)
                isAvailable = false
            }
        }
    }
    
    
    // Values used to convert read value to SPL
    private let referenceLevel:Float = 5
    private let range:Float = 180
    private let offset:Float = 20

    private var recorder:AVAudioRecorder!
    
    /**
     Starts audio recording and dispatches each recorded value to subscribers
     */
    private func startRecording(){
        
        let audioFilename = NSTemporaryDirectory() + "tmp.caf"
        
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleIMA4) as NSNumber,
            AVSampleRateKey: 44100 as NSNumber,
            AVNumberOfChannelsKey: 2 as NSNumber,
            AVLinearPCMBitDepthKey: 16 as NSNumber,
            AVLinearPCMIsBigEndianKey: NSNumber(bool: false),
            AVLinearPCMIsFloatKey: NSNumber(bool: false)
        ]
        
        isRecording = true
        
        do {
            recorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            recorder.delegate = self
            
            recorder.prepareToRecord()
            recorder.meteringEnabled = true
            recorder.record()
            
            isRecording = true
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                
                usleep(UInt32(100000))
                
                while self.isRecording{
                    self.recorder.updateMeters()
                    
                    let value = self.recorder.averagePowerForChannel(0)
                    
                    let SPL = 20 * log10(self.referenceLevel * powf(10, (value/20)) * self.range) + self.offset;
                    
                    self.sendRecordingToSubscribers(SPL)
                    
                    usleep(UInt32(self.readPeriod * 1000000.0))
                }
            })
        }catch{
            print("Failed to start audio recorder")
            stopRecording()
        }
    }
    
    /**
     Stops recording
     */
    func stopRecording(){
        isRecording = false
    }
    
    // Registered observers to which recorded value is sent
    private var observers = Dictionary<String, protocol<AudioRecorderSubscriber>>()
    
    /**
     Adds observer to recorder
     - parameter observer:protocol<AudioRecorderSubscriber>
     - return:String unique value with which to unsubscribe
    */
    func subscribe(observer: protocol<AudioRecorderSubscriber>) -> String?{
        if !isAvailable{
            return nil
        }
        
        let id = NSUUID().UUIDString
        observers[id] = observer
        
        if !isRecording{
            startRecording()
        }
        
        return id
    }
    
    /**
     Adds observer to recorder
     - parameter id:String unique value recieved from subscribe method
     */
    func unsubscribe(id: String){
        observers[id] = nil
        
        if observers.count == 0 && isRecording{
            stopRecording()
        }
    }
    
    
    
    /**
     Sends read recording to all observers
     - parameter value:Float recorded audio value
     */
    private func sendRecordingToSubscribers(value: Float){
        for (_, observer) in observers{
            observer.reciveAudioRecording(value)
        }
    }
    
}