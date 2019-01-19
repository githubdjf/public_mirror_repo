//
//  UserCenterService.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/10/9.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import Moya

class UserCenterService: NSObject {

}


extension UserCenterService {

    //测评记录
    static func fetchTrialRecord(pageNo: Int, pageSize: Int, babyName: String?, startDate: String?, endDate: String?) -> Observable<(Int, [TrialRecordModel])> {

        return APIConfig.netProvider.rx.request(MultiTarget(UserCenterAPI.trialRecord(pageNo: pageNo, pageSize: pageSize, babyName: babyName, startDate: startDate, endDate: endDate)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({ (response) -> (Int, [TrialRecordModel]) in

                do {
                    let respData = try JSON(data: response.data)
                    let totalCount = respData["data"]["recordsTotal"].intValue
                    let recordData = try respData["data"]["data"].rawData()
                    let records = try Mapper.mapToObjectArray(data: recordData, type: TrialRecordModel.self)

                    return (totalCount, records)
                }
                catch  {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}


extension UserCenterService {

    //退出登录
    
    static func logOut() -> Observable<JSON> {

        return APIConfig.netProvider.rx.request(MultiTarget(UserCenterAPI.logout))
            .asObservable()
            .filterVerifyAndMapError()
            .map({ (response) -> JSON in

                do {

                    let respData = try JSON(data: response.data)
                    return respData
                }
                catch  {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}
