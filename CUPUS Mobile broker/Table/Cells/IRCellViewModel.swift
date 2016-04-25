//
//  CellModel.swift
//  Surveys
//
//  Created by Rep on 11/4/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

/// ViewModel that storec cell creation information and 
/// allows communication with the created cell
class IRCellViewModel{
    
    /// Identifier used to create cell instance
    let implementationIdentifier: IRCellIdentifier
    
    /// Height of the cell
    let height:CGFloat
    
    /// Accessory type
    var accessoryType:UITableViewCellAccessoryType
    
    
    /// Cell update
    
    /// Data used to populate cell instance. Needs to be set as it used on every will display cell.
    var data:[IRCellElementIdentifiers:Any]
    
    /// Cell implementation function used to update it
    var cellUpdateFunc:([IRCellElementIdentifiers:Any] -> Void)?
    
    /// Sets data and updates cell
    func setDataAndUpdateCell(data:[IRCellElementIdentifiers:Any]){
        self.data = data
        
        if let cellUpdateFunc = cellUpdateFunc{
            cellUpdateFunc(data)
        }
    }
    
    /// Any custom initis
    var postInit:((UITableViewCell)->Void)?
    
    /// Cell events
    
    /// Gets called on cell selection
    var didSelectCellFunc:(() -> Void)?
    
    /// Observer function
    var cellEventHandler:((Any?) -> Void)?
    
    init(implementationIdentifier: IRCellIdentifier,
        height:CGFloat = 44,
        accessoryType:UITableViewCellAccessoryType = .None,
        data:[IRCellElementIdentifiers:Any] = [:],
        postInit:((UITableViewCell)->Void)? = nil,
        didSelectCellFunc:(()->Void)? = nil,
        cellEventHandler:((Any?) -> Void)? = nil){
            
        self.implementationIdentifier = implementationIdentifier
        self.height = height
        self.accessoryType = accessoryType
        
        self.data = data
        self.postInit = postInit
        
        self.didSelectCellFunc = didSelectCellFunc
        self.cellEventHandler = cellEventHandler
    }
}