//
//  Navigator.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/21.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit


class Navigator: NSObject {
    
    enum NavigateType: Int {
        case loginPage
        case homePage
    }
        
    static let shared = Navigator()
    
    var curNavigateType: NavigateType = .homePage
    
    //MARK: Navi
    
    func navigate(to type: NavigateType, delay: TimeInterval = 0) {
        
        guard let curWindow = Navigator.getRootWindow() else { return }
        
        curNavigateType = type
        
        var root: UIViewController = UIViewController()
        
        switch type {
        case .loginPage:
            
            let loginVC = SignInViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            root = nav as UIViewController
            print("do")
        case .homePage:
            
            let homeVC = HomepageFunctionViewController()
            let nav = UINavigationController(rootViewController: homeVC)
            root = nav as UIViewController
            print("do")
        }
        
        if delay <= 0 {
            curWindow.rootViewController = root
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                curWindow.rootViewController = root
            }
        }
    }
    
    
    //MARK: Tools
    class func getRootWindow() -> UIWindow? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.window
    }
}




























