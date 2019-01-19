//
//  HomeService.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/10/9.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Moya

class HomeService: NSObject {
    
}

extension HomeService {
    static func displayHomeFunction() -> Observable<[HomePageFunctionModel]> {
        return APIConfig.netProvider.rx.request(MultiTarget(HomeAPI.displayHomeFunction))
        .asObservable()
        .filterVerifyAndMapError()
            .map({ (response) -> [HomePageFunctionModel] in
                do {
                    let respData = try JSON(data: response.data)
                    let funcData = try respData["data"].rawData()
                    let funcArray = try Mapper.mapToObjectArray(data: funcData, type: HomePageFunctionModel.self)
                    return funcArray
                } catch {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}



