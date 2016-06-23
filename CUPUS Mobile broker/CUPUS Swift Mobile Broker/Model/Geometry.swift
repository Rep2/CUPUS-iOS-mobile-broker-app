//
//	Geometry.swift
//
//	Create by Ivan Rep on 22/6/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import Unbox

struct Geometry: Unboxable{

	var coordinates : [[Double]]
	var type : String

    init(unboxer: Unboxer){
        self.coordinates = unboxer.unbox("coordinates")
        self.type = unboxer.unbox("type")
    }
    
    init(coordinates : [[Double]], type : String){
        self.coordinates = coordinates
        self.type = type
    }
}