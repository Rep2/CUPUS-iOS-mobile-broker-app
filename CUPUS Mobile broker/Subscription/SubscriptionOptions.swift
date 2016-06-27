//
//  SubscriptionOptions.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import CoreLocation

enum SensorSubscriptionOptions:String{

    case NoiseLevel = "Noise Level"
    case Temperature = "Temperature"
    case Humidity = "Humidity"
    case Pressure = "Pressure"
    case NO2 = "NO2"
    case SO2 = "SO2"
    case CO = "CO"
    
    static let allValues = [NoiseLevel, Temperature, Humidity, Pressure, NO2, SO2, CO]
}
