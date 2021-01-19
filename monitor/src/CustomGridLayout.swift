//
//  CustomGridLayout.swift
//  monitor
//
//  Created by cc on 2/12/20.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit

class CustomGridLayout: UICollectionViewLayout {
    
    var contentHeight: CGFloat = 0
    
    override init() {
        super.init()
        
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
