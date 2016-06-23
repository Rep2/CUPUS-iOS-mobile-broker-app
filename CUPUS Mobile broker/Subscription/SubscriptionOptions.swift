//
//  SubscriptionOptions.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import CoreLocation

enum SensorSubscriptionOptions:String{
    case CO2 = "CO2"
    case O2 = "O2"
    case Noise = "Noise"
    case Temperature = "Temperature"
    
    static let allValues = [CO2, O2, Noise, Temperature]
}
