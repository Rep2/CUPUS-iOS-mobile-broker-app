//
//  SingleLabelWithImageCell.swift
//  Surveys
//
//  Created by Rep on 11/20/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

class SingleLabelWithImageCell:IRGenericCellImplementation{

    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    
    override func initElements(){
        elements[IRCellElementIdentifiers.FirstLabel] = firstLabel
        elements[IRCellElementIdentifiers.FirstImage] = firstImage
    }
}