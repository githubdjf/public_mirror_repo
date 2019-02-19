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
    
//    var animationViewLast: LOTAnimationView!
//    var animationView: LOTAnimationView!
//    var containView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.createUI()
    }
    
    func createUI() -> Void {
        
        let backImage = UIImageView()
        self.view.addSubview(backImage)
        backImage.image = UIImage(named: "login_default_background")
        backImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.createInputView()
        
//        animationViewLast = LOTAnimationView(name: "loginAnimationLast")
//        self.view.addSubview(animationViewLast)
//        animationViewLast.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        animationViewLast.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
//        animationViewLast.contentMode = .scaleAspectFit
//        animationViewLast.clipsToBounds = true
//        animationViewLast.loopAnimation = true
//
//        animationView = LOTAnimationView.init(name: "loginAnimationFirst")
//        self.view.addSubview(animationView)
//        animationView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
//        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        animationView.contentMode = .scaleAspectFit
//        animationView.clipsToBounds = true
//
//
//        animationView.play(toProgress: 0.1) { (finished) in
//            if finished {
//                self.createInputView()
//                self.animationView.play(fromProgress: 0.1, toProgress: 1.0) { (finished) in
//                    if finished {
//                        self.animationView.removeFromSuperview()
//                        self.animationViewLast.play()
//                    }
//                }
//            }
//        }
        
        
        
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
        let titleL = UILabel()
        self.view.addSubview(titleL)
        titleL.font = UIFont.systemFont(ofSize: 50)
        titleL.text = "幼儿成长测评服务"
        titleL.textColor = UIColor.white
        titleL.textAlignment = .center
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(101)
            make.left.equalTo(50)
            make.height.equalTo(35)
        }
        
        
        accountTF = UITextField()
        self.view.addSubview(accountTF)
        accountTF.font = UIFont.systemFont(ofSize: 16)
        accountTF.leftViewMode = .always
        accountTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_account"), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorFromRGBA(85, 85, 85)])
        accountTF.leftView = self.createLeftView(tip: "account")
        accountTF.clearButtonMode = .whileEditing
        accountTF.keyboardType = .asciiCapable
        accountTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        accountTF.snp.makeConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(30)
            make.left.equalTo(titleL)
            make.size.equalTo(CGSize(width: 360, height: 24))
        }

        let accountLine = UIView()
        self.view.addSubview(accountLine)
        accountLine.backgroundColor = UIColor.colorFromRGBA(246, 196, 0)
        accountLine.snp.makeConstraints { (make) in
            make.top.equalTo(accountTF.snp.bottom).offset(8)
            make.left.right.equalTo(accountTF)
            make.height.equalTo(2)
        }
        
        passwordTF = UITextField()
        self.view.addSubview(passwordTF)
        passwordTF.font = UIFont.systemFont(ofSize: 16)
        passwordTF.leftViewMode = .always
        passwordTF.leftView = self.createLeftView(tip: "password")
        passwordTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_password"), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorFromRGBA(85, 85, 85)])
        passwordTF.isSecureTextEntry = true
        passwordTF.clearButtonMode = .whileEditing
        passwordTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        passwordTF.keyboardType = .asciiCapable
        passwordTF.snp.makeConstraints { (make) in
            make.top.equalTo(accountTF.snp.bottom).offset(26)
            make.left.size.equalTo(accountTF)
        }
        
        let passwordLine = UIView()
        self.view.addSubview(passwordLine)
        passwordLine.backgroundColor = UIColor.colorFromRGBA(246, 196, 0)
        passwordLine.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTF.snp.bottom).offset(8)
            make.left.right.equalTo(accountTF)
            make.height.equalTo(2)
        }
        
        confirmBtn = UIButton(type: .custom)
        self.view.addSubview(confirmBtn)
        confirmBtn.backgroundColor = UIColor.colorFromRGBA(255, 162, 0)
        confirmBtn.isEnabled = false
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmBtn.setTitleColor(UIColor.colorFromRGBA(255, 255, 255, alpha: 0.4), for: .disabled)
        confirmBtn.setTitleColor(UIColor.colorFromRGBA(255, 255, 255), for: .highlighted)
        confirmBtn.setTitle(localStringForKey(key: "sign_in_title"), for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordLine.snp.bottom).offset(30)
            make.centerX.equalTo(passwordTF)
            make.size.equalTo(CGSize(width: 360, height: 56))
        }
        confirmBtn.layer.cornerRadius = 28
        confirmBtn.clipsToBounds = true
        
        
        let forgetBtn = UIButton(type: .custom)
        self.view.addSubview(forgetBtn)
        forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        forgetBtn.setTitleColor(UIColor.colorFromRGBA(85, 85, 85), for: .normal)
        forgetBtn.setTitle(localStringForKey(key: "forget_password"), for: .normal)
        forgetBtn.setImage(UIImage(named: "revise_password"), for: .normal)
        forgetBtn.addTarget(self, action: #selector(forgetBtnClick), for: .touchUpInside)
        forgetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(confirmBtn.snp.bottom).offset(20)
            make.centerX.equalTo(confirmBtn)
            make.height.equalTo(24)
        }
        let imgW = forgetBtn.imageView!.bounds.width
        let titleW = forgetBtn.titleLabel!.bounds.width
        forgetBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleW+10, bottom: 0, right: -titleW-10)
        forgetBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imgW, bottom: 0, right: imgW)
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
        let leftView = UIView()
        leftView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(24)
        }
       
        let leftImg = UIImageView()
        leftView.addSubview(leftImg)
        leftImg.image = UIImage(named: tip)
        leftImg.snp.makeConstraints { (make) in
            make.left.equalTo(3)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerY.equalToSuperview()
        }
        return leftView
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
    
//    @objc func resignActive() -> Void {
//        if animationView.animationProgress < 1.0 {
//            animationView.pause()
//        }
//
////        if animationViewLast.animationProgress < 1.0 {
//            animationViewLast.pause()
////        }
//    }
//
//    @objc func becomeActive() -> Void {
//        if animationView.animationProgress > 0.1 && animationView.animationProgress < 1.0 {
//            animationView.play { (finished) in
//                if finished {
//                    self.animationView.removeFromSuperview()
//                    self.animationViewLast.play()
//                }
//            }
//        } else if animationView.animationProgress >= 1.0 {
//            animationViewLast.play()
//        } else {
//            self.createInputView()
//            self.animationView.play(fromProgress: animationView.animationProgress, toProgress: 1.0) { (finished) in
//                if finished {
//                    self.animationView.removeFromSuperview()
//                    self.animationViewLast.play()
//                }
//            }
//        }
//
//        if animationViewLast.animationProgress >= 0 && animationViewLast.animationProgress <= 1.0 {
//            if animationViewLast != nil {
//                animationViewLast.play()
//            }
//        }
//    }
//
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
