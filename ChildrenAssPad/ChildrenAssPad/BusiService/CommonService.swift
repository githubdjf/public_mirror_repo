//
//  CommonService.swift
//  zp_chu
//
//  Created by Jaffer on 2018/8/7.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Moya

class CommonService{}


//MARK: 上传图片

extension CommonService {
    
    //图片上传
    // [
    //     {
    //        partName : "some name",
    //        partFiles : [
    //                      {fileName: "", imageData: someData, mimeType : some type}
    //                    ]
    //      }
    // ]
    class func uploadImages(_ images: [[String : Any]], params: [String : Any]?) -> Observable<[JSON]> {
        
        return APIConfig.netProvider.rx.request(MultiTarget(CommonAPI.uploadImages(imageInfos: images, parameters: params)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({ (response) -> [JSON] in
                
                do {
                    let respData = try JSON(data: response.data)
                    let filesData = respData["data"].arrayValue
                    return filesData
                } catch {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}











