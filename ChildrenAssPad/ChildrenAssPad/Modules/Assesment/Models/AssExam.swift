//
//  AssExam.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/27.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class AssExam: NSObject, Mappable {

    var examId: String
    let paperArray: [AssPaper]
    
    required init?(jsonData: JSON) {
        examId = jsonData["id"].stringValue
        if let papers = try? Mapper.mapToObjectArray(data: jsonData["paperList"].rawData(), type: AssPaper.self) {
            paperArray = papers
        } else {
            paperArray = [AssPaper]()
        }
        
        super.init()
    }
}
