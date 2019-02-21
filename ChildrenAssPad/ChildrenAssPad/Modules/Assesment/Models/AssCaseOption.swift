//
//  AssCaseOption.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/9/30.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class AssCaseOption: NSObject, Mappable {
    
    let optionId: String
    let optionType: String
    let optionText: String
    let dimension: String
    let score: Int
    let caseId: String
    let image: String
    
    var isSelected = false
    
    required init?(jsonData: JSON) {
        optionId = jsonData["id"].stringValue
        optionType = jsonData["type"].stringValue
        optionText = jsonData["text"].stringValue
        dimension = jsonData["dimen"].stringValue
        score = jsonData["score"].intValue
        caseId = jsonData["caseId"].stringValue
        image = jsonData["image"].stringValue
        
        super.init()
    }
}
