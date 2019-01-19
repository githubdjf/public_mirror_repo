//
//  UserCenterAPI.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/10/9.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import Moya

enum UserCenterAPI  {

    case trialRecord(pageNo: Int, pageSize: Int, babyName: String?, startDate: String?, endDate: String?)

    case logout

}


extension UserCenterAPI: TargetType, Parameters {

    var baseURL: URL {

        switch self {
        default:
            return URL(string: APIConfig.defaultServer)!
        }
    }


    var path: String {
        switch self {
        case .trialRecord:
            return "/yitai-fe/evalution/getListByPage"

        case .logout:
            return "/yitai-fe/auth/logout"

        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        switch self {
//        case .safeLogout:

        default:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var parameters: [String : Any] {

        switch self {
        case let .trialRecord(pageNo, pageSize, babyName, startDate, endDate):

            return ["pageNo" : pageNo, "pageSize" : pageSize, "babyName" : babyName ?? "", "startDate" : startDate ?? "", "endDate" : endDate ?? ""]

        default:

            return [:]
        }
    }


    var headers: [String : String]? {

        return nil
    }
}
