//
//  AssQuestionAnswer.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/10/11.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON


class AssQuestionAnswer: NSObject, Mappable {
    
    let id: String
    let content: String
    let type: Int
    
    required init?(jsonData: JSON) {
        id = jsonData["id"].stringValue
        content = jsonData["content"].stringValue
        type = jsonData["type"].intValue
    }
}
