//
//  SignInViewController.swift
//  FirstEducation
//
//  Created by 译泰视觉 on 2018/9/27.
//  Copyright © 2018 yitai. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa
import NSObject_Rx
import SwiftyJSON

class SignInViewController: BaseViewController{
    
    var passMaxNum = 18
    var accountTF: UITextField!
    var passwordTF: UITextField!
    
    var confirmBtn: UIButton!
    
    var animationViewLast: LOTAnimationView!
    var animationView: LOTAnimationView!
    var containView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.createUI()
    }
    
    func createUI() -> Void {
        
        animationViewLast = LOTAnimationView(name: "loginAnimationLast")
        self.view.addSubview(animationViewLast)
        animationViewLast.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        animationViewLast.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        animationViewLast.contentMode = .scaleAspectFit
        animationViewLast.clipsToBounds = true
        animationViewLast.loopAnimation = true
        
        animationView = LOTAnimationView.init(name: "loginAnimationFirst")
        self.view.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animationView.contentMode = .scaleAspectFit
        animationView.clipsToBounds = true
        
        
        animationView.play(toProgress: 0.1) { (finished) in
            if finished {
                self.createInputView()
                self.animationView.play(fromProgress: 0.1, toProgress: 1.0) { (finished) in
                    if finished {
                        self.animationView.removeFromSuperview()
                        self.animationViewLast.play()
                    }
                }
            }
        }
        
        
        
//        animationView.play { (finished) in
//            if finished {
//                animationView.removeFromSuperview()
//                animationViewLast.play()
//            }
//        }
        
        
        
//        if animationView.animationDuration == 1 {
//            animationView.removeFromSuperview()
//            animationViewLast.play()
//        }
        
        
    }
    
    func createInputView() -> Void {
        if let _ = containView {
            return
        }
        containView = UIView()
        self.view.addSubview(containView)
        containView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(23)
            make.centerX.equalToSuperview()
        }
        
        let titleL = UILabel()
        containView.addSubview(titleL)
        titleL.font = UIFont.systemFont(ofSize: 18)
        titleL.text = "第一教育  MOMA KIDS 摩码幼儿园成长中心"
        titleL.textColor = UIColor.colorWithHexString(hex: "222222")
        titleL.textAlignment = .center
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(containView)
            make.width.equalTo(440)
        }
        
        
        
        let placeHoldAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "999999")]
        accountTF = UITextField()
        containView.addSubview(accountTF)
        accountTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_account"), attributes: placeHoldAttr)
        accountTF.font = UIFont.systemFont(ofSize: 16)
        accountTF.leftViewMode = .always
        accountTF.leftView = self.createLeftView(tip: localStringForKey(key: "sign_in_account"))
        accountTF.clearButtonMode = .whileEditing
        accountTF.layer.borderWidth = 1
        accountTF.layer.borderColor = UIColor.colorWithHexString(hex: "d8d8d8").cgColor
        accountTF.layer.cornerRadius = 2
        accountTF.keyboardType = .asciiCapable
        accountTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        accountTF.snp.makeConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(20)
            make.left.right.equalTo(0)
            make.size.equalTo(CGSize(width: 440, height: 46))
            make.centerX.equalTo(self.view)
        }

        
        passwordTF = UITextField()
        containView.addSubview(passwordTF)
        passwordTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_password"), attributes: placeHoldAttr)
        passwordTF.font = UIFont.systemFont(ofSize: 16)
        passwordTF.leftViewMode = .always
        passwordTF.leftView = self.createLeftView(tip: localStringForKey(key: "sign_in_password"))
        passwordTF.isSecureTextEntry = true
        passwordTF.clearButtonMode = .whileEditing
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.borderColor = UIColor.colorWithHexString(hex: "d8d8d8").cgColor
        passwordTF.layer.cornerRadius = 2
        passwordTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        passwordTF.keyboardType = .asciiCapable
        passwordTF.snp.makeConstraints { (make) in
            make.top.equalTo(accountTF.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 440, height: 46))
            make.centerX.equalTo(self.view)
        }
        
        confirmBtn = UIButton(type: .custom)
        containView.addSubview(confirmBtn)
        confirmBtn.backgroundColor = UIColor.colorWithHexString(hex: "d8d8d8")
        confirmBtn.isEnabled = false
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmBtn.setTitleColor(UIColor.colorWithHexString(hex: "ffffff"), for: .normal)
        confirmBtn.setTitle(localStringForKey(key: "sign_in_title"), for: .normal)
        confirmBtn.layer.cornerRadius = 4
        confirmBtn.layer.masksToBounds = true
        confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTF.snp.bottom).offset(19)
            make.centerX.equalTo(passwordTF)
            make.size.equalTo(CGSize(width: 440, height: 50))
        }
        
        let forgetBtn = UIButton(type: .custom)
        containView.addSubview(forgetBtn)
        forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        forgetBtn.setTitleColor(UIColor.colorWithHexString(hex: "555555"), for: .normal)
        forgetBtn.setTitle(localStringForKey(key: "forget_password"), for: .normal)
        forgetBtn.addTarget(self, action: #selector(forgetBtnClick), for: .touchUpInside)
        forgetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(confirmBtn.snp.bottom).offset(20)
            make.centerX.equalTo(confirmBtn)
            make.bottom.equalTo(0)
        }
    }
    
    
    @objc func confirmBtnClick() -> Void {
        print("点击登录")
        confirmBtn.backgroundColor = UIColor.colorWithHexString(hex: "05d0a9")
        self.signInData()
    }
    
    func signInData() -> Void {
        guard let account = accountTF.text, let password = passwordTF.text else {
        
            return
        }
        
        Prompter.showLottieIndicator(inView: self.view)
        LoginService.login(account: account, password: password)
            .catchError { [weak self] (error) -> Observable<User> in
                if let ws = self {
                    Prompter.hideIndicator(inView: ws.view)
                    Prompter.showTextToast(APPErrorFactory.unboxAndExtractErrorMessage(from: error), inView: ws.view)
                }
                return Observable.empty()
        }
        .asSingle()
            .subscribe(onSuccess: { [weak self] (user) in
                if let ws = self {
                    Prompter.hideIndicator(inView: ws.view)
                    //登录成功
                    //保存当前用户
                    LoginManager.default.curUser = user
                    
                    LoginManager.saveCookies()
                    
                    Navigator.shared.navigate(to: .homePage)
                    
                    
                    print("登录成功")
                }
            }) { (error) in
                print("\(#function)  \(error)")
        }
        .disposed(by: self.rx.disposeBag)
        
    }
    
    @objc func forgetBtnClick() -> Void {
        print("忘记密码")
        let vc = ForgetPasswordViewController()
        vc.successBlock = { (mesg) in
            Prompter.showTextToast(mesg, inView: self.view)
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }

    func createLeftView(tip: String) -> UIView {
        let accountLeft = UIView()
        accountLeft.snp.makeConstraints { (make) in
            make.height.equalTo(46)
        }
        let accountL = UILabel()
        accountLeft.addSubview(accountL)
        accountL.font = UIFont.systemFont(ofSize: 16)
        accountL.text = tip
        accountL.textColor = UIColor.colorWithHexString(hex: "222222")
        accountL.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.centerY.equalTo(accountLeft)
            make.height.equalTo(46)
        }
        return accountLeft
    }
    
    @objc func textDidChange(sender: UITextField) -> Void {
        guard let account = accountTF.text, let password = passwordTF.text else {
            return
        }
        
        let filteredAct = Format.filter(account, withCharSet: digital_alphabet)
        let filteredPwd = Format.filter(password, withCharSet: digital_alphabet)
        let finalPass = String((filteredPwd.prefix(passMaxNum)))
        let finalAct = String(filteredAct.prefix(16))
        passwordTF.text = finalPass
        accountTF.text = finalAct
        if finalAct.count > 0 && finalAct.count < 17 && finalPass.count >= 6 && finalPass.count <= passMaxNum  {
            confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = UIColor.colorWithHexString(hex: "069479")
        } else {
            confirmBtn.backgroundColor = UIColor.colorWithHexString(hex: "d8d8d8")
            confirmBtn.isEnabled = false
        }
    }
    
    @objc func resignActive() -> Void {
        if animationView.animationProgress < 1.0 {
            animationView.pause()
        }
        
//        if animationViewLast.animationProgress < 1.0 {
            animationViewLast.pause()
//        }
    }
    
    @objc func becomeActive() -> Void {
        if animationView.animationProgress > 0.1 && animationView.animationProgress < 1.0 {
            animationView.play { (finished) in
                if finished {
                    self.animationView.removeFromSuperview()
                    self.animationViewLast.play()
                }
            }
        } else if animationView.animationProgress >= 1.0 {
            animationViewLast.play()
        } else {
            self.createInputView()
            self.animationView.play(fromProgress: animationView.animationProgress, toProgress: 1.0) { (finished) in
                if finished {
                    self.animationView.removeFromSuperview()
                    self.animationViewLast.play()
                }
            }
        }
        
        if animationViewLast.animationProgress >= 0 && animationViewLast.animationProgress <= 1.0 {
            if animationViewLast != nil {
                animationViewLast.play()
            }
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
