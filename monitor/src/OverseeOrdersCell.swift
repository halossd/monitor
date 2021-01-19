//
//  OverseeOrdersCell.swift
//  monitor
//
//  Created by cc on 1/23/20.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit
import SwiftyJSON

class OverseeOrdersCell: UICollectionViewCell {
    let tTrade: UILabel = UILabel()
    let vTrade: UILabel = UILabel()

    static func cellSize() -> CGSize {
        let w = UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown ? SCREEN_WIDTH : 375
        return CGSize(width: w, height: 21)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 22/255.0, green: 22/255.0, blue: 22/255.0, alpha: 1)
        tTrade.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        tTrade.textColor = .white
        contentView.addSubview(tTrade)
        
        vTrade.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        vTrade.textColor = .white
        vTrade.textAlignment = .right
        contentView.addSubview(vTrade)
        
        tTrade.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        vTrade.snp.makeConstraints { (make) in
            make.top.equalTo(tTrade)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OverseeOrdersCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? Order else { return }
        
        let str1 = viewModel.symbol + " "
        let str2 = viewModel.type + " " + viewModel.lots
        let str3 = str1 + str2
            
        let attr = NSMutableAttributedString(string: str3)
        let range = str3.nsString.range(of: str2)
        var c = kRed
        if viewModel.type == "BUY" {
            c = kBlue
        }

        attr.addAttribute(.foregroundColor, value: c, range: range)
        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .medium), range: range)
        tTrade.attributedText = attr
        vTrade.text = viewModel.profit
        vTrade.textColor = viewModel.profit.nsString.compare("0", options: .numeric).rawValue == -1 ? kRed : kBlue
    }
}
