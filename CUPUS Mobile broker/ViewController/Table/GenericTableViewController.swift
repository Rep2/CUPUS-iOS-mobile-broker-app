//
//  GenericTableViewController.swift
//  Glaxo
//
//  Created by Rep on 12/7/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import UIKit

/**
 Generic UIViewController implementing IRTableView
*/
class GenericTableViewController: ViewControllerWithDecorator{
    
    @IBOutlet weak var table: IRTableView!
    
    var cellViewModelSections:[IRCellViewModelSection]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.setData(cellViewModelSections)
    }
    
    func setSections(sections:[IRCellViewModelSection]){
        cellViewModelSections = sections
        
        if table != nil{
            table.setData(cellViewModelSections)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        table.superviewWillApper()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        table.superviewDidDisappear()
    }
}
