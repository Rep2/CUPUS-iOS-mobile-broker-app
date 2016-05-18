//
//  Subscription.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation

enum SubscriptionType{
    case Follow
    case Pick
}

class SubscriptionManger{
    
    static let instance = SubscriptionManger()
    
    var subscriptions = [Subscription]()
    
    func addSubscriptions(subscription: Subscription){
        subscriptions.append(subscription)
    }
    
}

class Subscription{
    
    var type:SubscriptionType
    var subscriptionTypes: [String]
    
    init(type:SubscriptionType, types: [String] = []){
        subscriptionTypes = types
        self.type = type
    }
    
    func optionPressed(type: String){
        if subscriptionTypes.contains(type){
            subscriptionTypes.removeAtIndex(subscriptionTypes.indexOf(type)!)
        }else{
            subscriptionTypes.append(type)
        }
    }
    
}