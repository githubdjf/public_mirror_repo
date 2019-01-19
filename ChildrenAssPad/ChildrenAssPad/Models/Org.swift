//
//  Org.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/20.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class Org: NSObject, Mappable, Codable {
    
    let orgId: String
    let isEnable: String
    let name: String
    let orgCode: String
    let parentCode: String
    let type: Int
    
    required init?(jsonData: JSON) {
        
        self.orgId = "\(jsonData["id"].int64Value)"
        self.isEnable = jsonData["isEnable"].stringValue
        self.name = jsonData["name"].stringValue
        self.orgCode = "\(jsonData["orgCode"].int64Value)"
        self.parentCode = "\(jsonData["parentCode"].int64Value)"
        self.type = jsonData["type"].intValue
    }
}
