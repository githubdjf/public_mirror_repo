//
//  SystemManager.swift
//  zp_chu
//
//  Created by Jaffer on 2018/9/10.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct UpdateNotificationKey {
    
    static let optionalUpdateTSKey = "optionalUpdateTSKey"
}


@objc class SystemManager: NSObject {

    static let optionalUpdatePromptDuration: TimeInterval = 5 * 60

    @objc static let shared = SystemManager()
    
    var bag = DisposeBag()
    
    
    
    //MARK: update version
    
    @objc func checkVersion() {
        
        bag = DisposeBag()
        
        SystemService.checkAppVersion()
            .catchError {(error) -> Observable<APPInfo>in
                
                let eMsg = APPErrorFactory.unboxAndExtractErrorMessage(from: error)
                print("app version update failed!=error:\(eMsg)")
                return Observable.empty()
            }
            .asSingle()
            .subscribe(onSuccess: {(info) in
                
                if let mainBundleInfoDict = Bundle.main.infoDictionary, let bundleVersion = mainBundleInfoDict["CFBundleShortVersionString"] as? String {
                    if bundleVersion < info.versionName && info.downloadURL.count > 0 {
                        if info.isForceUpdateValue.count > 0 {
                            var forceUpdate = false
                            if info.isForceUpdateValue == "1" {
                                forceUpdate = true
                            }
                            
                            if !forceUpdate {
                                
                                let ud = UserDefaults.standard
                                if let lastOptionalDate = ud.object(forKey: UpdateNotificationKey.optionalUpdateTSKey) as? Date {
                                    //存在ts
                                    let interval = Date().timeIntervalSince(lastOptionalDate)
                                    if interval <= SystemManager.optionalUpdatePromptDuration {
                                        return
                                    }
                                } else {
                                    //不存在ts,continue
                                }
                            }
                            
                            if let rootVC = Navigator.getRootWindow()?.rootViewController {
                                
//                                guard Navigator.shared.curNavigateType != .adPage else {
//                                    return
//                                }
//                                let vc = UpdateVersionTipViewController.init(isMust: forceUpdate, info: info)
//                                vc.modalPresentationStyle = .overCurrentContext
//                                vc.confirm = { () in
//
//                                    //clean ts
//                                    UserDefaults.standard.removeObject(forKey: UpdateNotificationKey.optionalUpdateTSKey)
//                                    UserDefaults.standard.synchronize()
//
//                                    vc.dismiss(animated: true, completion: nil)
//
//                                    if let url = URL(string: info.downloadURL) {
//
//                                        UIApplication.shared.openURL(url)
//                                        exit(0)
//                                    }
//                                }
//
//                                vc.cancel = { () in
//
//                                    //deal with ts
//                                    if !forceUpdate {
//                                        //save ts
//                                        let ud = UserDefaults.standard
//                                        ud.set(Date(), forKey: UpdateNotificationKey.optionalUpdateTSKey)
//                                        ud.synchronize()
//                                    }
//                                    vc.dismiss(animated: true, completion: nil)
//                                }
//                                
//                                rootVC.present(vc, animated: false, completion: nil)
                            }
                        }
                        
                    }
                }

            }) { (error) in
                
                print("\(#function) error = \(error)!");
            }
            .disposed(by: bag)
    }
    
    
}
