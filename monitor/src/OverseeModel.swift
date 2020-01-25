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
    let orders: [JSON]
    
    init(json: JSON) {
        self.company = json["company"].string!
        self.account = json["account"].string!
        self.host = json["host"].string!
        self.balance = json["balance"].string!
        self.equity = json["equity"].string!
        self.freeMargin = json["freeMargin"].string!
        self.marginLevel = json["marginLevel"].string!
        self.margin = json["margin"].string!
        self.orders = json["orders"].array ?? []
    }
}
