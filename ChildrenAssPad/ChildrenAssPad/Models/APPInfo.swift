//
//  AppInfo.swift
//  zp_chu
//
//  Created by Jaffer on 2018/9/10.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 {
 "code": 200,
 "data": {
 "appName": "czcp",
 "createTime": "2017-05-17 16:06:29",
 "downloadUrl": "http://res.yujingceping.com/app/android/oneTarget_2.1.6_20170515_release.apk",
 "id": 16,
 "isForceUpdate": 1,
 "type": 1,
 "versionCode": 10,
 "versionName": "2.1.6",
 "warning": "修复已知Bug，增强用户体验"
 },
 "message": "获取成功"
 }
 */

class APPInfo: NSObject, Mappable{

    let appName: String //czcp
    let downloadURL: String
    let isForceUpdateValue: String //是否是强制更新 0-否 1是
    let deviceTypeString: String //设备类型 0:android,1:ios,2:ipad
    let versionCode: String
    let versionName: String //如"2.2.2"
    let updateMessage: String //更新消息
    
    required init?(jsonData: JSON) {
        self.appName = jsonData["appName"].stringValue
        self.downloadURL = jsonData["downloadUrl"].stringValue
        self.isForceUpdateValue = jsonData["isForceUpdate"].stringValue
        self.deviceTypeString = jsonData["type"].stringValue
        self.versionCode = jsonData["versionCode"].stringValue
        self.versionName = jsonData["versionName"].stringValue
        self.updateMessage = jsonData["warning"].stringValue
    }
}
