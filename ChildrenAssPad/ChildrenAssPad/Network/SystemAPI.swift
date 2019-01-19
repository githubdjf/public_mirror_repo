//
//  SystemAPI.swift
//  zp_chu
//
//  Created by Jaffer on 2018/9/10.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import Moya


enum SystemAPI {
    
    /*
     * 版本更新
     * platformType: String 设备类型0:android,1:ios,2:ipad
     * appName: String App名称 czcp
     */
    case versionUpdate(platformType: String, appName: String)
}


extension SystemAPI: TargetType, Parameters {
    
    var baseURL: URL {
        
        return URL(string: APIConfig.defaultServer)!
    }
    
    
    var path: String {
        switch self {
        case .versionUpdate:
            return "bms/version/app/getVersionByType"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .versionUpdate:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        default:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var parameters: [String : Any] {
        
        switch self {
        case let .versionUpdate(platformType, appName):
            return ["type" : platformType, "appName" : appName]
            
        default:
            return [:]
        }
    }
    
    
    var headers: [String : String]? {
        
        return nil
    }
}

