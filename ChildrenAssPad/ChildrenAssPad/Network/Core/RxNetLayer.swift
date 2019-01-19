//
//  RxNetLayer.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/19.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya
import CocoaLumberjack
import MBProgressHUD

struct NetKey {
    
    struct ResponseKey {
        static let code = "code"
        static let msg = "message"
        static let data = "data"
    }
}

enum APPCode {
    
    enum BusiErrorCode: Int {
        case appDataErrorCode = 999 //数据错误
        case sessionInvalidCode = 201 //未登录
        case programErrorCode = 399 //应用级错误
        case paramsValidErrorCode = 400 //参数验证错误
        case undefinedErrorCode = 500 //未知错误
    }
    
    enum BusiSuccessCode: Int {
        case okCode = 200 //成功
    }
    
    case success(busiCode: BusiSuccessCode)
    case failure(busiCode: BusiErrorCode)
}


enum APPError: Swift.Error {
    case appSessionInvalidError(Swift.Error)
    case appProgramError(Swift.Error)
    case appParamsValidError(Swift.Error)
    case appUndefinedError(Swift.Error)
    case appDataError(Swift.Error)
}


extension APPError {
    
    static let appErrorDomain = "App.Error"
    
    func getErrorCode() -> Int {
        
        switch self {
        case APPError.appDataError:
            return APPCode.BusiErrorCode.appDataErrorCode.rawValue
        case .appSessionInvalidError:
            return APPCode.BusiErrorCode.sessionInvalidCode.rawValue
        case .appProgramError:
            return APPCode.BusiErrorCode.programErrorCode.rawValue
        case .appParamsValidError:
            return APPCode.BusiErrorCode.paramsValidErrorCode.rawValue
        case .appUndefinedError:
            return APPCode.BusiErrorCode.undefinedErrorCode.rawValue
        }
    }
}


extension APPError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .appDataError:
            return localStringForKey(key: "app_busi_appDataError")
        case .appSessionInvalidError:
            return localStringForKey(key: "app_busi_appSessionInvalidError")
        case .appProgramError:
            return localStringForKey(key: "app_busi_appProgramError")
        case .appParamsValidError:
            return localStringForKey(key: "app_busi_appParamsValidError")
        case .appUndefinedError:
            return localStringForKey(key: "app_busi_appUndefinedError")
        }
    }
}


struct APPErrorFactory {
    
    static func generateBusiError(busiCode code: APPCode.BusiErrorCode, errorMessage msg: String = localStringForKey(key: "app_busi_appDataError")) -> Swift.Error {
        
        let error = NSError(domain: APPError.appErrorDomain, code: code.rawValue, userInfo: ["message" : msg])
        return error as Error
    }
    
    static func unboxAndExtractErrorMessage(from error: Error) -> String {
        
        var msg = ""
        
        switch error {
        case let APPError.appDataError(err),
             let APPError.appProgramError(err),
             let APPError.appParamsValidError(err),
             let APPError.appUndefinedError(err):
            
            let nserror = err as NSError
            if let m = nserror.userInfo["message"] as? String {
                msg = m
            }
        
        case MoyaError.underlying(_):
            
            msg = localStringForKey(key: "message_net_unreachable")

        case MoyaError.statusCode(_):
            
            msg = localStringForKey(key: "message_status_code_error")
        
        default:
            if let e = error as? LocalizedError {
                msg = e.localizedDescription
            }
        }
        return msg
    }
}



extension ObservableType where E == Response {
    
    func filterVerifyAndMapError() -> Observable<E> {
        
        return self.filterSuccessfulStatusCodes()
            .verifyBusiError()
            .mapError()
    }
    
    func verifyBusiError() -> Observable<E> {
        
        return map { response in

            guard
                let responseJson = try? JSON(data: response.data),
                let responseCode = responseJson[NetKey.ResponseKey.code].int
            else {
                
                throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
            }
            
            if let req = response.request,let url = req.url, let res = response.response {            
                DDLogInfo("\n**【NetInfo---Response】**\n::ResponseURL=\(url)\n::ResponseRAW=\(res)\n::ResponseJSON=\(responseJson)\n==HTTPStatusInfo==::\n::HTTPCode=\(response.statusCode)\n")
            } else {
                DDLogError("**【NET ERROR】**")
            }
            
            let responseMessage = responseJson[NetKey.ResponseKey.msg].stringValue

            switch responseCode {
                
            case APPCode.BusiSuccessCode.okCode.rawValue:
                
                return response
            case APPCode.BusiErrorCode.sessionInvalidCode.rawValue:
                
                throw APPError.appSessionInvalidError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.sessionInvalidCode, errorMessage: responseMessage))
                
            case APPCode.BusiErrorCode.programErrorCode.rawValue:
                
                throw APPError.appProgramError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.programErrorCode, errorMessage: responseMessage))
                
            case APPCode.BusiErrorCode.paramsValidErrorCode.rawValue:
                
                throw APPError.appParamsValidError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.paramsValidErrorCode, errorMessage: responseMessage))
                
            case APPCode.BusiErrorCode.undefinedErrorCode.rawValue:
                
                throw APPError.appUndefinedError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.undefinedErrorCode, errorMessage: responseMessage))
                
            default:
                
                throw APPError.appUndefinedError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.undefinedErrorCode, errorMessage: responseMessage))

            }
            
        }
    }
    
    func mapError() -> Observable<E> {
        
        return catchError({ (error) -> Observable<Response> in
            
            let nserr = error as NSError
            DDLogError("\n**【NetError】**\n==Error==::\n::ErrorCode=\(nserr.code)\n::ErrorInfo=\(nserr.userInfo)\n::ErrorMessage=\(error.localizedDescription)\n")
            
            switch error {
            case APPError.appSessionInvalidError(let e):
                
                //TODO:
                //全局拦截超时登录
                print("session time out!! error=\(e)")
                if let window = Navigator.getRootWindow() {
                    let eMsg = APPErrorFactory.unboxAndExtractErrorMessage(from: error)
                    let hud = MBProgressHUD.showAdded(to: window, animated: true)
                    hud.mode = .text
                    hud.label.text = eMsg
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(animated: true, afterDelay: 2)
                    
                }
                
                //清空
                LoginManager.default.cleanUserCacheData()
                
                Navigator.shared.navigate(to: .loginPage, delay: 2)
                return Observable.empty()
            
//            case APPError.appProgramError(let code):
//            case APPError.appParamsValidError(let code):
//            case APPError.appUndefinedError(let code):
//            case APPError.appDataError:
//
//            case MoyaError.imageMapping(let response):
//            case MoyaError.jsonMapping(let response):
//            case MoyaError.stringMapping(let response):
//            case MoyaError.objectMapping(let e , let response):
//            case MoyaError.encodableMapping(let e):
//            case MoyaError.statusCode(let response):
//                return Observable.error(error)

//            case MoyaError.underlying(let e , let response):
//                return Observable.error(APPError.appProgramError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.programErrorCode)))
//                return Observable.error(MoyaError.jsonMapping(Response(statusCode: 0, data: Data())))
//            case MoyaError.requestMapping(let string):
//            case MoyaError.parameterEncoding(let e):
 
                
            default:
                return Observable.error(error)
            }
        })
    }
}




































