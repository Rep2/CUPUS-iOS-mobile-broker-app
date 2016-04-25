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
    case  Map = "Map"
}

/// Base wireframe. For customization split into multiple
class Wireframe{
    
    static var instance: Wireframe!
    
    var baseController: UITabBarController!
    
    var tabBarNavigationControllers: [UINavigationController]!
    
    init(){
        Wireframe.instance = self
        
        tabBarNavigationControllers = tabBarViewsToViewControllers(tabBarViewData)
        
        baseController = BaseTabBarController(viewControllers: tabBarNavigationControllers)
    }
    
    func getViewController(name: RegisteredViewControllers) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(name.rawValue)
    }
    
}

private let tabBarViewData = [
    TabBarViewData(name: .Map, title: "Publications", iconTitle: "Publish"),
    TabBarViewData(name: .Map, title: "Subscriptions", iconTitle: "Subscribe"),
    TabBarViewData(name: .Map, title: "Settings", iconTitle: "Settings"),
]