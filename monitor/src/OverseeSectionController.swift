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

class OverseeSectionController: ListBindingSectionController<ListDiffable>, ListBindingSectionControllerDataSource, ListBindingSectionControllerSelectionDelegate {
    
    var data: OverseeModel!
    
    override init() {
        super.init()
        dataSource = self
        selectionDelegate = self
        minimumInteritemSpacing = 5
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let om = object as? OverseeModel else { return [] }
        
        var viewModels = [ListDiffable]()
        viewModels.append(om)
        viewModels += om.orders
        
        return viewModels
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        let cellClass: UICollectionViewCell.Type
        if viewModel is Order {
            cellClass = OverseeOrdersCell.self
        } else {
            cellClass = OverseeInfoCell.self
        }
        
        guard let cell = collectionContext?.dequeueReusableCell(of: cellClass, for: self, at: index) as? UICollectionViewCell & ListBindable else {
            fatalError()
        }
        return cell
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        if viewModel is Order {
            return OverseeOrdersCell.cellSize()
        } else {
            return OverseeInfoCell.cellSize()
        }
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didSelectItemAt index: Int, viewModel: Any) {}
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didDeselectItemAt index: Int, viewModel: Any) {}
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didHighlightItemAt index: Int, viewModel: Any) {}
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didUnhighlightItemAt index: Int, viewModel: Any) {}
  
}
/*
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
*/
