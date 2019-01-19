//
//  APIConfig.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/19.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import Moya
import CocoaLumberjack


protocol Parameters {
    var parameters: [String : Any] {get}
}



class APIConfig : NSObject {
    
    //MARK: Provider
    
    static let netProvider = MoyaProvider<MultiTarget>(endpointClosure: APIConfig.endpointer, requestClosure: APIConfig.requester, manager: APIConfig.alamofireManager())
    
    
    //MARK: Server

     static let defaultServer = "http://101.132.106.195:8090"
//    static let defaultServer = "http://192.168.20.229:8080"

     static let resServer = "http://res.yujingceping.com"

    
    //MARK: Public parameters
    //client info 0:iOS 1:Android
    static var publicParameters: [String : String] {
        var params = [String : String]()
        params["client"] = "0"
        return params
    }
}


extension APIConfig {
    
    class func endpointer(for target: MultiTarget) -> Endpoint {
        var endPoint = Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        endPoint = endPoint.adding(newHTTPHeaderFields: APIConfig.publicParameters)
        
        var paramsDict = [String : Any]()
        if let params = target.target as? Parameters {
            paramsDict = params.parameters
        }
        DDLogInfo("\n**【NetInfo---Request】**\n::RequestURL=\(endPoint.url)\n::RequestMethod=\(endPoint.method)\n::RequestHeaders=\(endPoint.httpHeaderFields ?? [:])\n::RequestParameters=\(paramsDict)")
        return endPoint
    }
    
    class func requester(for endpoint: Endpoint, closure: MoyaProvider<MultiTarget>.RequestResultClosure) {
        do {
            var urlRequest = try endpoint.urlRequest()
            urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            closure(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    class func alamofireManager() -> Manager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
    }
}

