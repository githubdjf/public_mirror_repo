//
//  String+Extension.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/17.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func textSize(byFont font: UIFont, breakMode mode: NSLineBreakMode, inSize size: CGSize) -> CGSize {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = mode
        
        let textAtt: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font,
                                                      NSAttributedString.Key.paragraphStyle : paragraphStyle]
        
        let textSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: textAtt, context: nil).size
        
        return textSize
    }

}
