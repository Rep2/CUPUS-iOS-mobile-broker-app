//
//  ViewController.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var mapView: GMSMapView!
    var centerLocation:CLLocation!
    
    var updateCount = 0;
    
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
        
        self.view = mapView
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

    func plusPressed(){
        
        presentAlertWithTwoButtons("Chose type of subscription", firstButtonTitle: "Follow", secondButtonTitle: "Pick", controller: self) { (firstButton) in
            
            if firstButton{
                let controller = GenericsWireframe.instance.getTableViewController()
                controller.title = "New subscriptions"
                
                let subscription = Subscription()
                
                var cells = [IRCellViewModel]()
                
                for title in SubscriptionOptions.sourceOptions{
                    cells.append(
                        IRCellViewModel(
                            implementationIdentifier: IRCellIdentifier.OneLabelRightImage,
                            data: [IRCellElementIdentifiers.FirstLabel:title,
                                IRCellElementIdentifiers.FirstImage:"Plus"]))
                    
                }
                
                for cell in cells{
                    cell.didSelectCellFunc = {
                       // subscription.optionPressed(title)
                        cell.setDataAndUpdateCell([IRCellElementIdentifiers.FirstImage: true])
                    }
                }
                
                controller.setSections([
                    IRCellViewModelSection(sectionTitle: nil, cellViewModels: cells)
                    ])
                
                Wireframe.instance.pushViewControllerToTab(controller, tab: 0)
            }
            
        }
        
    }
    
    func listPressed(){
        let controller = GenericsWireframe.instance.getTableViewController()
        controller.title = "Current subscriptions"
        
        var cells = [IRCellViewModel]()
        
        for title in SubscriptionManger.instance.subscriptions{
            cells.append(
                IRCellViewModel(
                    implementationIdentifier: IRCellIdentifier.OneLabelBasic,
                    data: [IRCellElementIdentifiers.FirstLabel:title],
                    didSelectCellFunc: {
                        
                }))
        }
        
        controller.setSections([
            IRCellViewModelSection(sectionTitle: nil, cellViewModels: cells)
            ])
        
        Wireframe.instance.pushViewControllerToTab(controller, tab: 0)
    }

}

