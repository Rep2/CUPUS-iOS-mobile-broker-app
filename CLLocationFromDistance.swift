//
//  CLLocationFromDistance.swift
//  CUPUS Mobile broker
//
//  Created by Ivan Rep on 6/23/16.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation
import CoreLocation

func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    let distRadians = distanceMeters / (6372797.6)
    
    let rbearing = bearing * M_PI / 180.0
    
    let lat1 = origin.latitude * M_PI / 180
    let lon1 = origin.longitude * M_PI / 180
    
    let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
    let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
    
    return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
}

func createPolygonFromCenterAndDistance(center: CLLocationCoordinate2D, distanceInMeters:Double) -> [[Double]]{
    
    var points = [CLLocationCoordinate2D]()
    
    points.append(locationWithBearing(5.49778714, distanceMeters: distanceInMeters, origin: center))
    
    points.append(locationWithBearing(0.785398163, distanceMeters: distanceInMeters, origin: center))
    
    points.append(locationWithBearing(2.35619449, distanceMeters: distanceInMeters, origin: center))
    
    points.append(locationWithBearing(3.92699082, distanceMeters: distanceInMeters, origin: center))
    
    points.append(locationWithBearing(5.49778714, distanceMeters: distanceInMeters, origin: center))
    
    var coordinates = [[Double]]()
    
    for point in points{
        coordinates.append([point.latitude, point.longitude])
    }
    
    return coordinates
}