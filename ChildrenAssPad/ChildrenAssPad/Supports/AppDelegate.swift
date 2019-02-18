//
//  AppDelegate.swift
//  ChildrenAssPad
//
//  Created by Jaffer on 2019/1/19.
//  Copyright © 2019年 yitai. All rights reserved.
//

import UIKit
import CocoaLumberjack


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        setup()
        
        //        let navType: Navigator.NavigateType = LoginManager.default.curUser != nil ? .homePage : .loginPage
        //        Navigator.shared.navigate(to: navType)
        
//                let trialVC = TeacherTrialViewController(title: "2018秋季测评", entryMode: TeacherTrialViewController.TrialMode.teacherEval, students: ["张三"])
        
        //        let trialVC = TeacherTrialViewController(title: "2018秋季测评", entryMode: TeacherTrialViewController.TrialMode.teacherEval, students: ["张三"])
        
//        let trialVC = TeacherTrialViewController(title: "2018秋季测评", entryMode: TeacherTrialViewController.TrialMode.teacherObserve, students: ["张三", "李四"])
        
//        window?.rootViewController = trialVC

        return true
    }
    
    func setup() {
        setupUM()
        setupKeyBoard()
        setupSystemServices()
        setupLogService()
        LoginManager.setupCookies()
    }
    
    //MARK:
    func setupUM() {
        
        #if DEBUG
        UMConfigure.setLogEnabled(true)
        UMConfigure.setEncryptEnabled(false)
        #else
        UMConfigure.setEncryptEnabled(true)
        #endif
        
        UMConfigure.initWithAppkey("5c42d367b465f539fb0005ba", channel: "App Store")
    }
    
    
    func setupKeyBoard() {
        
        let manager = IQKeyboardManager.shared()
        manager.isEnabled = true
        manager.shouldResignOnTouchOutside = true
        manager.shouldShowToolbarPlaceholder = false
    }
    
    func setupSystemServices() {
        
    }
    
    func setupLogService() {
        DDLog.add(DDTTYLogger.sharedInstance)
        
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        if let docP = docPath {
            let logPath = docP + "/Log"
            let logManager = DDLogFileManagerDefault.init(logsDirectory: logPath)
            if let fileLogger = DDFileLogger.init(logFileManager: logManager) {
                fileLogger.rollingFrequency = 60 * 60 * 24
                fileLogger.logFileManager.maximumNumberOfLogFiles = 24
                DDLog.add(fileLogger)
            }
        }
    }
    
    
    //    - (void)setupLogService {
    //
    //    [DDLog addLogger: [DDTTYLogger sharedInstance]];
    //
    //    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //    NSString *logPath = [docPath stringByAppendingPathComponent:@"Log"];
    //
    //    DDLogFileManagerDefault *manager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logPath];
    //    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:manager]; // File Logger
    //    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    //    fileLogger.logFileManager.maximumNumberOfLogFiles = 24;
    //    [DDLog addLogger:fileLogger];
    //    }
    
    
    func getUMDeviceId() -> String? {
        
        let id = UMConfigure.deviceIDForIntegration()
        return id
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

