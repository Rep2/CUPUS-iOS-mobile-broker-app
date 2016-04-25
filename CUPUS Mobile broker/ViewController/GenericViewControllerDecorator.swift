//
//  GenericViewControllerDecorator.swift
//  Appbook
//
//  Created by IN2 MacbookPro on 04/01/16.
//  Copyright © 2016 iOS pro team. All rights reserved.
//

import UIKit


class GenericsWireframe{
    
    static let instance = GenericsWireframe()
    
    var genericStoryboard: UIStoryboard!
    
    init(){
        genericStoryboard = UIStoryboard(name: "Generics", bundle: nil)
    }
    
    func getTableViewController() -> GenericTableViewController{
        return genericStoryboard.instantiateViewControllerWithIdentifier("GenericTableViewController") as! GenericTableViewController
    }
    
}


class GenericViewControllerDecorator{
    
    init(decorator:GenericViewControllerDecorator? = nil, viewDidLoadFunc:((viewController:UIViewController) -> Void)? = nil, viewDidAppearFunc:((viewController:UIViewController) -> Void)? = nil){
        self.decorator = decorator
        
        self.viewDidLoadFunc = viewDidLoadFunc
        self.viewDidAppearFunc = viewDidAppearFunc
    }
    
    var decorator: GenericViewControllerDecorator?
    
    func viewDidLoad(viewController:UIViewController){        
        if let decorator = decorator{
            decorator.viewDidLoad(viewController)
        }
        
        if let viewDidLoadFunc = viewDidLoadFunc{
            viewDidLoadFunc(viewController: viewController)
        }
    }
    
    func viewWillAppear(viewController:UIViewController){
        if let decorator = decorator{
            decorator.viewWillAppear(viewController)
        }
        
        if let viewWillAppearFunc = viewWillAppearFunc{
            viewWillAppearFunc(viewController: viewController)
        }
    }
    
    func viewDidAppear(viewController:UIViewController){
        if let decorator = decorator{
            decorator.viewDidAppear(viewController)
        }
        
        if let viewDidAppearFunc = viewDidAppearFunc{
            viewDidAppearFunc(viewController: viewController)
        }
    }
    
    func viewWillDisappear(viewController:UIViewController){
        if let decorator = decorator{
            decorator.viewWillDisappear(viewController)
        }
        
        if let viewWillDisappearFunc = viewWillDisappearFunc{
            viewWillDisappearFunc(viewController: viewController)
        }
    }
    
    var viewDidLoadFunc:((viewController:UIViewController) -> Void)?
    var viewWillAppearFunc:((viewController:UIViewController) -> Void)?
    var viewDidAppearFunc:((viewController:UIViewController) -> Void)?
    var viewWillDisappearFunc:((viewController:UIViewController) -> Void)?
    
    static func titleDecorator(title:String) -> GenericViewControllerDecorator{
        
        return GenericViewControllerDecorator(viewDidLoadFunc: { (viewController) -> Void in
            viewController.title = title
        })
        
    }

}

