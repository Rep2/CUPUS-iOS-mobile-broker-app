//
//  AudioRecorderViewController.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 10/05/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import UIKit

class AudioRecorderViewController: UIViewController, AudioRecorderSubscriber{
    
    static var isRecording = false
    
    /// Displays if audio recording is available
    private var isAvailable = false{
        didSet{
            isAvailableChanged()
        }
    }
    
    var id:String?
    
    @IBOutlet private weak var isAvailableLabel: UILabel!
    private let isAvailableText = "Available: "
    
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    @IBOutlet private weak var isRecordingSwitch: UISwitch!
    
    @IBOutlet private weak var timeRecording: UILabel!
    private var recordingStartTime:NSDate?
    
    private let timeformater = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioLevelRecording.instance.checkIfAudioRecordingAvailable { (isAvailable) in
            self.isAvailable = isAvailable
        }
        
        timeformater.dateFormat = "dd.MM.yyyy HH:mm:ss"
        timeformater.timeZone = NSTimeZone(name: "Europe/Zagreb")
        
        let line = UIView(frame: CGRect(x: 18, y: 230, width: self.view.bounds.size.width - 36, height: 0.5))
        line.backgroundColor = UIColor.blackColor()
        
        view.addSubview(line)
        
        isAvailableChanged()
    }
    
    func isAvailableChanged(){
        if view != nil{
            isAvailableLabel.text = isAvailableText + "\(isAvailable)"
            
            isRecordingSwitch.enabled = isAvailable
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func switchChangedValue(sender: UISwitch) {
        if sender.on && id == nil{
            id = subscribe()
            
            if id == nil{
                sender.setOn(false, animated: true)
                presentAlert("Sound recording could not be started because sound recording is not available", controller: self)
            }else{
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(AudioRecorderViewController.reciveAudioRecording), userInfo: nil, repeats: true)
            }
        }else if !sender.on && id != nil{
            unsubscribe(id!)
            id = nil
            
            if let timer = timer{
                timer.invalidate()
            }
            timer = nil
        }
    }
    
    var timer: NSTimer?
    
    private static var log = [(NSDate, Float)]()
    private static var minVal:Float?
    private static var maxValue:Float?
    
    func reciveAudioRecording(value: Float) {
        let numOfSeconds = recordingStartTime != nil ? NSInteger(recordingStartTime!.timeIntervalSinceNow) : NSInteger(0)
        
        let seconds = numOfSeconds % 60
        let minutes = (numOfSeconds / 60) % 60
        let hours = (numOfSeconds / 3600)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.timeRecording.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        })
    }
}