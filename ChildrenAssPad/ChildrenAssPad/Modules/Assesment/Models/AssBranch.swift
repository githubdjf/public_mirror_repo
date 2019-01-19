//
//  AssBranch.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/9/30.
//  Copyright © 2018年 yitai. All rights reserved.
//


import UIKit
import SwiftyJSON

class AssBranch: NSObject, Mappable {
    
    let branchId: String
    let branchName: String
    let paperId: String
    let branchTypeString: String
    let isFinishedValue: Int
    let caseListArray: [AssCase]
    
    required init?(jsonData: JSON) {
        branchId = jsonData["id"].stringValue
        branchName = jsonData["name"].stringValue
        paperId = jsonData["paperId"].stringValue
        branchTypeString = jsonData["type"].stringValue
        isFinishedValue = jsonData["isFinished"].intValue
        
        if let caseArray = try? Mapper.mapToObjectArray(data: jsonData["paperCaseList"].rawData(), type: AssCase.self) {
            caseListArray = caseArray
        } else {
            caseListArray = [AssCase]()
        }
        
//        //fake
//        let arr1: [AssCase]
//        if let caseArray = try? Mapper.mapToObjectArray(data: jsonData["paperCaseList"].rawData(), type: AssCase.self) {
//            arr1 = caseArray
//        } else {
//            arr1 = [AssCase]()
//        }
//
//        let arr2: [AssCase]
//        if let caseArray = try? Mapper.mapToObjectArray(data: jsonData["paperCaseList"].rawData(), type: AssCase.self) {
//            arr2 = caseArray
//        } else {
//            //caseListArray = [AssCase]()
//            arr2 = [AssCase]()
//        }
//        caseListArray = arr1 + arr2
        
        super.init()
    }
}
