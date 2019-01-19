//
//  RecruitStudentAPI.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/10/9.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import CocoaLumberjack

enum RecruitStudentAPI  {
    
    /*
     * 获取招生测评的页签（paper）列表
     * userId: [String], 当前采集学生的id
     * examId: [String], 当前量表id
     */
    case recruitStudentGetPaperList(userId: String, examId: String)
    
    /*
     * 获取招生测评指定页签（paper）下的量表（branch）列表及详情
     * userId: [String], 当前采集学生的id
     * paperId: [String], 当前paper id
     * type: [Int], 当前获取类型，基础信息：“default = 0”、“teacher = 1”、“parents = 2”
     */
    case recruitStudentGetBranchListUnderlyingPaper(userId: String, paperId: String, type: Int)
    
    /*
     * 获取招生测评问题解答列表
     * userId: [String], 当前测评学学生的id
     */
    case recruitStudentGetAssQuestionAnswerList(userId: String)
    
    /*
     * 保存招生测评答案
     * answer: [String : Any]
     */
    case recruitStudentSaveAssAnswer(answer: [String : Any])
    
    
    case recruitStudentObtainInfo(babyName: String, babySex: String, babyBirthday: String, parentName: String, parentPhone: String)

}

extension RecruitStudentAPI: TargetType, Parameters {
    
    var baseURL: URL {
        
        switch self {
        default:
            return URL(string: APIConfig.defaultServer)!
        }
    }
    
    
    var path: String {
        switch self {
        case .recruitStudentGetPaperList:
            return "/yitai-fe/exam/getPaperList"
        
        case .recruitStudentGetBranchListUnderlyingPaper:
            return "/yitai-fe/exam/getBranchList"
            
        case .recruitStudentGetAssQuestionAnswerList:
            return "/yitai-fe/exam/getExplain"
            
        case .recruitStudentSaveAssAnswer:
            return "/yitai-fe/answerRecord/saveAnswerRecord"
            
        case .recruitStudentObtainInfo:
            return "/yitai-fe/evalution/insert"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recruitStudentGetPaperList:
            return .get
            
        case .recruitStudentGetBranchListUnderlyingPaper:
            return .get
            
        case .recruitStudentGetAssQuestionAnswerList:
            return .get
            
        case .recruitStudentSaveAssAnswer:
            return .post
            
        case .recruitStudentObtainInfo:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
//        case let .recruitStudentSaveAssAnswer(answer):
//            let parameterEncoding = URLEncoding(destination: .httpBody)
//            return .requestCompositeParameters(bodyParameters: answer, bodyEncoding: parameterEncoding, urlParameters: [:])
////            if let jsonData = try? JSON(answer).rawData() {
////                print("")
////                return .requestCompositeData(bodyData: jsonData, urlParameters: [:])
////            } else {
////                DDLogError("if let jsonData = try? JSON(answer).rawData(),error!")
////                return .requestPlain
////            }
        default:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var parameters: [String : Any] {
        
        switch self {
        case let .recruitStudentGetPaperList(userId, examId):
            var params = [String : Any]()
            params["userId"] = userId
            params["examId"] = examId
            return params
        
        case let .recruitStudentGetBranchListUnderlyingPaper(userId, paperId, type):
            var params = [String : Any]()
            params["userId"] = userId
            params["paperId"] = paperId
            params["type"] = type
            return params
            
        case let .recruitStudentGetAssQuestionAnswerList(userId):
            var params = [String : Any]()
            params["userId"] = userId
            return params
            
        case let .recruitStudentSaveAssAnswer(answer):
//            var params = [String : Any]()
//            let jsonStr = JSON(answer).rawString() ?? ""
//            params["answerRecordVo"] = jsonStr
            return answer
            
        case let .recruitStudentObtainInfo(babyName, babySex, babyBirthday, parentName, parentPhone):
            var para = [String: Any]()
            para["babyName"] = babyName
            para["babySex"] = babySex
            para["babyBirthday"] = babyBirthday
            para["parentName"] = parentName
            para["parentPhone"] = parentPhone
            return para
        
        default:
            return [:]
        }
    }
    
    var headers: [String : String]? {
        
        return nil
    }
}


