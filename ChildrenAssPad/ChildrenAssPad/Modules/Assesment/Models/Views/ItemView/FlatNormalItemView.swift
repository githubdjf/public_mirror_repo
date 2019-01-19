//
//  FlatNormalItemView.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/28.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 选项，无框，纯文字
 */


import UIKit

class FlatNormalItemView: BaseItemView {

    static let flatNormalItemViewBaseTag = 100

    var titleLabel: UILabel!
    var actionButton: UIButton!
    
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
    
    func initialize(withItemTitle title: String, titleFont font: UIFont, lineNumber: Int, breakMode: NSLineBreakMode,  contentInset inset: UIEdgeInsets, fixWidth: Bool, fixedWidth: CGFloat, fixHeight: Bool, fixedHeigth: CGFloat) -> CGSize {
        
        var itemSize: CGSize = .zero
        if fixWidth && fixHeight {
            //宽高固定，以指定值为准，内容部分考虑inset缩进
            itemSize.width = fixedWidth
            itemSize.height = fixedHeigth
            
        } else if !fixWidth && fixHeight {
            //高度固定，动态计算行宽
            let titleSize = title.textSize(byFont: font, breakMode: breakMode, inSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeigth))
            itemSize.width = titleSize.width + inset.left + inset.right
            itemSize.height = fixedHeigth
            
        } else if fixWidth && !fixHeight {
            //宽度固定，动态计算行高
            let titleSize = title.textSize(byFont: font, breakMode: .byWordWrapping, inSize: CGSize(width: fixedWidth - inset.left - inset.right, height: CGFloat.greatestFiniteMagnitude))
            itemSize.width = fixedWidth
            itemSize.height = titleSize.height + inset.top + inset.bottom
            
        } else {
            print("cant not layout")
            itemSize = CGSize(width: fixedWidth, height: fixedHeigth)
        }
        
        let titleRect = CGRect(x: inset.left, y: inset.top, width: itemSize.width - inset.left - inset.right, height: itemSize.height - inset.top - inset.bottom)
        titleLabel = UILabel()
        titleLabel.frame = titleRect
        titleLabel.font = font
        titleLabel.numberOfLines = lineNumber
        titleLabel.lineBreakMode = breakMode
        titleLabel.text = title
        addSubview(titleLabel)
        
        let actionRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        actionButton = UIButton(type: .custom)
        actionButton.frame = actionRect
        actionButton.tag = FlatNormalItemView.flatNormalItemViewBaseTag + itemIndex
        addSubview(actionButton)
        
        frame.size = itemSize
        
        return itemSize
    }
    
    override func setItemSelectedStatus(isSelected: Bool) {
        
        super.setItemSelectedStatus(isSelected: isSelected)
        
//        if isSelected {
//            layer.borderColor = UIColor.colorFromRGBA(6, 148, 121).cgColor
//            titleLabel.textColor = UIColor.colorFromRGBA(6, 148, 121)
//        } else {
//            layer.borderColor = UIColor.colorFromRGBA(85, 85, 85).cgColor
//            titleLabel.textColor = UIColor.colorFromRGBA(85, 85, 85)
//        }
    }
}
