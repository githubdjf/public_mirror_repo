//
//  TrialRecordModel.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/10/9.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrialRecordModel: NSObject, Mappable {

    enum Sex : Int {
       case male = 1
       case female
    }


//    "id": 1,
//    "babyName": "Alice",
//    "babySex": "1",
//    "babyBirthday": "2018-05-12",
//    "parentName": "Mark",
//    "parentPhone": "18845141796",
//    "reportHtml": null,
//    "isFinish": 0,
//    "teacherId": 4,
//    "trialDate": "2018-09-16",
//    "createTime": "2018-09-29 17:36:07.0"

    let recordID : String
    let babyName : String
    let babySex: Sex
    let babyBirthday: String
    let parentName: String
    let parentPhone: String
    let reportHtml: String
    let isFinish: Bool
    let teacherId: String
    let trialDate: String
    let createTime: String


    required init?(jsonData: JSON) {

        recordID = jsonData["id"].stringValue
        babyName = jsonData["babyName"].stringValue
        babySex = Sex.init(rawValue: jsonData["babySex"].intValue) ?? .male
        babyBirthday = jsonData["babyBirthday"].stringValue
        parentName = jsonData["parentName"].stringValue
        parentPhone = jsonData["parentPhone"].stringValue
        reportHtml = jsonData["reportHtml"].stringValue
        isFinish = jsonData["isFinish"].boolValue
        teacherId = jsonData["teacherId"].stringValue
        trialDate = jsonData["trialDate"].stringValue
        createTime = jsonData["createTime"].stringValue
    }

}
