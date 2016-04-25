//
//  ViewControllerWithDecorator.swift
//  Appbook
//
//  Created by IN2 MacbookPro on 04/01/16.
//  Copyright © 2016 iOS pro team. All rights reserved.
//

import UIKit

class ViewControllerWithDecorator: UIViewController{
    
    var decorator:GenericViewControllerDecorator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let decorator = decorator{
            decorator.viewDidLoad(self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let decorator = decorator{
            decorator.viewWillAppear(self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let decorator = decorator{
            decorator.viewDidAppear(self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let decorator = decorator{
            decorator.viewWillDisappear(self)
        }
    }
}