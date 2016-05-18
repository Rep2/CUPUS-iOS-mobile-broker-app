//
//  SubscriptionOptions.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import CoreLocation

class SubscriptionOptions{
    
    static var sourceOptions = [
        "CO2",
        "O2",
        "Noise",
        "Temperature"
    ]

}

struct CircleData{
    let center: CLLocationCoordinate2D
    let radius: Double
}