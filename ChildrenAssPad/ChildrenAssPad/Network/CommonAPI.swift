//
//  CommonAPI.swift
//  zp_chu
//
//  Created by Jaffer on 2018/8/7.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import Moya


enum CommonAPI  {
    
    //图片上传
    // [
    //     {
    //        partName : "some name",
    //        partFiles : [
    //                      {fileName: "", imageData: someData, mimeType : some type}
    //                    ]
    //      }
    
    // ]
    case uploadImages(imageInfos: [[String : Any]], parameters: [String : Any]?)
}


extension CommonAPI: TargetType, Parameters {
    
    var baseURL: URL {
        
        return URL(string: APIConfig.defaultServer)!
    }
    
    var path: String {
        
        var p: String
        switch self {
        case .uploadImages:
            p = "mces/app/file/uploadFile"
        }
        return p
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case let .uploadImages(imageSource, parameters):
            
            var parts = [MultipartFormData]()
            
            for dict in imageSource {
                guard
                    let partName = dict["partName"] as? String,
                    let partFilesArray = dict["partFiles"] as? Array<[String : Any]>
                else {
                     print("ERROR!!!")
                    continue
                }
                
                for file in partFilesArray {
                    guard
                        let fileName = file["fileName"] as? String,
                        let fileData = file["imageData"] as? Data
                    else {
                        print("ERROR!!!")
                        continue
                    }
                    
                    //默认类型处理
                    var mimeType = "image/jpeg"
                    if let type = file["mimeType"] as? String {
                        mimeType = type
                    }
                    
                    let part = MultipartFormData(provider: .data(fileData), name: partName, fileName: fileName, mimeType: mimeType)
                    parts.append(part)
                }
            }
            
            if let params = parameters {
                
                return .uploadCompositeMultipart(parts, urlParameters: params)
            } else {
                
                return .uploadMultipart(parts)
            }
            
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

