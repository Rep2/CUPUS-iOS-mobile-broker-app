//
//	Property.swift
//
//	Create by Ivan Rep on 22/6/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import Unbox

class Property: Unboxable{
    required init(unboxer: Unboxer){
    }
    
    init(){
        
    }
}

class SubscriptionProperty: Property{
    var predicateMap : [String]
    var stringAttributeBorders : StringAttributeBorder
    
    required init(unboxer: Unboxer){
        self.predicateMap = unboxer.unbox("predicateMap")
        self.stringAttributeBorders = unboxer.unbox("stringAttributeBorders")
        
        super.init(unboxer: unboxer)
    }
    
    init(predicateMap : [String], stringAttributeBorders : StringAttributeBorder){
        self.predicateMap = predicateMap
        self.stringAttributeBorders = stringAttributeBorders
        
        super.init()
    }
}

class PublicationProperty: Property{
    var Type: String
    var ID: String
    var co: String
    
    required init(unboxer: Unboxer){
        self.Type = unboxer.unbox("type")
        self.ID = unboxer.unbox("id")
        self.co = unboxer.unbox("co")
        
        super.init(unboxer: unboxer)
    }
    
    init(type:String, id:String, co:String){
        self.Type = type
        self.ID = id
        self.co = co
        
        super.init()
    }
}

struct StringAttributeBorder: Unboxable{
    
    init(unboxer: Unboxer){
    }

    init(){
        
    }
}