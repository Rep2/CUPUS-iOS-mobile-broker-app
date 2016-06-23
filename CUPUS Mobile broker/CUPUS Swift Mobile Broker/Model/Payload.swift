//
//	Payload.swift
//
//	Create by Ivan Rep on 22/6/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import Unbox

struct Payload: Unboxable{

	var features : [Feature]
	var type : String

    init(unboxer: Unboxer){
        self.features = unboxer.unbox("features")
        self.type = unboxer.unbox("type")
    }
    
    init(features: [Feature], type: String = "FeatureCollection"){
        self.features = features
        self.type = type
    }

}