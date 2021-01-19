//
//  OverseeCollectionCell.swift
//  monitor
//
//  Created by cc on 1/23/20.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit
import SnapKit

//颜色
let C2: UIColor = .white
let C7: UIColor = UIColor(red: 110/255.0, green: 110/255.0, blue: 110/255.0, alpha: 1)
let kBlue: UIColor = UIColor(red: 44/255.0, green: 118/255.0, blue: 244/255.0, alpha: 1)
let kRed: UIColor = UIColor(red: 255/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1)

class OverseeInfoCell: UICollectionViewCell {
    let topLabel: UILabel = UILabel()
    let tPlatformLabel: UILabel = UILabel()
    let vPlatformLabel: UILabel = UILabel()
    let tIpLabel: UILabel = UILabel()
    let vIpLabel: UILabel = UILabel()
    let tBalanceLabel: UILabel = UILabel()
    let vBalanceLabel: UILabel = UILabel()
    let tNetWorthLabel: UILabel = UILabel()
    let vNetWorthLabel: UILabel = UILabel()
    let tPrepaymentsLabel: UILabel = UILabel()
    let vPrepaymentsLabel: UILabel = UILabel()
    let tAvailablePrepaidLabel: UILabel = UILabel()
    let vAvailablePrepaidLabel: UILabel = UILabel()
    let tMarginRateLabel: UILabel = UILabel()
    let vMarginRateLabel: UILabel = UILabel()
    
    static func cellSize() -> CGSize {
        var bodyHeight: CGFloat = 15
        if UIDevice.current.userInterfaceIdiom == .pad {
            bodyHeight = 20
        }
        let w = UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown ? SCREEN_WIDTH : 375
        return CGSize(width: w, height: (bodyHeight + 8) * 7 + 40 + 10)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        var headerFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        var bodyFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        var bodyHeight: CGFloat = 15
        if UIDevice.current.userInterfaceIdiom == .pad {
            bodyHeight = 20
            headerFont = UIFont.systemFont(ofSize: 18, weight: .medium)
            bodyFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        }
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        backgroundColor = UIColor(red: 22/255.0, green: 22/255.0, blue: 22/255.0, alpha: 1)
        //MARK: - 初始化控件
        
        topLabel.font = headerFont
        topLabel.text = "-1231.11"
        topLabel.textColor = .white
        topLabel.textAlignment = .center
        contentView.addSubview(topLabel)
        
        tPlatformLabel.font = bodyFont
        tPlatformLabel.text = "Tickmill Ltd"
        tPlatformLabel.textColor = C2
        contentView.addSubview(tPlatformLabel)
        
        vPlatformLabel.font = bodyFont
        vPlatformLabel.textColor = C2
        vPlatformLabel.textAlignment = .right
        contentView.addSubview(vPlatformLabel)
        
        tIpLabel.font = bodyFont
        tIpLabel.text = "客户:"
        tIpLabel.textColor = C2
        contentView.addSubview(tIpLabel)
        
        vIpLabel.font = bodyFont
        vIpLabel.textColor = C2
        vIpLabel.textAlignment = .right
        contentView.addSubview(vIpLabel)
        
        tBalanceLabel.font = bodyFont
        tBalanceLabel.text = "余额:"
        tBalanceLabel.textColor = C2
        contentView.addSubview(tBalanceLabel)
        
        vBalanceLabel.font = bodyFont
        vBalanceLabel.textColor = C2
        vBalanceLabel.textAlignment = .right
        contentView.addSubview(vBalanceLabel)
        
        tNetWorthLabel.font = bodyFont
        tNetWorthLabel.text = "净值:"
        tNetWorthLabel.textColor = C2
        contentView.addSubview(tNetWorthLabel)
        
        vNetWorthLabel.font = bodyFont
        vNetWorthLabel.textColor = C2
        vNetWorthLabel.textAlignment = .right
        contentView.addSubview(vNetWorthLabel)
        
        tPrepaymentsLabel.font = bodyFont
        tPrepaymentsLabel.text = "预付款:"
        tPrepaymentsLabel.textColor = C2
        contentView.addSubview(tPrepaymentsLabel)
        
        vPrepaymentsLabel.font = bodyFont
        vPrepaymentsLabel.textColor = C2
        vPrepaymentsLabel.textAlignment = .right
        contentView.addSubview(vPrepaymentsLabel)
        
        tAvailablePrepaidLabel.font = bodyFont
        tAvailablePrepaidLabel.text = "可用预付款"
        tAvailablePrepaidLabel.textColor = C2
        contentView.addSubview(tAvailablePrepaidLabel)
        
        vAvailablePrepaidLabel.font = bodyFont
        vAvailablePrepaidLabel.textColor = C2
        vAvailablePrepaidLabel.textAlignment = .right
        contentView.addSubview(vAvailablePrepaidLabel)
        
        tMarginRateLabel.font = bodyFont
        tMarginRateLabel.text = "预付款比例:"
        tMarginRateLabel.textColor = C2
        contentView.addSubview(tMarginRateLabel)
        
        vMarginRateLabel.font = bodyFont
        vMarginRateLabel.textColor = C2
        vMarginRateLabel.textAlignment = .right
        contentView.addSubview(vMarginRateLabel)
        
        tPlatformLabel.font = bodyFont
        tPlatformLabel.text = ""
        tPlatformLabel.textColor = C2
        contentView.addSubview(tPlatformLabel)
        
        vPlatformLabel.font = bodyFont
        vPlatformLabel.textColor = C2
        vPlatformLabel.textAlignment = .right
        contentView.addSubview(vPlatformLabel)
        
        tPlatformLabel.font = bodyFont
        tPlatformLabel.text = ""
        tPlatformLabel.textColor = C2
        contentView.addSubview(tPlatformLabel)
        
        vPlatformLabel.font = bodyFont
        vPlatformLabel.textColor = C2
        vPlatformLabel.textAlignment = .right
        contentView.addSubview(vPlatformLabel)
        
        //MARK: - 布局
        let left = 15, top = 8
        
        topLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        tPlatformLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(top)
            make.left.equalToSuperview().offset(left)
            make.height.equalTo(bodyHeight)
        }
        
        vPlatformLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tPlatformLabel)
            make.right.equalToSuperview().offset(-left)
            make.height.equalTo(bodyHeight)
        }
        
        tIpLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tPlatformLabel.snp.bottom).offset(top)
            make.left.equalToSuperview().offset(left)
            make.height.equalTo(bodyHeight)
        }
        
        vIpLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tIpLabel)
            make.right.equalToSuperview().offset(-left)
            make.height.equalTo(bodyHeight)
        }
        
        tBalanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tIpLabel.snp.bottom).offset(top)
            make.left.equalToSuperview().offset(left)
            make.height.equalTo(bodyHeight)
        }
        
        vBalanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tBalanceLabel)
            make.right.equalToSuperview().offset(-left)
            make.height.equalTo(bodyHeight)
        }
        
        tNetWorthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tBalanceLabel.snp.bottom).offset(top)
            make.left.equalToSuperview().offset(left)
            make.height.equalTo(bodyHeight)
        }
        
        vNetWorthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tNetWorthLabel)
            make.right.equalToSuperview().offset(-left)
            make.height.equalTo(bodyHeight)
        }

        tPrepaymentsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tNetWorthLabel.snp.bottom).offset(top)
            make.left.equalToSuperview().offset(left)
            make.height.equalTo(bodyHeight)
        }
        
        vPrepaymentsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tPrepaymentsLabel)
            make.right.equalToSuperview().offset(-left)
            make.height.equalTo(bodyHeight)
        }

        tAvailablePrepaidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tPrepaymentsLabel.snp.bottom).offset(top)
            make.left.equalToSuperview().offset(left)
            make.height.equalTo(bodyHeight)
        }
        
        vAvailablePrepaidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tAvailablePrepaidLabel)
            make.right.equalToSuperview().offset(-left)
            make.height.equalTo(bodyHeight)
        }

        tMarginRateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tAvailablePrepaidLabel.snp.bottom).offset(top)
            make.left.equalToSuperview().offset(left)
            make.height.equalTo(bodyHeight)
        }
        
        vMarginRateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tMarginRateLabel)
            make.right.equalToSuperview().offset(-left)
            make.height.equalTo(bodyHeight)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OverseeInfoCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let data = viewModel as? OverseeModel else { return }
        let profit = data.equity.double()! - data.balance.double()!
        topLabel.text = String(format: "%.2f", profit)
        topLabel.backgroundColor = profit > 0 ? kBlue : kRed
        tPlatformLabel.text = data.company
        vPlatformLabel.text = data.account
        vIpLabel.text = data.host
        vBalanceLabel.text = data.balance
        vNetWorthLabel.text = data.equity
        vPrepaymentsLabel.text = data.margin
        vAvailablePrepaidLabel.text = data.freeMargin
        vMarginRateLabel.text = data.marginLevel

    }
}
