//
//  User.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/20.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

//{"data":{"id":4,"account":"T7491422981","name":"测试用户（勿删）","phone":"15978857177","schoolId":749142298},"code":"200","message":"登录成功"}

class User: NSObject, Mappable, Codable {

    let userId: String
    let userName: String
    let account: String
    let phone: String
    let schoolId: String
    
    required init?(jsonData: JSON) {
        
        userId = jsonData["id"].stringValue
        userName = jsonData["name"].stringValue
        account = jsonData["account"].stringValue
        phone = jsonData["phone"].stringValue
        schoolId = jsonData["schoolId"].stringValue
    }
}











