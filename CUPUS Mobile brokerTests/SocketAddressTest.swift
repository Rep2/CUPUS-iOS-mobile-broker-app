//
//  SocketAddressTest.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 06/06/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import XCTest
@testable import CUPUS_Mobile_broker

public class SocketAddressTest: XCTestCase {

    func testCastIPStringToInt(){
        do{
            _ = try IRSockaddr.IPv4ToInt("1.1.1.1")
        }catch{
            XCTAssert(false)
        }
        
        XCTAssert(true)
    }
    
    func testCastIPIntToString(){
        let str = IRSockaddr.IPv4ToString(16843009)
        
        XCTAssert(str == "1.1.1.1")
    }
    
    func testIPTransformation(){
        
        do{
            let ip = "192.31.32.11"
            
            let result = try IRSockaddr.IPv4ToInt(ip)
            
            let str = IRSockaddr.IPv4ToString(result.s_addr)
            
            XCTAssert(ip == str)
        }catch{
            XCTAssert(false)
        }
    }
    
}