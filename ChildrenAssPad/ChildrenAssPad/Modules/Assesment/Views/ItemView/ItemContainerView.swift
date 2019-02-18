//
//  ItemContainerView.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/28.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class ItemContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:宫格类型: 定宽 + 定高（可变高）
    
    func loadGridItems(_ items: [BaseItemView], columnCount: Int, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat) -> CGSize {
        
        var finalContainerSize = frame.size
        subviews.forEach{$0.removeFromSuperview()}

        guard items.count > 0 && columnCount > 0 else {
            return finalContainerSize
        }
        
        var x = containerInset.left
        var y = containerInset.top
        var maxItemHeight: CGFloat = 0
        
        for (idx, item) in items.enumerated() {
            if idx == 0 {
                //第一个
                item.frame.origin = CGPoint(x: x, y: y)
                x = x + item.frame.width + spaceX
            } else if idx % columnCount == 0 {
                //换行
                x = containerInset.left
                y = maxItemHeight + spaceY
                item.frame.origin = CGPoint(x: x, y: y)
                x = x + item.frame.width + spaceX
            } else {
                //同一行
                item.frame.origin = CGPoint(x: x, y: y)
                x = x + item.frame.width + spaceX
            }
            addSubview(item)
            maxItemHeight = max(maxItemHeight, item.frame.maxY)
        }
        
        finalContainerSize = CGSize(width: frame.width, height: maxItemHeight + containerInset.bottom)
        frame.size = finalContainerSize
        return finalContainerSize
    }

    
    //MARK: 左对齐: 定高 + 变宽
    
    func loadLeftAlignedItems(_ items: [BaseItemView], containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat) -> CGSize {
        
        var finalContainerSize = frame.size
        subviews.forEach{$0.removeFromSuperview()}
        
        guard items.count > 0 else {
            return finalContainerSize
        }
        
        var lastRect = CGRect.zero
        var x = containerInset.left
        var y = containerInset.top
        let maxWidth = self.frame.width
        let availableWidth = self.frame.width - containerInset.left - containerInset.right
        
        for (_, item) in items.enumerated() {
            
            let itemSize = item.frame.size
            
            if (x + itemSize.width + containerInset.right <= maxWidth) {
                //当前行可以放下item
                lastRect = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                //修改x y值
                x += (itemSize.width + spaceX)
            } else {
                //当前行放不下该item
                //此时分情况：该行目前是不是只有这个item，如果该item是此行的第一个，那么该item的最大宽度即为该行最大宽度；如果不是第一个，认为该行放不下该item，此时应该换行
                if x == containerInset.left {
                    //强制放在此行
                    lastRect = CGRect(x: x, y: y, width: availableWidth, height: itemSize.height)
                    //直接跳到下一行，修改x,y值
                    x = containerInset.left
                    y = lastRect.maxY + spaceY
                } else {
                    //换到下一行
                    x = containerInset.left
                    y += (itemSize.height + spaceY)
                    let w: CGFloat = (itemSize.width > availableWidth ? availableWidth : itemSize.width)
                    lastRect = CGRect(x: x, y: y, width: w, height: itemSize.height)
                    //修改x,y值
                    x += (w + spaceX)
                }
            }
            
            item.frame = lastRect
            addSubview(item)
        }
        
        finalContainerSize = CGSize(width: maxWidth, height: lastRect.maxY + containerInset.bottom)
        frame.size = finalContainerSize
        return finalContainerSize
    }
    
    //MARK: Clean
    
    func cleanSubViews() {
        subviews.forEach{$0.removeFromSuperview()}
    }
}
