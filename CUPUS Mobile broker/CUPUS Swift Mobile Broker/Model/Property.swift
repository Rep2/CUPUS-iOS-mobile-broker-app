//
//	Property.swift
//
//	Create by Ivan Rep on 22/6/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import Unbox

struct Property: Unboxable{

    var predicateMap : [String]
    var stringAttributeBorders : StringAttributeBorder
    
    init(unboxer: Unboxer){
        self.predicateMap = unboxer.unbox("predicateMap")
        self.stringAttributeBorders = unboxer.unbox("stringAttributeBorders")
    }
    
    init(predicateMap : [String], stringAttributeBorders : StringAttributeBorder){
        self.predicateMap = predicateMap
        self.stringAttributeBorders = stringAttributeBorders
    }
}

struct StringAttributeBorder: Unboxable{
    
    init(unboxer: Unboxer){
    }

    init(){
        
    }
}