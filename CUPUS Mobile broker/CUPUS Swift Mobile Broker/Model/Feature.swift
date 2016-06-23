//
//	Feature.swift
//
//	Create by Ivan Rep on 22/6/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import Unbox

struct Feature: Unboxable{

	var geometry : Geometry
	var properties : Property
	var type : String
    
    init(unboxer: Unboxer){
        self.geometry = unboxer.unbox("geometry")
        self.properties = unboxer.unbox("properties")
        self.type = unboxer.unbox("type")
    }

    init(geometry : Geometry, properties : Property, type : String = "Feature"){
        self.geometry = geometry
        self.properties = properties
        self.type = type
    }

}