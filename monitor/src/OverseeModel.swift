//
//  OverseeModel.swift
//  monitor
//
//  Created by cc on 1/23/20.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit
import SwiftyJSON

final class OverseeModel: NSObject {
    let company: String
    let account: String
    let host: String
    let balance: String
    let equity: String
    let freeMargin: String
    let marginLevel: String
    let margin: String
    let orders: [Order]
    
    init(json: JSON) {
        self.company = json["company"].string!
        self.account = json["account"].string!
        self.host = json["host"].string!
        self.balance = json["balance"].string!
        self.equity = json["equity"].string!
        self.freeMargin = json["freeMargin"].string!
        self.marginLevel = json["marginLevel"].string!
        self.margin = json["margin"].string!
        let ods = json["orders"].array ?? []
        var arr: [Order] = []
        for order in ods {
            arr.append(Order(json: order))
        }
        self.orders = arr
    }
}

final class Order: NSObject {
    let symbol: String
    let type: String
    let lots: String
    let profit: String
    
    init(json: JSON) {
        self.symbol = json["symbol"].string!
        self.type = json["type"].string!
        self.lots = json["lots"].string!
        self.profit = json["profit"].string!
    }
}
