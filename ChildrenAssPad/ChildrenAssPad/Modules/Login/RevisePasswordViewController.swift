//
//  RevisePasswordViewController.swift
//  FirstEducation
//
//  Created by 译泰视觉 on 2018/10/10.
//  Copyright © 2018 yitai. All rights reserved.
//
//      修改密码

import UIKit
import RxSwift
import RxCocoa

class RevisePasswordViewController: BaseViewController {
    
    var phoneNumTF: UITextField!
    var verificationTF: UITextField!
    var newPasswordTF: UITextField!
    var confirmBtn: UIButton!
    var rightBtn: UIButton!         //发送验证码按钮
    
    var countdownTimer: Timer?
    
    typealias SuccessBlock = (String) -> ()
    var successBlock: SuccessBlock!
    
    var remainingSeconds: Int = 0 {
        willSet {
            let attString = NSMutableAttributedString(string: "\(newValue)" + localStringForKey(key: "after_second_resend"))
            attString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "069479")], range: NSRange(location: 0, length: "\(newValue)".count))
            attString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "999999")], range: NSRange(location: "\(newValue)".count, length: localStringForKey(key: "after_second_resend").count))
            rightBtn.setAttributedTitle(attString, for: .normal)
            if newValue <= 0 {
                rightBtn.setAttributedTitle(NSAttributedString(string: localStringForKey(key: "send_verification_code"), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "222222")]), for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
                RunLoop.main.add(countdownTimer!, forMode: RunLoop.Mode.common)
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
            }
            
            rightBtn.isEnabled = !newValue
        }
    }
    
    typealias CloseBtnBlock = () -> ()
    var closeBtnBlock: CloseBtnBlock!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.colorFromRGBA(0, 0, 0, alpha: 0.5)
        self.createUI()
    }
    
    func createUI() -> Void {
        let containView = UIView()
        self.view.addSubview(containView)
        containView.backgroundColor = UIColor.white
        containView.layer.cornerRadius = 8
        containView.layer.masksToBounds = true
        containView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
        
        let tipView = UIView()
        containView.addSubview(tipView)
        tipView.backgroundColor = UIColor.colorWithHexString(hex: "069479")
        tipView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.size.equalTo(CGSize(width: 520, height: 45))
            make.right.equalTo(0)
        }
        
        let tipL = UILabel()
        tipView.addSubview(tipL)
        tipL.font = UIFont.systemFont(ofSize: 16)
        tipL.textColor = UIColor.white
        tipL.text = localStringForKey(key: "revise_password")
        tipL.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        let closeBtn = UIButton(type: .custom)
        tipView.addSubview(closeBtn)
        closeBtn.setImage(UIImage(named: "forget_password_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-19)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 18, height: 16))
        }
        
        let defaultImg = UIImageView()
        tipView.addSubview(defaultImg)
        defaultImg.image = UIImage(named: "password_default_image")
        defaultImg.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 140, height: 45))
            make.right.equalTo(-60)
            make.top.equalToSuperview()
        }
        
        let placeHoldAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "999999")]
        
        let phoneLeft = self.createLeftView(tip: localStringForKey(key: "phone_number"))
        phoneNumTF = UITextField()
        containView.addSubview(phoneNumTF)
        phoneNumTF.keyboardType = .numberPad
        phoneNumTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_phone_number"), attributes: placeHoldAttr)
        phoneNumTF.leftView = phoneLeft
        phoneNumTF.leftViewMode = .always
        phoneNumTF.font = UIFont.systemFont(ofSize: 16)
        phoneNumTF.textColor = UIColor.colorWithHexString(hex: "999999")
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 46))
        let verticalLine = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 46))
        rightView.addSubview(verticalLine)
        verticalLine.backgroundColor = UIColor.colorWithHexString(hex: "d8d8d8")
        rightBtn = UIButton(type: .custom)
        rightView.addSubview(rightBtn)
        rightBtn.frame = CGRect(x: 1, y: 0, width: 100, height: 46)
        rightBtn.setTitle(localStringForKey(key: "send_verification_code"), for: .normal)
        rightBtn.setTitleColor(UIColor.colorWithHexString(hex: "999999"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightBtn.addTarget(self, action: #selector(sendVerificationCode), for: .touchUpInside)
        phoneNumTF.rightView = rightView
        phoneNumTF.rightViewMode = .always
        phoneNumTF.layer.cornerRadius = 2
        phoneNumTF.layer.borderColor = UIColor.colorWithHexString(hex: "d8d8d8").cgColor
        phoneNumTF.layer.borderWidth = 1
        phoneNumTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        phoneNumTF.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 440, height: 46))
            make.top.equalTo(tipView.snp.bottom).offset(47)
            make.centerX.equalToSuperview()
        }
        
        verificationTF = UITextField()
        containView.addSubview(verificationTF)
        verificationTF.leftView = self.createLeftView(tip: localStringForKey(key: "verification_code"))
        verificationTF.leftViewMode = .always
        verificationTF.keyboardType = .numberPad
        verificationTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_verification_code"), attributes: placeHoldAttr)
        verificationTF.font = UIFont.systemFont(ofSize: 16)
        verificationTF.textColor = UIColor.colorWithHexString(hex: "999999")
        verificationTF.keyboardType = .numberPad
        verificationTF.layer.cornerRadius = 2
        verificationTF.layer.borderWidth = 1
        verificationTF.layer.borderColor = UIColor.colorWithHexString(hex: "d8d8d8").cgColor
        verificationTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        verificationTF.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumTF.snp.bottom).offset(19)
            make.centerX.equalTo(phoneNumTF)
            make.size.equalTo(phoneNumTF)
        }
        
        newPasswordTF = UITextField()
        containView.addSubview(newPasswordTF)
        newPasswordTF.leftView = self.createLeftView(tip: localStringForKey(key: "new_password"))
        newPasswordTF.leftViewMode = .always
        newPasswordTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_new_password"), attributes: placeHoldAttr)
        newPasswordTF.keyboardType = .asciiCapable
        newPasswordTF.isSecureTextEntry = true
        newPasswordTF.layer.cornerRadius = 2
        newPasswordTF.layer.borderColor = UIColor.colorWithHexString(hex: "d8d8d8").cgColor
        newPasswordTF.layer.borderWidth = 1
        newPasswordTF.font = UIFont.systemFont(ofSize: 16)
        newPasswordTF.textColor = UIColor.colorWithHexString(hex: "999999")
        newPasswordTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        newPasswordTF.snp.makeConstraints { (make) in
            make.top.equalTo(verificationTF.snp.bottom).offset(20)
            make.centerX.equalTo(phoneNumTF)
            make.size.equalTo(phoneNumTF)
        }

        
        confirmBtn = UIButton(type: .custom)
        containView.addSubview(confirmBtn)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmBtn.setTitle(localStringForKey(key: "alert_confirm"), for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.backgroundColor = UIColor.colorWithHexString(hex: "d8d8d8")
        confirmBtn.layer.cornerRadius = 4
        confirmBtn.layer.masksToBounds = true
        confirmBtn.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(newPasswordTF.snp.bottom).offset(19)
            make.size.equalTo(CGSize(width: 440, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-53)
        }
        
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
    
    @objc func closeBtnClicked() -> Void {
        print("忘记密码页面关闭")
        self.dismiss(animated: true, completion: nil)
        if let blcok = closeBtnBlock {
            blcok()
        }
    }
    //发送验证码
    @objc func sendVerificationCode() -> Void {
        guard let phone = phoneNumTF.text, phone.count == 11 else {
            Prompter.showTextToast("号码不正确，请重新输入", inView: self.view)
            return
        }
        Prompter.showLottieIndicator(inView: self.view)
        
        LoginService.getVerifyCode(phone: phone)
            .catchError { [weak self] (error) -> Observable<String> in
                if let ws = self {
                    Prompter.hideIndicator(inView: ws.view)
                    Prompter.showTextToast(APPErrorFactory.unboxAndExtractErrorMessage(from: error), inView: ws.view)
                }
                return Observable.empty()
            }
            .asSingle()
            .subscribe(onSuccess: { [weak self] (mesg) in
                if let ws = self {
                    Prompter.hideIndicator(inView: ws.view)
                    ws.isCounting = true
                    Prompter.showOperationSucceed(inView: ws.view, toast: mesg, afterDelay: 1)
                }
            }) { (error) in
                print("\(#function)   \(error)")
            }
            .disposed(by: self.rx.disposeBag)

    }
    
    @objc func confirmBtnClicked() -> Void {
        print("确定按钮")
        
        guard let phoneNum = phoneNumTF.text, phoneNum.count == 11 else {
            Prompter.showTextToast("号码不存在，请重新输入", inView: self.view)
            return
        }
        
        guard let verification = verificationTF.text, verification.count > 3 && verification.count < 7 else {
            Prompter.showTextToast("验证码，请重新输入", inView: self.view)
            return
        }
        
        guard let password = newPasswordTF.text, password.count > 5 && password.count < 19 else {
            Prompter.showTextToast("密码格式不正确，请重新输入", inView: self.view)
            return
        }
        
        LoginService.changePassword(phone: phoneNumTF.text ?? "", password: newPasswordTF.text ?? "", captcha: verificationTF.text ?? "")
            .catchError { [weak self] (error) -> Observable<String> in
                if let ws = self {
                    Prompter.showTextToast(APPErrorFactory.unboxAndExtractErrorMessage(from: error), inView: ws.view)
                }
                return Observable.empty()
            }
            .asSingle()
            .subscribe(onSuccess: { [weak self] (mesg) in
                if let ws = self {
                    if ws.successBlock != nil {
                        ws.successBlock(mesg)
                    }
                    ws.dismiss(animated: true, completion: nil)
                }
            }) { (error) in
                print("\(#function)  \(error)")
            }
            .disposed(by: self.rx.disposeBag)
    }
    
    @objc func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }
    
    @objc func textDidChange(sender: UITextField) -> Void {
        guard let phoneNum = phoneNumTF.text, let verification = verificationTF.text, let password = newPasswordTF.text else {
            Prompter.showTextToast("号码不存在，请重新输入", inView: self.view)
            return
        }
        
        
        
        let filterPhone = Format.filter(phoneNum, withCharSet: digital_only)
        let filterVeri = Format.filter(verification, withCharSet: digital_only)
        let filterPwd = Format.filter(password, withCharSet: digital_alphabet)
       
        
        let finalPhone = String(filterPhone.prefix(11))
        let finalVeri = String(filterVeri.prefix(6))
        let finalPwd = String(filterPwd.prefix(18))
        if rightBtn.isEnabled {
            if finalPhone.count == 11 {
                rightBtn.setAttributedTitle(NSAttributedString(string: localStringForKey(key: "send_verification_code"), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "222222")]), for: .normal)
            } else {
                rightBtn.setAttributedTitle(NSAttributedString(string: localStringForKey(key: "send_verification_code"), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "999999")]), for: .normal)
            }
        }
        
        phoneNumTF.text = finalPhone
        verificationTF.text = finalVeri
        newPasswordTF.text = finalPwd
        
        if finalPhone.count == 11 && finalVeri.count > 3 && finalVeri.count < 7 && finalPwd.count > 5 && finalPwd.count < 19 {
            confirmBtn.backgroundColor = UIColor.colorWithHexString(hex: "069479")
        } else {
            confirmBtn.backgroundColor = UIColor.colorWithHexString(hex: "d8d8d8")
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
