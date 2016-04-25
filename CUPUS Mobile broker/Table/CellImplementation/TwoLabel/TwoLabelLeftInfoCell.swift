//
//  TwoLabelLeftInfoCell.swift
//  Surveys
//
//  Created by Rep on 11/13/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

class TwoLabelLeftInfoCell:IRGenericCellImplementation{

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var secondLabelRightConstraint: NSLayoutConstraint!
    
    override func initElements(){
        elements[IRCellElementIdentifiers.FirstLabel] = firstLabel
        elements[IRCellElementIdentifiers.SecondLabel] = secondLabel
    }    
}