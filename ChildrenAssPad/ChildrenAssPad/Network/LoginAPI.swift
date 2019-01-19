//
//  LoginAPI.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/22.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import Moya

enum LoginAPI  {
    
    
    //登录
    //account[string]: 账号
    //password[string]: 密码
    case login(account: String, password: String)
    
    //获取手机验证码
    //account：账号
    //phone：手机号
    case getVerifyCode(phone: String)
    
    //忘记密码
    //phone: 手机
    //password: 密码
    //captcha: 验证码
    case findPassword(phone: String, password: String, captcha: String)
    
    
    //手机号验证码登录
    //mobile[string]: 手机号
    //code[string]: 手机验证码
    case loginByVerifyPhoneCode(mobile: String, code: String)
    
    //绑定手机号
    //mobile[string]: 手机号
    //code[string]: 手机验证码
    case bindPhone(mobile: String, code: String)
    
    //上传头像
    case uploadAvatar(image: Data)
    
    //修改密码【修改初始密码、个人中心修改密码】
    //phone :  手机号
    //password :   密码
    //captcha:  验证码
    case changePassword(phone: String, password: String, captcha: String)
    
    //退出登录
    case safeLogout

    //修改学校
    //orgCode 切换的机构编码
    case changeLoginOrg(orgCode: String)
}


extension LoginAPI: TargetType, Parameters {
    
    var baseURL: URL {
        
        switch self {
        default:
            return URL(string: APIConfig.defaultServer)!
        }
    }


    var path: String {
        switch self {
        case .login:
            return "/yitai-fe/auth/login"
        case .findPassword:
            return "/yitai-fe/auth/getBackPassWord"
        case .getVerifyCode:
            return "/yitai-fe/auth/getVerifyCodeByPhone"
        case .loginByVerifyPhoneCode:
            return "bms/app/loginByMobileCode"
        case .changePassword:
            return "/yitai-fe/auth/updatePassWord"
        case .bindPhone:
            return "bms/app/bindMobile"
        case .uploadAvatar:
            return "bms/app/uploadProfilePicture"
        case .safeLogout:
            return "bms/app/logout"
        case .changeLoginOrg:
            return "bms/app/resetLoginOrg"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .safeLogout:
            return .requestPlain
        case let .uploadAvatar(image: data):
            let provider = MultipartFormData.FormDataProvider.data(data)
            let partName = "\(Int(Date().timeIntervalSince1970))"
            let fileName = partName + ".jpg"
            let part = MultipartFormData(provider: provider, name: "file", fileName: fileName, mimeType: "image/jpeg")
            return .uploadMultipart([part])
        default:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var parameters: [String : Any] {
        
        switch self {
        case let .login(account, password):
            
            return ["account" : account, "password" : password]
            
        case let .findPassword(phone, password, captcha):
            
            return ["phone": phone, "password" : password, "captcha": captcha]
            
        case let .getVerifyCode(phone):
            return ["phone" : phone]
            
        case let .loginByVerifyPhoneCode(mobile, code):
            
            return ["mobile" : mobile, "code" : code]
            
        case let .changePassword(phone, password, captcha):
            
            return ["phone": phone, "password": password, "captcha": captcha]

        case let .bindPhone(mobile, code):

            return ["mobile" : mobile, "code" : code]

        case let .changeLoginOrg(orgCode):

            return ["orgCode": orgCode]

        default:
            
            return [:]
        }
    }
    
    
    var headers: [String : String]? {
        
        return nil
    }
}
