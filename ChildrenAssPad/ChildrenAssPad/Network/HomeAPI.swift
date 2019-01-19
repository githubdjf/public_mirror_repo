//
//  HomeAPI.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/10/9.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import Moya


enum HomeAPI  {
    case displayHomeFunction
}


extension HomeAPI: TargetType, Parameters {
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: APIConfig.resServer)!
        }
    }
    
    
    var path: String {
        switch self {
        case .displayHomeFunction:
            return "/res_fe/exam/examList.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .displayHomeFunction:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .displayHomeFunction:
            return .requestPlain
        default:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var parameters: [String : Any] {
        
        switch self {
        default:
            return [:]
        }
    }
    
    
    var headers: [String : String]? {
        
        return nil
    }
}

