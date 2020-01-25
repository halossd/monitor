//
//  OverseeSectionController.swift
//  monitor
//
//  Created by cc on 1/23/20.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit

//全局常量
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let SCREEN_WIDTH = UIScreen.main.bounds.width

class OverseeSectionController: ListSectionController {
    var data: OverseeModel!
    
    override init() {
        super.init()
    }
}

extension OverseeSectionController {
    override func didUpdate(to object: Any) {
        data = object as? OverseeModel
    }
    
    override func numberOfItems() -> Int {
        return 1 + data.orders.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        if index == 0 {
            return OverseeInfoCell.cellSize()
        } else {
            return OverseeOrdersCell.cellSize()
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass: AnyClass
        if index == 0 {
            cellClass = OverseeInfoCell.self
        } else {
            cellClass = OverseeOrdersCell.self
        }
        
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
        if let cell = cell as? OverseeInfoCell {
//            let profit = data.equity.double() - data.balance.double()
//            cell.topLabel.text = String(format: ".2f", profit)
//            cell.topLabel.backgroundColor = profit > 0 ? kBlue : kRed
            cell.tPlatformLabel.text = data.company
            cell.vPlatformLabel.text = data.account
            cell.vIpLabel.text = data.host
            cell.vBalanceLabel.text = data.balance
            cell.vNetWorthLabel.text = data.equity
            cell.vPrepaymentsLabel.text = data.margin
            cell.vAvailablePrepaidLabel.text = data.freeMargin
            cell.vMarginRateLabel.text = data.marginLevel
        } else if let cell = cell as? OverseeOrdersCell {
            cell.data = data.orders[index-1]
        }
        return cell
    }
}
