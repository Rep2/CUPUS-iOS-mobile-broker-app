//
//  PublishViewController.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController{
    
    @IBOutlet weak var table: IRTableView!
    
    var locationAvailable = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        SensorsDetector.instance = SensorsDetector(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SensorsDetector.instance.checkSensorsInitialized()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !LocationManager.instance.isAvailable{
             presentAlert("Location is not available", message: "Enable location service in order to record the data", controller: self)
        }
    }
    
    func setTable(){
        if table != nil{
            var cells = [IRCellViewModel]()
            
            for sensor in SensorsDetector.instance.sensors{
                cells.append(IRCellViewModel(implementationIdentifier: IRCellIdentifier.OneLabelBasic,accessoryType: .DisclosureIndicator,
                    data: [IRCellElementIdentifiers.FirstLabel : sensor.0.rawValue],
                    didSelectCellFunc: {
                        [weak self] in
                        self?.cellSelected(sensor.0)
                    }))
            }
            
            table.setData([IRCellViewModelSection(sectionTitle: nil, cellViewModels: cells)])
        }
    }
    
    func cellSelected(sensor: Sensors){
        switch sensor {
        case .AudioRecorder:
            Wireframe.instance.pushViewControllerToTab(.AudioRecorder, tab: 1)
        case .DetectDevices:
            Wireframe.instance.pushViewControllerToTab(.DetectBluetooth, tab: 1)
        }
    }
}