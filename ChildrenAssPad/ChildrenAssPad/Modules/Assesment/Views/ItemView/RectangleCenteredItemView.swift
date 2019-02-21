//
//  RectangleCenteredItemView.swift
//  ChildrenAssPad
//
//  Created by Jaffer on 2019/2/20.
//  Copyright © 2019年 yitai. All rights reserved.
//

import UIKit

class RectangleCenteredItemView: BaseItemView {

    static let rectangleCenteredItemBaseTag = 100
    
    var titleLabel: UILabel!
    var actionButton: UIButton!
    
    deinit {
        print("")
    }
    override init(frame: CGRect, index: Int, maxWidth: CGFloat) {
        super.init(frame: frame, index: index, maxWidth: maxWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Public
    
    /*
     fixWidth && fixHeight -> fixHeight > 0 && fixWidth > 0
     !fixWidth && fixHeight -> fixHeight > 0
     fixWidth && !fixHeight -> fixWidth > 0
     !fixWidth && !fixHeight
     
     inset: 内容部分距离当前容器的边距（事件响应区域不受inset影响，以当前容器为准）
     */
    
    func initialize(withTitle title: String, titleFont font: UIFont, lineNumber: Int, breakMode: NSLineBreakMode, contentInset inset: UIEdgeInsets, isFixWidth: Bool, fixedWidth: CGFloat, minWidth: CGFloat, isFixHeight: Bool, fixedHeigth: CGFloat, minHeight: CGFloat) -> CGSize {
        
        var itemSize: CGSize = .zero
        var titleSize: CGSize = .zero
        
        if isFixWidth && isFixHeight {
            //宽高固定，以指定值为准，内容部分考虑inset缩进
            itemSize.width = fixedWidth
            itemSize.height = fixedHeigth
            
        } else if !isFixWidth && isFixHeight {
            //高度固定，动态计算行宽
            titleSize = title.textSize(byFont: font, breakMode: breakMode, inSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeigth - inset.top - inset.bottom))
            let width = titleSize.width + inset.left + inset.right
            itemSize.width = minWidth > 0 ? max(minWidth, width) : width
            itemSize.height = fixedHeigth
            
        } else if isFixWidth && !isFixHeight {
            //宽度固定，动态计算行高
            titleSize = title.textSize(byFont: font, breakMode: .byWordWrapping, inSize: CGSize(width: fixedWidth - inset.left - inset.right, height: CGFloat.greatestFiniteMagnitude))
            itemSize.width = fixedWidth
            let height = titleSize.height + inset.top + inset.bottom
            itemSize.height = minHeight > 0 ? max(minHeight, height) : height
            
        } else {
            print("cant not layout")
            itemSize = CGSize(width: fixedWidth, height: fixedHeigth)
        }
        
        let titleX = inset.left
        let titleW = itemSize.width - inset.left - inset.right
        let titleRect = CGRect(x: titleX, y: 0, width: titleW, height: itemSize.height)
        titleLabel = UILabel()
        titleLabel.frame = titleRect
        titleLabel.font = font
        titleLabel.numberOfLines = lineNumber
        titleLabel.lineBreakMode = breakMode
        titleLabel.text = title
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        let actionRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        actionButton = UIButton(type: .custom)
        actionButton.frame = actionRect
        actionButton.tag = RectangleCenteredItemView.rectangleCenteredItemBaseTag + itemIndex
        addSubview(actionButton)
        
        layer.cornerRadius = 22
        layer.masksToBounds = true
        
        frame.size = itemSize
        
        return itemSize
    }
    
    override func setItemSelectedStatus(isSelected: Bool) {
        
        super.setItemSelectedStatus(isSelected: isSelected)
        
        if isSelected {
            titleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
            backgroundColor = UIColor.colorFromRGBA(254, 228, 98)
            layer.borderColor = nil
            layer.borderWidth = 0
        } else {
            titleLabel.textColor = UIColor.colorFromRGBA(85, 85, 85)
            backgroundColor = UIColor.colorFromRGBA(254, 252, 235)
            layer.borderColor = UIColor.colorFromRGBA(187, 185, 174).cgColor
            layer.borderWidth = 1
        }
    }

}
