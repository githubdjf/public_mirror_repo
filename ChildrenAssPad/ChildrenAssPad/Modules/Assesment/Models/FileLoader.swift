//
//  FileLoader.swift
//  YuJing3_Teacher
//
//  Created by Jaffer on 2018/11/14.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class FileLoader: NSObject {
    
    static func loadExamData(fromFile name: String) -> AssExam? {
        var model: AssExam?
        if let filePath = Bundle.main.path(forResource: name, ofType: ".json") {
            if let jsonData = try? JSON(data: Data(contentsOf: URL(fileURLWithPath: filePath))) {
                model = AssExam(jsonData: jsonData)
            }
        }
        return model
    }
}
