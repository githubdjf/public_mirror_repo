//
//  LoginService.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/20.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Moya



class LoginService {}


extension LoginService {
    
    //登录
    static func login(account: String, password: String) -> Observable<User> {
        
        return APIConfig.netProvider.rx.request(MultiTarget(LoginAPI.login(account: account, password: password)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({ (response) -> User in
                
                do {
                    
//                    //temp
//                    if let loginCookie = response.response?.allHeaderFields["Set-Cookie"] as? String? {
//                        LoginManager.default.curLoginToken = loginCookie
//                    }
                    
                    let repsData = try JSON(data: response.data)
                    let userData = try repsData["data"].rawData()
                    let user = try Mapper.mapToObject(data: userData, type: User.self)
                    return user
                }
                catch  {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}

extension LoginService {
    
    //退出登录
    static func logout() -> Observable<JSON> {
        
        return APIConfig.netProvider.rx.request(MultiTarget(LoginAPI.safeLogout))
            .asObservable()
            .filterVerifyAndMapError()
            .map{ response -> JSON in
                
                do {
                    let respData = try JSON(data: response.data)
                    return respData
                } catch {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            }
    }
}


extension LoginService {
    
    //修改密码
    static func changePassword(phone: String, password: String, captcha: String) -> Observable<String> {
        
        return APIConfig.netProvider.rx.request(MultiTarget(LoginAPI.changePassword(phone: phone, password: password, captcha: captcha)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({(response) -> String in
                
                do {
                    let respData = try JSON(data: response.data)
                    let mesg = respData["message"].stringValue
                    return mesg
                } catch {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })
    }
}

extension LoginService {
    
    //忘记密码
    static func findPassword(phone: String, password: String, captcha: String) -> Observable<String> {
        
        return APIConfig.netProvider.rx.request(MultiTarget(LoginAPI.findPassword(phone: phone, password: password, captcha: captcha)))
            .asObservable()
            .filterVerifyAndMapError()
            .map {response -> String in
                
                do {
                    let respData = try JSON(data: response.data)
                    let mesg = respData["message"].stringValue
                    return mesg
                } catch {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
        }
    }
}

extension LoginService {

    //获取验证码
    static func getVerifyCode(phone: String) -> Observable<String> {

        return APIConfig.netProvider.rx.request(MultiTarget(LoginAPI.getVerifyCode(phone: phone)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({(response) -> String in

                do {
                    let respData = try JSON(data: response.data)
                    let mesg = respData["message"].stringValue
                    return mesg
                }catch {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }


            })
    }

}


extension LoginService {

    //手机号验证码登陆
    static func loginByVerifyPhoneCode(mobile: String, code: String) -> Observable<User>{

        return APIConfig.netProvider.rx.request(MultiTarget(LoginAPI.loginByVerifyPhoneCode(mobile: mobile, code: code)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({ (response) -> User in

                do {
                    let repsData = try JSON(data: response.data)
                    let userData = try repsData["data"].rawData()
                    let user = try Mapper.mapToObject(data: userData, type: User.self)
                    return user
                }
                catch  {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }
            })

    }

}

extension LoginService {

    //绑定手机号
    static func bindPhone(mobile: String, code: String) -> Observable<JSON>{

        return APIConfig.netProvider.rx.request(MultiTarget(LoginAPI.bindPhone(mobile: mobile, code: code)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({(response) -> JSON in

                do {
                    let respData = try JSON(data: response.data)
                    return respData
                }catch {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }


            })
    }

}

extension LoginService {
    //上传头像

    static func uploadAvatar(image: Data) -> Observable<JSON>{

        return APIConfig.netProvider.rx.request(MultiTarget(LoginAPI.uploadAvatar(image: image)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({(response) -> JSON in

                do {
                    let respData = try JSON(data: response.data)
                    return respData
                }catch {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }

            })
    }

}

extension LoginService {
    //修改登录机构

    static func changeLoginOrg(orgCode: String) -> Observable<JSON>{

        return APIConfig.netProvider.rx.request(MultiTarget(LoginAPI.changeLoginOrg(orgCode: orgCode)))
            .asObservable()
            .filterVerifyAndMapError()
            .map({(response) -> JSON in

                do {
                    let respData = try JSON(data: response.data)
                    return respData

                }catch {
                    throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                }

            })
    }

}
