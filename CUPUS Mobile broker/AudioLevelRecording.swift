//
//  AudioLevelRecording.swift
//  CUPUSMobilBroker
//
//  Created by Rep on 1/21/16.
//  Copyright © 2016 IN2. All rights reserved.
//

import Foundation
import AVFoundation

class AudioLevelRecording: NSObject, AVAudioRecorderDelegate{
    
    /// AudioRecorder
    static let instance = AudioLevelRecording(readPeriod: 1)
    
    /// AudioRecording is available
    var isAvailable:Bool? = nil
    
    var isRecording = false
    
    
    private var recordingSession: AVAudioSession!
    private var recorder:AVAudioRecorder!
    
    private var readPeriod: Double
    private var observers:[String:((Float) -> Void)]!
    
    private var keepRecording = true
    
    private var timer:NSTimer!
    
    /// Initializes recorder and checks availability
    init(readPeriod: Double){
        self.readPeriod = readPeriod
        observers = [:]
        
        super.init()
        
        checkIfAvailable()
    }
    
    /// Detects if audio recording is available
    /// Notifies observer and stores the value in isAvailable
    func checkIfAvailable(observer: ((Bool) -> Void)? = nil){
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {
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
    
    func addObserver(title:String, observer:(Float) -> Void){
        observers[title] = observer
    }
    
    func removeObserver(title:String){
        observers[title] = nil
    }
    
    private let referenceLevel:Float = 5
    private let range:Float = 180
    private let offset:Float = 20
    
    func startRecording(){
        if !isRecording{
            pStartRecording()
        }
    }
    
    private func pStartRecording(){
        
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
            
            keepRecording = true
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                
                usleep(UInt32(100000))
                
                while self.keepRecording{
                    self.recorder.updateMeters()
                    
                    let value = self.recorder.averagePowerForChannel(0)
                    
                    let SPL = 20 * log10(self.referenceLevel * powf(10, (value/20)) * self.range) + self.offset;
                    
                    for (_, observer) in self.observers{
                        observer(SPL)
                    }
                    
                    usleep(UInt32(self.readPeriod * 1000000.0))
                }
            })
        }catch{
            isRecording = false
            print("Failed to start audio recorder")
        }
        
    }
    
    func stopRecording(){
        keepRecording = false
        isRecording = false
    }
    
}