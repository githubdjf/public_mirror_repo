//
//  StudentInfo.swift
//  FirstEducation
//
//  Created by 译泰视觉 on 2018/10/10.
//  Copyright © 2018 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class StudentInfo: NSObject, Mappable {

    let id: Int
    let babyName: String
    let babySex: String
    let babyBirthday: String
    let parentName: String
    let parentPhone: String
    let reportHtml: String
    let isFinish: Int
    let teacherId: Int
    let trialDate: String
    
    required init?(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.babyName = jsonData["babyName"].stringValue
        self.babySex = jsonData["babySex"].stringValue
        self.babyBirthday = jsonData["babyBirthday"].stringValue
        self.parentName = jsonData["parentName"].stringValue
        self.parentPhone = jsonData["parentPhone"].stringValue
        self.reportHtml = jsonData["reportHtml"].stringValue
        self.isFinish = jsonData["isFinish"].intValue
        self.teacherId = jsonData["teacherId"].intValue
        self.trialDate = jsonData["trialDate"].stringValue
    }
}
