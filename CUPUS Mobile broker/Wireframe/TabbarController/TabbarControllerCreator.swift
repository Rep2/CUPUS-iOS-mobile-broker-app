//
//  TabbarControllerCreator.swift
//  CUPUSMobilBroker
//
//  Created by Rep on 1/21/16.
//  Copyright © 2016 IN2. All rights reserved.
//

import UIKit

struct TabBarViewData{
    let name: RegisteredViewControllers
    let title: String
    let iconTitle: String
}

// Transforms view data to UIViewController
func tabBarViewsToViewControllers(views: [TabBarViewData]) -> [UINavigationController]{
    
    var viewControllers = [UINavigationController]()
    
    for view in views{
        viewControllers.append(
            createNavigationControllerForBaseTabBarView(view))
    }
    
    return viewControllers
}

// Creates navigation controller, adds view created from item to it and costumizes view
private func createNavigationControllerForBaseTabBarView(tabbarViewItem: TabBarViewData) -> UINavigationController{
    var navigationController: UINavigationController!
    
    if tabbarViewItem.title == "Settings"{
        navigationController = UINavigationController(rootViewController: Wireframe.instance.getSettings())
    }else{
        navigationController = UINavigationController(rootViewController: Wireframe.instance.getViewController(tabbarViewItem.name))
    }
    
    navigationController.navigationBar.barTintColor = UIColor(red: 0, green: 122.0/255, blue: 1, alpha: 1)
    navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    navigationController.navigationBar.tintColor = UIColor.whiteColor()
    
    navigationController.tabBarItem = UITabBarItem(title: tabbarViewItem.title, image: UIImage(named: tabbarViewItem.iconTitle)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: nil)
    
    navigationController.tabBarItem.selectedImage = UIImage(named: tabbarViewItem.iconTitle)
    
    
    return navigationController;
}