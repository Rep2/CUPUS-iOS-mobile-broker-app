//
//  AudioRecorderViewController.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 10/05/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import UIKit

class AudioRecorderViewController: UIViewController{
    
    static var isRecording = false
    
    /// Displays if audio recording is available
    private var isAvailable = false{
        didSet{
            isAvailableChanged()
        }
    }
    
    @IBOutlet private weak var isAvailableLabel: UILabel!
    private let isAvailableText = "Available: "
    
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    @IBOutlet private weak var isRecordingSwitch: UISwitch!
    
    @IBOutlet private weak var timeRecording: UILabel!
    
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var minValuelabel: UILabel!
    
    
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
        
        AudioRecorderViewController.dateFormater.dateFormat = "HH:mm:ss dd.MM.yyyy"
    }
    
    func isAvailableChanged(){
        if view != nil{
            isAvailableLabel.text = isAvailableText + "\(isAvailable)"
            
            isRecordingSwitch.enabled = isAvailable
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if AudioRecordingPresenter.instance.id != nil{
            isRecordingSwitch.on = true
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(AudioRecorderViewController.updateDisplay), userInfo: nil, repeats: true)
        }
        
        updateDisplay()
    }
    
    @IBAction func switchChangedValue(sender: UISwitch) {
        if sender.on && AudioRecordingPresenter.instance.id == nil{
            AudioRecordingPresenter.instance.id = AudioRecordingPresenter.instance.subscribe()
            
            if AudioRecordingPresenter.instance.id == nil{
                sender.setOn(false, animated: true)
                presentAlert("Sound recording could not be started because sound recording is not available", controller: self)
            }else{
                AudioRecordingPresenter.instance.recordingStartTime = NSDate()
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(AudioRecorderViewController.updateDisplay), userInfo: nil, repeats: true)
            }
        }else if !sender.on && AudioRecordingPresenter.instance.id != nil{
            AudioRecordingPresenter.instance.unsubscribe(AudioRecordingPresenter.instance.id!)
            AudioRecordingPresenter.instance.id = nil
            AudioRecordingPresenter.instance.recordingStartTime = nil
            
            if let timer = timer{
                timer.invalidate()
            }
            
            timer = nil
            AudioRecorderViewController.oldTime += numOfSeconds
            numOfSeconds = 0
        }
    }
    
    var timer: NSTimer?
    
    private static var oldTime = 0
    private var numOfSeconds = 0
    
    
    
    private static var dateFormater = NSDateFormatter()
    
    func updateDisplay(){
        numOfSeconds = AudioRecordingPresenter.instance.recordingStartTime != nil ? NSInteger(NSDate().timeIntervalSinceDate(AudioRecordingPresenter.instance.recordingStartTime!)) : NSInteger(0)
        
        let seconds = (numOfSeconds + AudioRecorderViewController.oldTime) % 60
        let minutes = ((numOfSeconds + AudioRecorderViewController.oldTime) / 60) % 60
        let hours = ((numOfSeconds + AudioRecorderViewController.oldTime) / 3600)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.timeRecording.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            self.valueLabel.text = String(format: "%.2f", AudioRecordingPresenter.instance.currentValue)
            self.timeLabel.text = AudioRecorderViewController.dateFormater.stringFromDate(AudioRecordingPresenter.instance.dateRead)
            
            self.maxValueLabel.text = AudioRecordingPresenter.instance.maxValue != nil ? String(format: "Max value: %.2f", AudioRecordingPresenter.instance.maxValue!) : "Max value: -"
            self.minValuelabel.text = AudioRecordingPresenter.instance.minValue != nil ? String(format: "Min value: %.2f", AudioRecordingPresenter.instance.minValue!) : "Min value: -"
        })
    }
    
    deinit{
        if let timer = timer{
            timer.invalidate()
        }
    }
}