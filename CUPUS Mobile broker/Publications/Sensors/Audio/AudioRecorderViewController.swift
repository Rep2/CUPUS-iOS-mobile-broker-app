//
//  AudioRecorderViewController.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 10/05/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import UIKit

class AudioRecorderViewController: UIViewController{
    
    @IBOutlet weak var isAvailableLabel: UILabel!
    let isAvailableText = "Available: "
    
    @IBOutlet weak var startstopButton: UIButton!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let timeformater = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeformater.dateFormat = "dd.MM.yyyy HH:mm:ss"
        timeformater.timeZone = NSTimeZone(name: "Europe/Zagreb")
        
        isAvailableLabel.text = isAvailableText + "\(AudioLevelRecording.instance.isAvailable ?? true)"
        
        let line = UIView(frame: CGRect(x: 18, y: 200, width: self.view.bounds.size.width - 36, height: 0.5))
        line.backgroundColor = UIColor.blackColor()
        
        view.addSubview(line)
        
        AudioRecorderPresenter.instance.observers["AudioRecorder"] = displayLastValues
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkButtonStatus()
    }
    
    func checkButtonStatus(){
        if AudioRecorderPresenter.instance.recordingAudio && (AudioLevelRecording.instance.isAvailable ?? false){
            startstopButton.setTitle("Stop", forState: .Normal)
            startstopButton.backgroundColor = UIColor(red: 192/255.0, green: 57/255.0, blue: 43/255.0, alpha: 1)
        }else{
            startstopButton.setTitle("Start", forState: .Normal)
            startstopButton.backgroundColor = UIColor(red: 39/255.0, green: 174/255.0, blue: 96/255.0, alpha: 1)
        }
    }
    
    @IBAction func startStopButtonPressed(sender: AnyObject) {
        
        AudioRecorderPresenter.instance.startStopRecording()
        
        checkButtonStatus()
    }
    
    func displayLastValues(){
        if let valueLabel = valueLabel{
            dispatch_async(dispatch_get_main_queue(), {
                valueLabel.text = "Value: \(AudioRecorderPresenter.instance.readings.last!.value)"
                self.timeLabel.text = "Time: \(self.timeformater.stringFromDate(AudioRecorderPresenter.instance.readings.last!.date))"
            })
        }
    }
    
    deinit{
        AudioRecorderPresenter.instance.observers["AudioRecorder"] = nil
    }
}