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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "Plus"), style: .Plain, target: self, action: #selector(MapViewController.plusPressed))]
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "List"), style: .Plain, target: self, action: #selector(MapViewController.listPressed))]
        
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
        view.addGestureRecognizer(gesture)
    }
    
    
    var longTouchInAction = false
    
    func longPressChanged(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began{
            longTouchInAction = true
            
            let point = gestureRecognizer.locationInView(self.view)
            let coordinate = mapView.projection.coordinateForPoint(point)
            startDrawingCircle(coordinate)
        }else if gestureRecognizer.state == UIGestureRecognizerState.Ended{
            longTouchInAction = false
        }else{
        }
    }
    
    
    var circle:GMSCircle!
    
    func startDrawingCircle(coordinate: CLLocationCoordinate2D){
      
        let width = pow(2, Double(self.mapView.camera.zoom))
        
        if circle == nil{
           circle = GMSCircle(position: coordinate, radius: CLLocationDistance(floatLiteral: 1500000/width))
        }else{
            circle.position = coordinate
            circle.radius = CLLocationDistance(floatLiteral: 1500000/width)
        }
        
        circle.fillColor =  UIColor(red: 73/255.0, green: 131/255.0, blue: 230/255.0, alpha: 0.3)
        circle.strokeWidth = 3;
        circle.strokeColor = UIColor(red: 73/255.0, green: 131/255.0, blue: 230/255.0, alpha: 0.8)
        circle.map = mapView
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            
            while(self.longTouchInAction){
                usleep(1000)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.circle.radius = self.circle.radius + (100000/width)
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
    
    var newSubsctiption:Subscription?

    func plusPressed(){
        
        presentAlertWithTwoButtons("Chose type of subscription", firstButtonTitle: "Follow", secondButtonTitle: "Pick", hasCancleButton: true, controller: self) { (firstButton) in
            
            if firstButton{
                let controller = GenericsWireframe.instance.getTableViewController()
                controller.title = "Select subscription values"
                
                controller.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "CheckmarkWhite"), style: .Plain, target: self, action: #selector(MapViewController.subscriptionValuesSelected))
            
                self.newSubsctiption = Subscription()
                
                var cells = [IRCellViewModel]()
                
                for title in SubscriptionOptions.sourceOptions{
                    cells.append(
                        IRCellViewModel(
                            implementationIdentifier: IRCellIdentifier.OneLabelRightImage,
                            data: [IRCellElementIdentifiers.FirstLabel:title,
                                IRCellElementIdentifiers.FirstImage:"Checkmark"]))
                    
                }
                
                for (index, cell) in cells.enumerate(){
                    cell.didSelectCellFunc = {
                        cell.setDataAndUpdateCell([IRCellElementIdentifiers.FirstImage: true])
                        self.newSubsctiption!.optionPressed(SubscriptionOptions.sourceOptions[index])
                    }
                }
                
                controller.setSections([
                    IRCellViewModelSection(sectionTitle: nil, cellViewModels: cells)
                    ])
                
                Wireframe.instance.pushViewControllerToTab(controller, tab: 0)
            }
            
        }
    }
    
    func subscriptionValuesSelected(){
        
        if(newSubsctiption?.subscriptionTypes.count == 0){
            presentAlert("Select at least one subscription value", controller: self)
        }else{
            Wireframe.instance.popViewController(0, animated: true)
            
            SubscriptionManger.instance.addSubscriptions(newSubsctiption!)
        }
    }
    
    func listPressed(){
        let controller = GenericsWireframe.instance.getTableViewController()
        controller.title = "Current subscriptions"
        
        var cells = [IRCellViewModel]()
        
        for subscription in SubscriptionManger.instance.subscriptions{
            
            cells.append(
                IRCellViewModel(
                    implementationIdentifier: IRCellIdentifier.OneLabelRightImage,
                    data: [IRCellElementIdentifiers.FirstLabel: subscription.subscriptionTypes.joinWithSeparator(", ")],
                    didSelectCellFunc: {
                        
                }))
            
        }
        
        controller.setSections([
            IRCellViewModelSection(sectionTitle: nil, cellViewModels: cells)
            ])
        
        Wireframe.instance.pushViewControllerToTab(controller, tab: 0)
    }

}

