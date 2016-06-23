//
//	RootClass.swift
//
//	Create by Ivan Rep on 22/6/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import Unbox

struct Subscription: Unboxable{

	var payload : Payload
	var startTime : Int
	var validity : Int
    
    init(unboxer: Unboxer){
        self.payload = unboxer.unbox("payload")
        self.startTime = unboxer.unbox("startTime")
        self.validity = unboxer.unbox("validity")
    }
    
    init(payload: Payload, startTime: Int, validity: Int = -1){
        self.payload = payload
        self.startTime = startTime
        self.validity = validity
    }

}