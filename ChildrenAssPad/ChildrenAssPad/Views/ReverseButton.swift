//
//  ReverseButton.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/10.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class ReverseButton: UIButton {

    fileprivate var titleRect: CGRect = .zero
    fileprivate var imageRect: CGRect = .zero
    fileprivate var contentRect: CGRect = .zero
    fileprivate var interSpaceX: CGFloat = 0
    
    init(frame: CGRect, spaceX: CGFloat = 0) {
        super.init(frame: frame)
        self.interSpaceX = spaceX
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        imageRect = super.imageRect(forContentRect: contentRect)
//        print("image rect==\(NSStringFromCGRect(imageRect))")
        if checkImageAndTitleLayoutValid() {
            
            let x: CGFloat = imageRect.minX + titleRect.width + self.interSpaceX
            let y = imageRect.minY
            let w = imageRect.width
            let h = imageRect.height
            let rect = CGRect(x: x, y: y, width: w, height: h)
            return rect
        }
        return imageRect
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        titleRect = super.titleRect(forContentRect: contentRect)
//        print("title rect==\(NSStringFromCGRect(titleRect))")
        if checkImageAndTitleLayoutValid() {
            
            let x: CGFloat = imageRect.minX
            let y = titleRect.minY
            let w = titleRect.width
            let h = titleRect.height
            let rect = CGRect(x: x, y: y, width: w, height: h)
            return rect
        }
        return titleRect
    }

    
    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        
        contentRect = super.contentRect(forBounds: bounds)
        return contentRect
    }
    
    
    fileprivate func checkImageAndTitleLayoutValid() -> Bool {
        
        return !imageRect.isEmpty && !titleRect.isEmpty && !contentRect.isEmpty
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        self.layoutSubviews()
    }
}
