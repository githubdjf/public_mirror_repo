//
//  Prompter.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/26.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import Lottie
import SnapKit
import MBProgressHUD


class Prompter {
    
    //只显示文字toast
    @discardableResult
    class func showTextToast(_ text: String?, inView view: UIView, duration: TimeInterval = 2, animated: Bool = true) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.mode = .text
        hud.label.text = text
        hud.label.numberOfLines = 0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: animated, afterDelay: duration)
        return hud
    }
    
    //显示加载Indicator
    @discardableResult
    class func showLottieIndicator(inView view: UIView, title: String = "进程加载中...", animated: Bool = true) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        
        let containView = UIView()
        containView.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
        }
        let animationView = LOTAnimationView.init(name: "loading")
        animationView.loopAnimation = true
        containView.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.size.equalTo(CGSize(width: 110, height: 100))
            make.centerX.equalToSuperview()
        }
        
        let titleL = UILabel()
        titleL.font = UIFont.systemFont(ofSize: 16)
        titleL.textColor = UIColor.colorWithHexString(hex: "999999")
        titleL.textAlignment = .center
        titleL.text = title
        containView.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom).offset(10)
            make.centerX.equalTo(containView)
            make.bottom.equalToSuperview().offset(0)
        }
        
        hud.customView = containView
        hud.margin = 10
        animationView.play()
        hud.bezelView.backgroundColor = UIColor.colorWithHexString(hex: "ffffff", alpha: 1.0)
        hud.bezelView.layer.cornerRadius = 16
        hud.bezelView.layer.masksToBounds = true
        hud.layer.shadowColor = UIColor.colorFromRGBA(0, 0, 0, alpha: 0.5).cgColor
        hud.layer.shadowOffset = CGSize(width: 0, height: 0)
        hud.layer.shadowRadius = 8
        hud.layer.shadowOpacity = 0.3
        view.layoutIfNeeded()
        return hud
    }
    
    
    //显示操作异常
    @discardableResult
    class func showOperationException(inView view: UIView, title: String, afterDelay: TimeInterval = 2) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        hud.margin = 0
        hud.hide(animated: true, afterDelay: afterDelay)
        let containView = UIView()
        containView.snp.makeConstraints { (make) in
            make.width.equalTo(180)
            make.height.greaterThanOrEqualTo(160)
        }
        let imageView = UIImageView(image: UIImage(named: "operation_exception"))
        containView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        let titleL = UILabel()
                containView.addSubview(titleL)
        titleL.font = UIFont.systemFont(ofSize: 16)
        titleL.textColor = UIColor.colorWithHexString(hex: "555555")
        titleL.textAlignment = .center
        titleL.text = title
        titleL.numberOfLines = 0
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
//            make.centerX.equalTo(containView)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        
        hud.customView = containView
        
        hud.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        hud.bezelView.backgroundColor = UIColor.white
        hud.layer.cornerRadius = 8
        hud.clipsToBounds = true
        return hud
    }
    
    
    //成功提示
    @discardableResult
    class func showOperationSucceed(inView view: UIView, toast title: String = localStringForKey(key: "successful_secede"), afterDelay: TimeInterval = 1) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        hud.margin = 0
        hud.hide(animated: true, afterDelay: afterDelay)
        let containView = UIView()
        containView.snp.makeConstraints { (make) in
            make.width.equalTo(180)
            make.height.greaterThanOrEqualTo(160)
        }
        let imageView = UIImageView(image: UIImage(named: "operation_success"))
        containView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        let titleL = UILabel()
        titleL.font = UIFont.systemFont(ofSize: 16)
        titleL.textColor = UIColor.colorWithHexString(hex: "555555")
        titleL.textAlignment = .center
        titleL.text = title
        titleL.numberOfLines = 0
        containView.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
//            make.centerX.equalTo(containView)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        
        hud.customView = containView
        
        hud.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        hud.bezelView.backgroundColor = UIColor.white
        hud.layer.cornerRadius = 8
        hud.clipsToBounds = true
        return hud
    }
    
    //显示提示
    @discardableResult
    class func showResult(_ text: String?, textFont: UIFont?, image: UIImage?, inView view: UIView, autoHide: Bool = true, duration: TimeInterval = 2, animated: Bool = true)  -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.label.text = text
        hud.label.font = textFont
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        let imageView = UIImageView(image: image)
        hud.customView = imageView
    
        hud.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        hud.bezelView.backgroundColor = UIColor.white
        
        if autoHide {
            hud.hide(animated: animated, afterDelay: duration)
        }
        return hud
    }
    
    
    //隐藏加载Indicator
    class func hideIndicator(inView view: UIView, animated: Bool = true) {
        MBProgressHUD.hide(for: view, animated: animated)
    }
}
