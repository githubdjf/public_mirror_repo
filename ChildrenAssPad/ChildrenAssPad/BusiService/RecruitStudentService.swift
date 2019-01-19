//
//  RecruitStudentService.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/10/9.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Moya


class RecruitStudentService {}


//MARK: 获取招生测评的页签（paper）列表

extension RecruitStudentService {
    
    static func fetchRecruitStudentPaperList(withUserId userId: String, examId: String) -> Observable<[AssPaper]> {
        
        return  APIConfig.netProvider.rx.request(MultiTarget(RecruitStudentAPI.recruitStudentGetPaperList(userId: userId, examId: examId)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({response -> [AssPaper] in
                
                do{
                    
                    let respData = try JSON(data: response.data)
                    let paperData = try respData["data"].rawData()
                    let paperArray = try Mapper.mapToObjectArray(data: paperData, type: AssPaper.self)
                    return paperArray
                }
                catch{
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}


//MARK: 获取招生测评指定页签（paper）下的量表（branch）列表及详情

extension RecruitStudentService {
    
    static func fetchRecruitStudentBranchListUnderlyingPaper(withUserId userId: String, paperId: String, type: Int) -> Observable<[AssBranch]> {
        
        return  APIConfig.netProvider.rx.request(MultiTarget(RecruitStudentAPI.recruitStudentGetBranchListUnderlyingPaper(userId: userId, paperId: paperId, type: type)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({response -> [AssBranch] in
                
                do{
                    
                    let respData = try JSON(data: response.data)
                    let branchData = try respData["data"].rawData()
                    let branchArray = try Mapper.mapToObjectArray(data: branchData, type: AssBranch.self)
                    
                    return branchArray
                }
                catch{
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}


//MARK: 获取招生测评问题解答列表

extension RecruitStudentService {
    
    static func fetchRecruitStudentGetAssQuestionAnswerList(withUserId userId: String) -> Observable<[AssQuestionAnswer]> {
        
        return  APIConfig.netProvider.rx.request(MultiTarget(RecruitStudentAPI.recruitStudentGetAssQuestionAnswerList(userId: userId)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({response -> [AssQuestionAnswer] in
                
                do{
                    
                    let respData = try JSON(data: response.data)
                    let ansData = try respData["data"].rawData()
                    let answerArray = try Mapper.mapToObjectArray(data: ansData, type: AssQuestionAnswer.self)
                    
                    return answerArray
                }
                catch{
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}


//MARK: 保存招生测评答案

extension RecruitStudentService {
    
    static func saveRecruitStudentAssAnswer(_ answer: [String : Any]) -> Observable<StudentInfo> {
        
        return  APIConfig.netProvider.rx.request(MultiTarget(RecruitStudentAPI.recruitStudentSaveAssAnswer(answer: answer)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({response -> StudentInfo in
                
                do{
                    let respData = try JSON(data: response.data)
                    let infoData = try respData["data"].rawData()
                    let info = try Mapper.mapToObject(data: infoData, type: StudentInfo.self)
                    return info
                }
                catch{
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}



//MARK: 获取招生测评学生信息

extension RecruitStudentService {
    
    static func obtainStudentInfomation(babyName: String, babySex: String, babyBirthday: String, parentName: String, parentPhone: String) -> Observable<StudentInfo> {
        
        return  APIConfig.netProvider.rx.request(MultiTarget(RecruitStudentAPI.recruitStudentObtainInfo(babyName: babyName, babySex: babySex, babyBirthday: babyBirthday, parentName: parentName, parentPhone: parentPhone)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({response -> StudentInfo in
                
                do{
                    
                    let respData = try JSON(data: response.data)
                    let infoData = try respData["data"].rawData()
                    let info = try Mapper.mapToObject(data: infoData, type: StudentInfo.self)
                    
                    return info
                }
                catch{
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}
