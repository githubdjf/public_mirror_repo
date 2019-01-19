//
//  LoginManager.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/21.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import CocoaLumberjack

struct LoginKey {
    struct UserKey {
        static let currentUserKey = "currentUser"
        static let loginTokenKey = "loginToken"
    }
}



@objc class LoginManager: NSObject {

    static let `default` = LoginManager()
    private var userInMemory: User?
    private var loginTokenInMemory: String?
    
    
    //MARK: Get Set
    
    var curUser: User? {
        get {
            let ud = UserDefaults.standard
            if userInMemory != nil {return userInMemory}
            var queryUser: User?
            if let tempUserData = ud.object(forKey: LoginKey.UserKey.currentUserKey) as? Data {
                queryUser = try? JSONDecoder().decode(User.self, from: tempUserData)
                userInMemory = queryUser
            }
            return queryUser
        }
        set(newUser) {
            let ud = UserDefaults.standard
            guard let newUser = newUser, let userData = try? JSONEncoder().encode(newUser)  else {
                ud.set(nil, forKey: LoginKey.UserKey.currentUserKey)
                ud.synchronize()
                userInMemory = nil
                return
            }
            ud.set(userData, forKey: LoginKey.UserKey.currentUserKey)
            ud.synchronize()
            userInMemory = newUser
        }
    }
    
    
    //MARK: Tools
    
    func appendUserIdentity(forKey key: String) -> String {
        
        let userId = self.curUser?.userId ?? ""
        return userId + "_" + key
    }
    
    //MARK: Cookie
    
    @objc static func saveCookies() {
        
        let storage = HTTPCookieStorage.shared
        if let cookieArray = storage.cookies {
            for cookie in cookieArray {
                if cookie.name == "token" {
                    let cookiePros = cookie.properties
                    let ud = UserDefaults.standard
                    ud.set(cookiePros, forKey: LoginKey.UserKey.loginTokenKey)
                    ud.synchronize()
                }
            }
        }
    }
    
    @objc static func setupCookies() {
        
        let ud = UserDefaults.standard
        if let cookiePros = ud.object(forKey: LoginKey.UserKey.loginTokenKey) as? [HTTPCookiePropertyKey : Any] {
            if let cookie = HTTPCookie(properties: cookiePros) {
                HTTPCookieStorage.shared.setCookie(cookie)
            } else {
                DDLogError("setupCookies==init cookie failed from properties=\(cookiePros)")
            }
        }
    }
    
    @objc static func cleanCookies() {
        
        //in storage
        let storage = HTTPCookieStorage.shared
        if let cookieArray = storage.cookies {
            for cookie in cookieArray {
                if cookie.name == "token" {
                    storage.deleteCookie(cookie)
                }
            }
        }
        
        //in file
        let ud = UserDefaults.standard
        ud.removeObject(forKey: LoginKey.UserKey.loginTokenKey)
    }
}


extension LoginManager {
    
    //clean user data cache
    func cleanUserCacheData() {

        //清空用户
        LoginManager.default.curUser = nil
        
        //清空cookie
        LoginManager.cleanCookies()
    }
}


extension LoginManager {

    //MARK: API
    
    //登录
    func login(userName: String, pwd: String) -> Observable<User> {
        
        return LoginService.login(account:userName, password:pwd)
    }
    
    //退出
    func logout() -> Observable<JSON> {
        
        return LoginService.logout()
    }
        
    //修改密码 【修改初始密码，个人中心修改密码】
    func resetPassword(phone: String, password: String, captcha: String) -> Observable<String> {
        
        return LoginService.changePassword(phone: phone, password: password, captcha: captcha)
    }
    
    //修改密码 【忘记密码，找回密码】
    func findPassword(phone: String, password: String, captcha: String) -> Observable<String> {
        
        return LoginService.findPassword(phone: phone, password: password, captcha: captcha)
    }
}
