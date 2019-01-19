//
//  LeftAlignedContainerView.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/17.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

protocol ItemProtocol { var displayTitle: String {get} }


fileprivate let itemBaseTage = 1000

class ItemView: UIView {
    let itemIndex: Int
    let maxWidth: CGFloat
    var itemTitle: String = ""
    var itemButton: UIButton!
    
    init(frame: CGRect, index: Int, maxWidth: CGFloat) {
        self.itemIndex = index
        self.maxWidth = maxWidth
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(withItemTitle title: String, titleFont font: UIFont, titleColor textColor: UIColor, contentInset inset: UIEdgeInsets, fixedWidth: CGFloat, fixedHeight: CGFloat,borderColor: UIColor?, borderWidth: CGFloat,radius: CGFloat, compactable compact: Bool) -> CGSize {
        
        self.itemTitle = title
        var itemSize = CGSize.zero
        if title.isEmpty {return itemSize}
        
        //如果compact是yes，此时根据fixedwidth 和 fixedheight来决定哪个方向是紧包裹（值<＝0 认为是紧包裹）
        //如果compact是no，此时忽略inset，直接使用fixedwidth 和 fixedheight
        if compact == false {
            itemSize.width = min(self.maxWidth, fixedWidth)
            itemSize.height = fixedHeight
        } else {
            let titleSize = title.textSize(byFont: font, breakMode: .byWordWrapping, inSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height))
            itemSize.width = min(titleSize.width + inset.left + inset.right, self.maxWidth)
            itemSize.height = self.frame.height
        }
        
        let itemButtonRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        self.itemButton = UIButton(type: .custom)
        if compact { self.itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: inset.left, bottom: 0, right: inset.right)}
        self.itemButton.titleLabel?.font = font
        self.itemButton.setTitle(itemTitle, for: .normal)
        self.itemButton.setTitleColor(textColor, for: .normal)
        self.itemButton.frame = itemButtonRect
        self.itemButton.tag = self.itemIndex + itemBaseTage
        self.itemButton.layer.borderColor = borderColor?.cgColor
        self.itemButton.layer.borderWidth = borderWidth
        self.itemButton.layer.cornerRadius = radius
        self.itemButton.layer.masksToBounds = true
        self.itemButton.titleLabel?.lineBreakMode = .byTruncatingTail
        addSubview(self.itemButton)
        
        self.frame.size = itemSize
        
        return itemSize
    }
}


class LeftAlignedContainerView: UIView {

    typealias SelectCallback = (Int,ItemView) -> Void
    
    var itemViewsArr = [ItemView]()
    var selectAtIndex: SelectCallback?
    var curIndex : Int?{
        didSet{

            if !(curIndex! > itemViewsArr.count) {

                //let itemView = itemViewsArr[curIndex!]
                //itemView.itemButton.backgroundColor = UIColor.mainColor
                //itemView.itemButton.setTitleColor(UIColor.white, for: .normal)

            }
        }
    }

    func initialize(withItems items:[ItemProtocol], titleFont font: UIFont, titleColor textColor: UIColor, fixedHeight itemHeight: CGFloat, fixedWidth itemWidth: CGFloat, containerInset: UIEdgeInsets, itemInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat, borderColor: UIColor?, borderWidth: CGFloat,radius: CGFloat, compactable compact: Bool) -> CGSize {

        itemViewsArr.removeAll()
        self.subviews.forEach{$0.removeFromSuperview()}

        if items.isEmpty {return self.frame.size}

        var lastRect = CGRect.zero
        var x = containerInset.left
        var y = containerInset.top
        let maxWidth = self.frame.width
        let availableWidth = self.frame.width - containerInset.left - containerInset.right
        let itemWidthDefault: CGFloat = 100.0
        var itemTitle = ""

//        self.backgroundColor = UIColor.yellow
        
        for i in 0..<items.count {
            itemTitle = items[i].displayTitle
            if itemTitle.isEmpty {continue}
            let itemView = ItemView(frame: CGRect(x: 0, y: 0, width: itemWidthDefault, height: itemHeight), index: i, maxWidth: availableWidth)

            let itemSize = itemView.initialize(withItemTitle: itemTitle, titleFont: font, titleColor: textColor, contentInset: itemInset, fixedWidth: itemWidth, fixedHeight: itemHeight, borderColor: borderColor, borderWidth: borderWidth, radius: radius, compactable: compact)
            
//            itemView.backgroundColor = UIColor.green
//            itemView.itemButton.backgroundColor = UIColor.red

            itemView.itemButton.addTarget(self, action: #selector(clickItem(button:)), for: .touchUpInside)

//            if (x + itemSize.width + containerInset.right <= availableWidth) {
            if (x + itemSize.width + containerInset.right <= maxWidth) {
                //当前行可以放下item
                lastRect = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                //修改x y值
                x += (itemSize.width + spaceX)
            } else {
                //当前行放不下该item,需要换行
                //此时分情况：该行目前是不是只有这个item，如果该item是此行的第一个，那么该tag的最大宽度即为改行最大宽度；如果不是第一个，认为该行放不下该item，此时应该换行
                if x == containerInset.left {
                    //强制放在此行
//                    lastRect = CGRect(x: x, y: y, width: availableWidth - x - containerInset.right, height: itemSize.height)
                    lastRect = CGRect(x: x, y: y, width: availableWidth, height: itemSize.height)
                    //直接跳到下一行，修改x,y值
                    x = containerInset.left
                    y = lastRect.maxY + spaceY
                } else {
                    //换到下一行
                    x = containerInset.left
                    y += (itemSize.height + spaceY)
//                    let w: CGFloat = (itemSize.width > availableWidth - x - containerInset.right ? availableWidth - x - containerInset.right : itemSize.width)
                    let w: CGFloat = (itemSize.width > availableWidth ? availableWidth : itemSize.width)
                    lastRect = CGRect(x: x, y: y, width: w, height: itemSize.height)
                    //修改x,y值
                    x += (w + spaceX)
                }
            }
            itemView.frame = lastRect
            addSubview(itemView)
            itemViewsArr.append(itemView)
        }
        let finalHeight: CGFloat = lastRect.maxY + containerInset.bottom
        self.frame.size.height = finalHeight

        return self.frame.size
    }

    
    func initialize(withItems items:[ItemProtocol], titleFont font: UIFont, titleColor textColor: UIColor, fixedHeight itemHeight: CGFloat, fixedWidth itemWidth: CGFloat, containerInset: UIEdgeInsets, itemInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat, compactable compact: Bool) -> CGSize {


        return self.initialize(withItems: items, titleFont: font, titleColor: textColor, fixedHeight: itemHeight, fixedWidth: itemWidth, containerInset: containerInset, itemInset: itemInset, spaceX: spaceX, spaceY: spaceY, borderColor: nil, borderWidth: 0, radius: 0, compactable: compact)
    }
    
    @objc func clickItem(button: UIButton) {
        
        let index = button.tag - itemBaseTage
        curIndex = index
        let itemView = itemViewsArr[index]
        
        if let selectCallback = self.selectAtIndex {
            selectCallback(index,itemView)
        }
    }
}


























