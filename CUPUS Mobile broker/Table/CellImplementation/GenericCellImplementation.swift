//
//  GenericCellImplementation.swift
//  Surveys
//
//  Created by Rep on 11/4/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

/// Cell implementation identifiers of all registered cells
enum IRCellIdentifier:String{
    case OneLabelBasic = "OneLabelTableViewCell"
    case TwoLabelRightDetail = "TwoLabelLeftInfoCellImplementation"
    
    case OneLabelImageBasic = "SingleLabelWithImageCell"
    case OneLabelRightImage = "OneLabelRightImageTableViewCell"
    case SubtitelWithImage = "SubtitelWithImageCell"
}

/// Element identifiers
enum IRCellElementIdentifiers{
    case FirstLabel
    case SecondLabel
    
    case FirstImage
}

// Generic cell implementation
class IRGenericCellImplementation:UITableViewCell{

    // Dictionary used to access all cells labels
    var elements:[IRCellElementIdentifiers:UIView]
    
    required init?(coder aDecoder: NSCoder) {
        elements = [:]
        
        super.init(coder: aDecoder)
    }
    
    // Inits labels dictionary with cell elements
    func initElements(){
    }
    
    // Sets labels text with given data
    // - parameter data: dictionary containing data which is used to init labels
    func setData(data:[IRCellElementIdentifiers:Any]){
        if elements == [:]{
            initElements()
        }
        
        for (key, value) in data{
            if let element = elements[key]{
                if element is UILabel{
                    (element as! UILabel).text = value as? String ?? ""
                }else if element is UIImageView{
                    if let value = value as? String{
                        (element as! UIImageView).image = UIImage(named: value)
                    }else if let value = value as? UIImage{
                        (element as! UIImageView).image = value
                    }else if value is Bool{
                        (element as! UIImageView).hidden = !(element as! UIImageView).hidden
                    }
                }
            }
        }
    }
}
