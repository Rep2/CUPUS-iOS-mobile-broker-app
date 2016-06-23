//
//  ViewController.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, UIGestureRecognizerDelegate{
    
    var mapView: GMSMapView!
    var centerLocation:CLLocation!
    
    var updateCount = 0;
    
    var gesture:UILongPressGestureRecognizer!
    
    
    var plusButton:UIBarButtonItem!
    var listButton:UIBarButtonItem!
    
    var cancleButton:UIBarButtonItem!
    var approveButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusButton = UIBarButtonItem(image: UIImage(named: "Plus"), style: .Plain, target: self, action: #selector(MapViewController.plusPressed))
        listButton = UIBarButtonItem(image: UIImage(named: "List"), style: .Plain, target: self, action: #selector(MapViewController.listPressed))
        cancleButton = UIBarButtonItem(image: UIImage(named: "Cancle"), style: .Plain, target: self, action: #selector(MapViewController.cancleSelect))
        approveButton = UIBarButtonItem(image: UIImage(named: "CheckmarkWhite"), style: .Plain, target: self, action: #selector(MapViewController.approveSelect))
        
        presentStandardButtons()
        
        centerLocation = CLLocation(latitude: 45.1, longitude: 19.2)
        
        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: centerLocation.coordinate.latitude, longitude: centerLocation.coordinate.longitude), zoom: 8, bearing: CLLocationDirection(), viewingAngle: 0)
        
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        
        mapView.settings.consumesGesturesInView = false
        
        self.view = mapView
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        gesture = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPressChanged))
        gesture.delegate = self
        gesture.delaysTouchesBegan = true
        gesture.enabled = false
        view.addGestureRecognizer(gesture)
        
        
        // Connects to server
        do{
            try SubscriptionManager.instance.connect(CUPUSMobileBrokerContext.instance.serverIP, serverPort: CUPUSMobileBrokerContext.instance.serverPort)
        }catch{
            presentAlert("Subscriber could not connect to the server", message: "Check server IP and port in the settings and try again", controller: self)
        }
        
    }
    
    func cancleSelect(){
        if circle != nil{
            circle.map = nil
            circle = nil
            
            presentStandardButtons()
            gesture.enabled = false
        }
    }
    
    var circleData:CircleData?
    
    func approveSelect(){
        if circle != nil{
            presentSubscritionValueTable(.Pick(center: circle.position, radius: circle.radius))
            
            circleData = CircleData(center: circle.position, radius: circle.radius)
            
            delay(0.2, closure: {
                self.circle.map = nil
                self.circle = nil
                
                self.presentStandardButtons()
                self.gesture.enabled = false
            })
        }else{
            presentAlert("Long press on the map to select the subscription area", controller: self)
        }
    }
    
    func presentStandardButtons(){
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.leftBarButtonItem = listButton
    }
    
    func presentApproveCancleButtons(){
        navigationItem.leftBarButtonItem = cancleButton
        navigationItem.rightBarButtonItem = approveButton
    }
    
    var longTouchInAction = false
    var circle:GMSCircle!
    
    func longPressChanged(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began{
            longTouchInAction = true
            
            let point = gestureRecognizer.locationInView(self.view)
            let coordinate = mapView.projection.coordinateForPoint(point)
            startDrawingCircle(coordinate)
        }else if gestureRecognizer.state == UIGestureRecognizerState.Ended{
            longTouchInAction = false
        }
    }
    
    func startDrawingCircle(coordinate: CLLocationCoordinate2D){
      
        let width = pow(2, Double(self.mapView.camera.zoom))
        
        if circle == nil{
            circle = GMSCircle(position: coordinate, radius: CLLocationDistance(floatLiteral: 1500000/width))
            circle.fillColor =  UIColor(red: 73/255.0, green: 131/255.0, blue: 230/255.0, alpha: 0.3)
            circle.strokeWidth = 3;
            circle.strokeColor = UIColor(red: 73/255.0, green: 131/255.0, blue: 230/255.0, alpha: 0.8)
            circle.map = mapView
        }else{
            circle.position = coordinate
            circle.radius = CLLocationDistance(floatLiteral: 1500000/width)
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            
            while(self.longTouchInAction){
                usleep(1000)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.circle.radius = self.circle.radius + (70000/width)
                })
            }
            
        })
      
    }

    
    func updatePosition(location: CLLocation){
        updateCount += 1
        
        if updateCount < 4{
            mapView.animateToLocation(location.coordinate)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var newSubsctiption:SubscriptionModel?

    func plusPressed(){
        
        presentAlertWithTwoButtons("Chose type of subscription", firstButtonTitle: "Follow", secondButtonTitle: "Pick", hasCancleButton: true, controller: self) { (firstButton) in
            
            if firstButton{
                self.presentSubscritionValueTable(.Follow)
            }else{
                self.gesture.enabled = true
                
                self.presentApproveCancleButtons()
            }
            
        }
    }
    
    func presentSubscritionValueTable(type: SubscriptionType){
        let controller = GenericsWireframe.instance.getTableViewController()
        controller.title = "Subscription values"
        
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "CheckmarkWhite"), style: .Plain, target: self, action: #selector(MapViewController.subscriptionValuesSelected))
        
        self.newSubsctiption = SubscriptionModel(type: type)
        
        var cells = [IRCellViewModel]()
        
        for title in SensorSubscriptionOptions.allValues{
            cells.append(
                IRCellViewModel(
                    implementationIdentifier: IRCellIdentifier.OneLabelRightImage,
                    data: [IRCellElementIdentifiers.FirstLabel:title,
                        IRCellElementIdentifiers.FirstImage:"Checkmark"]))
            
        }
        
        for (index, cell) in cells.enumerate(){
            cell.didSelectCellFunc = {
                cell.setDataAndUpdateCell([IRCellElementIdentifiers.FirstImage: true])
                self.newSubsctiption!.optionPressed(SensorSubscriptionOptions.allValues[index])
            }
        }
        
        controller.setSections([
            IRCellViewModelSection(sectionTitle: nil, cellViewModels: cells)
            ])
        
        Wireframe.instance.pushViewControllerToTab(controller, tab: 0)
    }
    
    func subscriptionValuesSelected(){
        if(newSubsctiption?.subscriptionTypes.count == 0){
            presentAlert("Select at least one subscription value", controller: self)
        }else{
            Wireframe.instance.popViewController(0, animated: true)
            
            SubscriptionManager.instance.addSubscriptions(newSubsctiption!)
        }
    }
    
    func listPressed(){
        let controller = GenericsWireframe.instance.getTableViewController()
        controller.title = "Current subscriptions"
        
        var cells = [IRCellViewModel]()
        
        for subscription in SubscriptionManager.instance.subscriptions{
            
            cells.append(
                IRCellViewModel(
                    implementationIdentifier: IRCellIdentifier.OneLabelRightImage,
                    data: [IRCellElementIdentifiers.FirstLabel: ((subscription.type == .Follow ? "Follow " : "Pick ") + " - ") + subscription.subscriptionTypes.map({ $0.rawValue }).joinWithSeparator(", ")],
                    didSelectCellFunc: {
                        
                }))
            
        }
        
        controller.setSections([
            IRCellViewModelSection(sectionTitle: nil, cellViewModels: cells)
            ])
        
        Wireframe.instance.pushViewControllerToTab(controller, tab: 0)
    }

}

