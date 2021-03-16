//
//  HostCell.swift
//  monitor
//
//  Created by cc on 2021/3/10.
//  Copyright © 2021 cc. All rights reserved.
//

import UIKit

class HostCell: UITableViewCell {
    
    static let reuseIdentifier = "HostCell"
    
    let ipLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
        
        ipLabel.textColor = .white
        ipLabel.textAlignment = .center
        ipLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(ipLabel)
        
        ipLabel.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(red: 66, green: 66, blue: 66)
        contentView.addSubview(bottomLine)
        
        bottomLine.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
