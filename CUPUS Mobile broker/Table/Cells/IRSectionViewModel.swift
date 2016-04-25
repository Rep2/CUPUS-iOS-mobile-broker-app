//
//  IRSectionViewModel.swift
//  ProjektWSTest
//
//  Created by Rep on 3/1/16.
//  Copyright © 2016 Rep. All rights reserved.
//

import Foundation

/// Section of CellViewModels
/// Allows easy presentation in IRTableView
class IRCellViewModelSection{
    
    /// Section title
    let sectionTitle:String?
    
    /// CellViewModels
    var cellViewModels:[IRCellViewModel]
    
    init(sectionTitle:String?, cellViewModels:[IRCellViewModel]){
        self.sectionTitle = sectionTitle
        self.cellViewModels = cellViewModels
    }
  
}