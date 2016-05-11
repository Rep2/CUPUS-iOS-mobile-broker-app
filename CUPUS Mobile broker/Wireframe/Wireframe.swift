//
//  Wireframe.swift
//  CUPUSMobilBroker
//
//  Created by IN2 MacbookPro on 20/01/16.
//  Copyright © 2016 IN2. All rights reserved.
//

import UIKit

/// Registerd view controllers of Main storyboard
enum RegisteredViewControllers: String{
    case Map = "Map"
    
    case Publications = "Publications"
    case AudioRecorder = "AudioRecorderView"
    
    case Settings = "Settings"

}

/// Base wireframe. For customization split into multiple
class Wireframe{
    
    static var instance: Wireframe!
    
    var baseController: UITabBarController!
    
    var tabBarNavigationControllers: [UINavigationController]!
    
    var locationManager: LocationManager!
    
    var topController:[UIViewController] = []
    
    init(){
        Wireframe.instance = self
        
        tabBarNavigationControllers = tabBarViewsToViewControllers(tabBarViewData)
        
        baseController = BaseTabBarController(viewControllers: tabBarNavigationControllers)
        
        locationManager = LocationManager()
    }
    
    func getViewController(name: RegisteredViewControllers) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(name.rawValue)
    }
    
    func pushViewControllerToTab(controller: UIViewController, tab: Int, animated: Bool = true){
        tabBarNavigationControllers[tab].pushViewController(controller, animated: animated)
        topController.append(controller)
    }
    
    func pushViewControllerToTab(name: RegisteredViewControllers, tab: Int, animated: Bool = true){
        let controller = getViewController(name)
        tabBarNavigationControllers[tab].pushViewController(controller, animated: animated)
        topController.append(controller)
    }
    
    func popViewController(tab: Int, animated: Bool = true){
        tabBarNavigationControllers[tab].popViewControllerAnimated(animated)
        topController.removeLast()
    }
    
}

private let tabBarViewData = [
    TabBarViewData(name: .Map, title: "Subscriptions", iconTitle: "Subscribe"),
    TabBarViewData(name: .Publications, title: "Publications", iconTitle: "Publish"),
    TabBarViewData(name: .Map, title: "Settings", iconTitle: "Settings")]

public let googleMapsAPIKey = "AIzaSyC-zJ051bJkPMRs7YYIS5-CTf63PESAoqE"
