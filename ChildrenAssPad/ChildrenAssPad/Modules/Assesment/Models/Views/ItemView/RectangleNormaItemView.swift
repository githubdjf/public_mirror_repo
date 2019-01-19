//
//  RectangleNormaItemView.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/28.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 选项 - 普通圆角矩形显示选项内容，选中状态为绿色边框+绿色选项内容
 */

import UIKit

class RectangleNormaItemView: BaseItemView {
    
    static let rectangleNormaItemBaseTag = 100

    var indicatorLabel: UILabel!
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
    
    func initialize(withIndicatorTitle indicatorTitle: String, itemTitle title: String, titleFont font: UIFont, lineNumber: Int, breakMode: NSLineBreakMode, contentInset inset: UIEdgeInsets, isFixWidth: Bool, fixedWidth: CGFloat, minWidth: CGFloat, isFixHeight: Bool, fixedHeigth: CGFloat, minHeight: CGFloat) -> CGSize {
        
        let indicatorSize = CGSize(width: 22, height: 16)
        let spaceX: CGFloat = 0
        var itemSize: CGSize = .zero
        var titleSize: CGSize = .zero
        var needAlignCenter = false
        var alignY: CGFloat = inset.top
        
        if isFixWidth && isFixHeight {
            //宽高固定，以指定值为准，内容部分考虑inset缩进
            itemSize.width = fixedWidth
            itemSize.height = fixedHeigth
            titleSize = title.textSize(byFont: font, breakMode: breakMode, inSize: CGSize(width: fixedWidth - inset.left - inset.right - indicatorSize.width - spaceX, height: fixedHeigth - inset.top - inset.bottom))
            
            let contentHeight = inset.top + inset.bottom + titleSize.height
            alignY =  contentHeight < fixedHeigth ? ((fixedHeigth - contentHeight) / 2 + inset.top) : inset.top
            needAlignCenter = alignY != inset.top
            
        } else if !isFixWidth && isFixHeight {
            //高度固定，动态计算行宽
            titleSize = title.textSize(byFont: font, breakMode: breakMode, inSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeigth - inset.top - inset.bottom))
            let width = titleSize.width + inset.left + inset.right + indicatorSize.width + spaceX
            itemSize.width = minWidth > 0 ? max(minWidth, width) : width
            itemSize.height = fixedHeigth
            
            let contentHeight = inset.top + inset.bottom + titleSize.height
            alignY = contentHeight < fixedHeigth ? ((fixedHeigth - contentHeight) / 2 + inset.top) : inset.top
            needAlignCenter = alignY != inset.top

        } else if isFixWidth && !isFixHeight {
            //宽度固定，动态计算行高
            titleSize = title.textSize(byFont: font, breakMode: .byWordWrapping, inSize: CGSize(width: fixedWidth - inset.left - inset.right - indicatorSize.width - spaceX, height: CGFloat.greatestFiniteMagnitude))
            itemSize.width = fixedWidth
            let height = titleSize.height + inset.top + inset.bottom
            itemSize.height = minHeight > 0 ? max(minHeight, height) : height
            
            let contentHeight = inset.top + inset.bottom + titleSize.height
            alignY =  contentHeight < minHeight ? ((minHeight - contentHeight) / 2 + inset.top) : inset.top
            needAlignCenter = alignY != inset.top
        } else {
            print("cant not layout")
            itemSize = CGSize(width: fixedWidth, height: fixedHeigth)
        }
        
        let indicatorRect = CGRect(x: inset.left, y: inset.top, width: indicatorSize.width, height: indicatorSize.height)
        indicatorLabel = UILabel()
        indicatorLabel.frame = indicatorRect
        indicatorLabel.font = font
        indicatorLabel.numberOfLines = 1
        indicatorLabel.lineBreakMode = breakMode
        indicatorLabel.text = indicatorTitle
        addSubview(indicatorLabel)
        
//        let titleRect = CGRect(x: indicatorRect.maxX, y: inset.top, width: itemSize.width - inset.left - inset.right - indicatorSize.width - spaceX, height: itemSize.height - inset.top - inset.bottom)
        let titleRect = CGRect(x: indicatorRect.maxX, y: alignY, width: titleSize.width, height: titleSize.height)
        titleLabel = UILabel()
        titleLabel.frame = titleRect
        titleLabel.font = font
        titleLabel.numberOfLines = lineNumber
        titleLabel.lineBreakMode = breakMode
        titleLabel.text = title
        addSubview(titleLabel)
        
        //Align
        if needAlignCenter {
//            indicatorLabel.center.y = titleRect.midY
            indicatorLabel.frame.origin.y = titleRect.minY
        }
        
        let actionRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        actionButton = UIButton(type: .custom)
        actionButton.frame = actionRect
        actionButton.tag = RectangleNormaItemView.rectangleNormaItemBaseTag + itemIndex
        addSubview(actionButton)
        
        layer.borderWidth = 1
        layer.cornerRadius = 4
        layer.masksToBounds = true

        frame.size = itemSize
        
        return itemSize
    }
    
    override func setItemSelectedStatus(isSelected: Bool) {
        
        super.setItemSelectedStatus(isSelected: isSelected)
        
        if isSelected {
            layer.borderColor = UIColor.colorFromRGBA(6, 148, 121).cgColor
            titleLabel.textColor = UIColor.colorFromRGBA(6, 148, 121)
            indicatorLabel.textColor = UIColor.colorFromRGBA(6, 148, 121)
        } else {
            layer.borderColor = UIColor.colorFromRGBA(216, 216, 216).cgColor
            titleLabel.textColor = UIColor.colorFromRGBA(85, 85, 85)
            indicatorLabel.textColor = UIColor.colorFromRGBA(85, 85, 85)
        }
    }
}
