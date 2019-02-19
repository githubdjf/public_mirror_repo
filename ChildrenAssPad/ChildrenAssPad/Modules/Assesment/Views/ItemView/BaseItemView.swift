//
//  BaseItemView.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/28.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 选项基类
 */


import UIKit

class BaseItemView: UIView {
    
    let itemIndex: Int
    let maxWidth: CGFloat

    var isItemSelected = false
    
    init(frame: CGRect, index: Int, maxWidth: CGFloat) {
        self.itemIndex = index
        self.maxWidth = maxWidth
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Public
    
    func setItemSelectedStatus(isSelected: Bool) {
        
        isItemSelected = isSelected
    }
}

