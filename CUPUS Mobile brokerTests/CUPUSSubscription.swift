//
//  CUPUSSubscription.swift
//  CUPUS Mobile broker
//
//  Created by Ivan Rep on 6/23/16.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation
import XCTest
@testable import CUPUS_Mobile_broker



class CUPUSSubscription:XCTestCase {
    
    func testCreateSubscription(){
        
        let subscriptionModel = Subscriber.createSubscriptionModel([CUPUSValueType.SensorReading], startTime: Int(NSDate.timeIntervalSinceReferenceDate()), coordinates: [
            [1.1, 3.0],
            [3.0, 1.0],
            [3.0, 3.0],
            [1.0, 3.0]])
        
        do{
            _ = try Subscriber.wrapSubscription(subscriptionModel)
            
            XCTAssertTrue(true)
        }catch{
            XCTAssertTrue(false)
        }
        
    }
    
}