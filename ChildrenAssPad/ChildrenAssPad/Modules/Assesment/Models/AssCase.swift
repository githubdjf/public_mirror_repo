//
//  AssCase.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/9/30.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class AssCase: NSObject, Mappable {
    
    let caseId: String
    let caseTitle: String
    let caseType: AssCaseType
    let caseImage: String
    let caseVideo: String
    let caseAudio: String
    let casePattern: AssCasePattern
    let branchId: String
    let selectedOptionId: String //多个时，“,”号分割
    let optionsArray: [AssCaseOption]
    let subCaseArray: [AssCase] //如果是组合题，此处存放子题
    
    required init?(jsonData: JSON) {
        caseId = jsonData["id"].stringValue
        caseTitle = jsonData["title"].stringValue
        caseType = AssCaseType(rawValue: jsonData["type"].intValue) ?? .singleSelection //默认单选
        caseImage = jsonData["image"].stringValue
        caseVideo = jsonData["vedio"].stringValue
        caseAudio = jsonData["audio"].stringValue
        casePattern = AssCasePattern(rawValue: jsonData["parten"].intValue) ?? .unknow
        branchId = jsonData["branchId"].stringValue
        selectedOptionId = jsonData["selId"].stringValue
        
        if let optionsArr = try? Mapper.mapToObjectArray(data: jsonData["selectionList"].rawData(), type: AssCaseOption.self) {
            optionsArray = optionsArr
        } else {
            optionsArray = [AssCaseOption]()
        }
        
        if let subCases = try? Mapper.mapToObjectArray(data: jsonData["subCaseList"].rawData(), type: AssCase.self) {
            subCaseArray = subCases
        } else {
            subCaseArray = [AssCase]()
        }
        
        super.init()
        
        //处理当前已选中的选项
        if optionsArray.count > 0 && selectedOptionId.count > 0 {
            
            let selectedOptionIdArr = selectedOptionId.components(separatedBy: ",")
            for optionId in selectedOptionIdArr {
                for option in optionsArray {
                    if optionId == option.optionId {
                        option.isSelected = true
                        break
                    }
                }
            }
        }
    }
    
    var curSelectedOptions: [AssCaseOption] {
        var selectedArr = [AssCaseOption]()
        for option in optionsArray {
            if option.isSelected {
                selectedArr.append(option)
            }
        }
        return selectedArr
    }
}
