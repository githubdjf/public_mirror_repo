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
    
    static func loadRecuritStudentPaperBranchesData(fromFile name: String) -> [AssBranch]? {
        
        var branchesArr: [AssBranch]?
        if let filePath = Bundle.main.path(forResource: name, ofType: ".json") {
            if let jsonData = try? JSON(data: Data(contentsOf: URL(fileURLWithPath: filePath))) {
                if let branches = try? Mapper.mapToObjectArray(data: jsonData["data"].rawData(), type: AssBranch.self) {
                    branchesArr = branches
                }
            }
        }
        return branchesArr
    }
    
    static func loadRecuritStuPapersData(fromFile name: String) -> [AssPaper]? {
        
        var papersArray: [AssPaper]?
        if let filePath = Bundle.main.path(forResource: name, ofType: ".json") {
            if let jsonData = try? JSON(data: Data(contentsOf: URL(fileURLWithPath: filePath))) {
                if let papers = try? Mapper.mapToObjectArray(data: jsonData["data"].rawData(), type: AssPaper.self) {
                    papersArray = papers
                }
            }
        }
        return papersArray
    }
}
