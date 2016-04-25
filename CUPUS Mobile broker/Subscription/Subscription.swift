//
//  Subscription.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation

class SubscriptionManger{
    
    static let instance = SubscriptionManger()
    
    var subscriptions = [String]()
    
    func addSubscriptions(title: String){
        subscriptions.append(title)
    }
    
}

class Subscription{
    
    var subscriptionTypes: [String]
    
    init(types: [String] = []){
        subscriptionTypes = types
    }
    
    func optionPressed(type: String){
        if subscriptionTypes.contains(type){
            subscriptionTypes.removeAtIndex(subscriptionTypes.indexOf(type)!)
        }else{
            subscriptionTypes.append(type)
        }
        
        print(subscriptionTypes)
    }
    
}