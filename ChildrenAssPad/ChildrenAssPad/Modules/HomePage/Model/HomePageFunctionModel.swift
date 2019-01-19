//
//  HomePageFunctionModel.swift
//  FirstEducation
//
//  Created by 译泰视觉 on 2018/9/30.
//  Copyright © 2018 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomePageFunctionModel: NSObject, Mappable {
    
    let id: Int
    let name: String
    let isCan: Int
    
    
    required init?(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.name = jsonData["name"].stringValue
        self.isCan = jsonData["isCan"].intValue
    }

}
