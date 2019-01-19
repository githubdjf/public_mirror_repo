//
//  AssPaper.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/10/9.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class AssPaper: NSObject, Mappable {

    let paperId: String
    let paperName : String
    let examId: String
    let branchArray: [AssBranch]
    
    required init?(jsonData: JSON) {
        paperId = jsonData["id"].stringValue
        paperName = jsonData["name"].stringValue
        examId = jsonData["examId"].stringValue
        if let branches = try? Mapper.mapToObjectArray(data: jsonData["branchList"].rawData(), type: AssBranch.self) {
            branchArray = branches
        } else {
            branchArray = [AssBranch]()
        }
        
        super.init()
    }
}
