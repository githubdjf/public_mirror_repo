//
//  SystemService.swift
//  zp_chu
//
//  Created by Jaffer on 2018/9/10.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Moya


class SystemService {}


//MARK: 版本更新

extension SystemService {
    
    static func checkAppVersion(withDeviceTypeId deviceType: String = "1", appName: String = "czcp") -> Observable<APPInfo> {
        
        return  APIConfig.netProvider.rx.request(MultiTarget(SystemAPI.versionUpdate(platformType: deviceType, appName: appName)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({response -> APPInfo in
                
                do{
                    let respData = try JSON(data: response.data)
                    let infoData = try respData["data"].rawData()
                    let info = try Mapper.mapToObject(data: infoData, type: APPInfo.self)
                    
                    return info
                }
                catch{
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
                
            })
    }
}
