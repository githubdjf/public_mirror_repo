//
//  RecruitEvaluationInfoViewController.swift
//  FirstEducation
//
//  Created by 译泰视觉 on 2018/9/30.
//  Copyright © 2018 yitai. All rights reserved.
//

//招生测评信息页面

import UIKit
import RxSwift
import RxCocoa

class RecruitEvaluationInfoViewController: BaseViewController, UITextFieldDelegate {
    
    var navi: UIView!
    var boyBtn: UIButton!
    var girlBtn: UIButton!
    var badyNameTF: UITextField!
    var badyBirthdayTF: UITextField!
    var parentNameTF: UITextField!
    var parentPhoneTF: UITextField!
    var curExamId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "f7f9fa")
        self.createUI()
    }
    
    func createUI() -> Void {
        navi = self.addNavByTitle(title: localStringForKey(key: "recruit_evaluation_title"))
        self.addBackButtonForNavigationBar()
        
        let info = UIButton(type: .custom)
        navi.addSubview(info)
        info.setImage(UIImage.init(named: "icon_user"), for: .normal)
        info.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        let optUser = LoginManager.default.curUser
        if let user = optUser {
            info.setTitle(user.userName, for: .normal)
        }
        info.setTitleColor(UIColor.white, for: .normal)
        info.addTarget(self, action: #selector(userBtnClick), for: .touchUpInside)
        
        info.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(navi.snp.centerY).offset(10)
            maker.right.equalTo(navi.snp.right).offset(-20)
        }
        
        let containView = UIView()
        self.view.addSubview(containView)
        containView.backgroundColor = UIColor.white
        containView.layer.shadowColor = UIColor.colorWithHexString(hex: "000000").cgColor
        containView.layer.cornerRadius = 8
        containView.layer.shadowRadius = 8
        containView.layer.shadowOpacity = 0.1
        containView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 964, height: 648))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-28)
        }
        
        let baseInfoImg = UIImageView()
        containView.addSubview(baseInfoImg)
        baseInfoImg.image = UIImage(named: "evaluation_base_icon")
        baseInfoImg.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.size.equalTo(CGSize(width: 180, height: 100))
        }
        
        boyBtn = UIButton(type: .custom)
        containView.addSubview(boyBtn)
        boyBtn.setImage(UIImage(named: "evaluation_boy_default"), for: .normal)
        boyBtn.setImage(UIImage(named: "evaluation_boy_hight"), for: .selected)
        boyBtn.setTitle(localStringForKey(key: "boy_title"), for: .normal)
        boyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        boyBtn.setTitleColor(UIColor.colorWithHexString(hex: "999999"), for: .normal)
        boyBtn.setTitleColor(UIColor.colorWithHexString(hex: "222222"), for: .selected)
        boyBtn.addTarget(self, action: #selector(boyBtnClick), for: .touchUpInside)
        boyBtn.isSelected = true
        boyBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 135))
            make.top.equalTo(64)
            make.centerX.equalToSuperview().offset(-75)
        }
        boyBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -boyBtn.imageView!.frame.width, bottom: -boyBtn.imageView!.frame.height-10, right: 0)

        boyBtn.imageEdgeInsets = UIEdgeInsets(top: -boyBtn.titleLabel!.frame.height, left: 0, bottom: 0, right: -boyBtn.titleLabel!.frame.width)
        
        girlBtn = UIButton(type: .custom)
        containView.addSubview(girlBtn)
        girlBtn.setImage(UIImage(named: "evaluation_girl_default"), for: .normal)
        girlBtn.setImage(UIImage(named: "evaluation_girl_hight"), for: .selected)
        girlBtn.setTitle(localStringForKey(key: "girl_title"), for: .normal)
        girlBtn.setTitleColor(UIColor.colorWithHexString(hex: "999999"), for: .normal)
        girlBtn.setTitleColor(UIColor.colorWithHexString(hex: "222222"), for: .selected)
        girlBtn.addTarget(self, action: #selector(girlBtnClick), for: .touchUpInside)
        girlBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 135))
            make.centerY.equalTo(boyBtn  )
            make.centerX.equalToSuperview().offset(75)
        }
        girlBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -girlBtn.imageView!.frame.width, bottom: -girlBtn.imageView!.frame.height-10, right: 0)
        
        girlBtn.imageEdgeInsets = UIEdgeInsets(top: -girlBtn.titleLabel!.frame.height, left: 0, bottom: 0, right: -girlBtn.titleLabel!.frame.width)
        
        
        badyNameTF = UITextField()
        containView.addSubview(badyNameTF)
        badyNameTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_bady_name"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "999999"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        badyNameTF.font = UIFont.systemFont(ofSize: 16)
        badyNameTF.layer.cornerRadius = 2
        badyNameTF.layer.borderWidth = 1
        badyNameTF.leftView = self.createLeft()
        badyNameTF.delegate = self
        badyNameTF.leftViewMode = .always
        badyNameTF.layer.borderColor = UIColor.colorWithHexString(hex: "d8d8d8").cgColor
        badyNameTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        badyNameTF.snp.makeConstraints { (make) in
            make.top.equalTo(boyBtn.snp.bottom).offset(17)
            make.left.equalTo(301)
            make.size.equalTo(CGSize(width: 440, height: 45))
        }
        
        let badyName = UILabel()
        containView.addSubview(badyName)
        badyName.font = UIFont.systemFont(ofSize: 16)
        badyName.textColor = UIColor.colorWithHexString(hex: "222222")
        badyName.text = localStringForKey(key: "recruit_evaluation_bady_name")
        badyName.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 82, height: 22))
            make.left.equalTo(221)
            make.centerY.equalTo(badyNameTF)
        }
        
        badyBirthdayTF = UITextField()
        containView.addSubview(badyBirthdayTF)
        badyBirthdayTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_bady_birthday"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "999999"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        badyBirthdayTF.layer.cornerRadius = 2
        badyBirthdayTF.layer.borderColor = UIColor.colorWithHexString(hex: "d8d8d8").cgColor
        badyBirthdayTF.layer.borderWidth = 1
        badyBirthdayTF.delegate = self
        badyBirthdayTF.font = UIFont.systemFont(ofSize: 16)
        badyBirthdayTF.leftView = self.createLeft()
        badyBirthdayTF.leftViewMode = .always
        let rightView = UIView()
        let imageView = UIImageView()
        rightView.addSubview(imageView)
        imageView.image = UIImage(named: "icon_date")
        imageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        badyBirthdayTF.rightView = rightView
        badyBirthdayTF.rightViewMode = .always
        badyBirthdayTF.delegate = self
        badyBirthdayTF.snp.makeConstraints { (make) in
            make.top.equalTo(badyNameTF.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 440, height: 45))
            make.centerX.equalTo(badyNameTF)
        }
        
        let badyBirthdayL = UILabel()
        containView.addSubview(badyBirthdayL)
        badyBirthdayL.font = UIFont.systemFont(ofSize: 16)
        badyBirthdayL.textColor = UIColor.colorWithHexString(hex: "222222")
        badyBirthdayL.text = localStringForKey(key: "recruit_evaluation_bady_birthday")
        badyBirthdayL.snp.makeConstraints { (make) in
            make.centerX.equalTo(badyName)
            make.centerY.equalTo(badyBirthdayTF)
        }
        
        parentNameTF = UITextField()
        containView.addSubview(parentNameTF)
        parentNameTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_parent_name"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "999999"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        parentNameTF.layer.cornerRadius = 2
        parentNameTF.layer.borderWidth = 1
        parentNameTF.leftView = self.createLeft()
        parentNameTF.leftViewMode = .always
        parentNameTF.delegate = self
        parentNameTF.layer.borderColor = UIColor.colorWithHexString(hex: "d8d8d8").cgColor
        parentNameTF.font = UIFont.systemFont(ofSize: 16)
        parentNameTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        parentNameTF.snp.makeConstraints { (make) in
            make.top.equalTo(badyBirthdayTF.snp.bottom).offset(20)
            make.size.equalTo(badyNameTF)
            make.centerX.equalTo(badyNameTF)
        }
        
        let parentNameL = UILabel()
        containView.addSubview(parentNameL)
        parentNameL.textColor = UIColor.colorWithHexString(hex: "222222")
        parentNameL.font = UIFont.systemFont(ofSize: 16)
        parentNameL.text = localStringForKey(key: "recruit_evaluation_parent_name")
        parentNameL.snp.makeConstraints { (make) in
            make.centerX.equalTo(badyName)
            make.centerY.equalTo(parentNameTF)
        }
        
        parentPhoneTF = UITextField()
        containView.addSubview(parentPhoneTF)
        parentPhoneTF.attributedPlaceholder = NSAttributedString(string: localStringForKey(key: "please_input_parent_phone"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "999999"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        parentPhoneTF.layer.cornerRadius = 2
        parentPhoneTF.layer.borderColor = UIColor.colorWithHexString(hex: "d8d8d8").cgColor
        parentPhoneTF.layer.borderWidth = 1
        parentPhoneTF.font = UIFont.systemFont(ofSize: 16)
        parentPhoneTF.keyboardType = .phonePad
        parentPhoneTF.leftView = self.createLeft()
        parentPhoneTF.leftViewMode = .always
        parentPhoneTF.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        parentPhoneTF.snp.makeConstraints { (make) in
            make.top.equalTo(parentNameTF.snp.bottom).offset(20)
            make.size.equalTo(badyNameTF)
            make.centerX.equalTo(badyNameTF)
        }
        
        let parentPhoneL = UILabel()
        containView.addSubview(parentPhoneL)
        parentPhoneL.font = UIFont.systemFont(ofSize: 16)
        parentPhoneL.textColor = UIColor.colorWithHexString(hex: "222222")
        parentPhoneL.text = localStringForKey(key: "recruit_evaluation_parent_phone")
        parentPhoneL.snp.makeConstraints { (make) in
            make.centerY.equalTo(parentPhoneTF)
            make.centerX.equalTo(badyName)
        }
        
        let initiateBtn = UIButton(type: .custom)
        containView.addSubview(initiateBtn)
        initiateBtn.backgroundColor = UIColor.colorWithHexString(hex: "069479")
        initiateBtn.layer.cornerRadius = 4
        initiateBtn.clipsToBounds = true
        initiateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        initiateBtn.setTitle(localStringForKey(key: "begin_evaluation"), for: .normal)
        initiateBtn.addTarget(self, action: #selector(initiateBtnClick), for: .touchUpInside)
        initiateBtn.snp.makeConstraints { (make) in
            make.top.equalTo(parentPhoneTF.snp.bottom).offset(20)
            make.left.equalTo(badyName).offset(0)
            make.right.equalTo(badyNameTF).offset(0)
            make.height.equalTo(50)
        }
    }
    

    //开始评测按钮点击事件
    @objc func initiateBtnClick() -> Void {
        
        guard let babyName = badyNameTF.text, babyName.count > 0 && babyName.count < 51 else {
            Prompter.showTextToast(localStringForKey(key: "baby_name_dont_blank"), inView: self.view)
            return
        }
        
        guard let babyBirth = badyBirthdayTF.text, babyBirth.count > 0 else {
            Prompter.showTextToast(localStringForKey(key: "baby_birthday_dont_blank"), inView: self.view)
            return
        }
        
        guard let parentName = parentNameTF.text, parentName.count > 0 && parentName.count < 51 else {
            Prompter.showTextToast(localStringForKey(key: "parent_name_dont_blank"), inView: self.view)
            return
        }
        
        guard let parentPhone = parentPhoneTF.text, parentPhone.count == 11 else {
            Prompter.showTextToast(localStringForKey(key: "please_input_correct_phone"), inView: self.view)
            return
        }
        
        if parentPhone.count == 0 {
            Prompter.showTextToast(localStringForKey(key: "parent_phone_dont_blank"), inView: self.view)
            return
        }
        
        let babySex = boyBtn.isSelected ? "1" : "2"
        Prompter.showLottieIndicator(inView: self.view)
        RecruitStudentService.obtainStudentInfomation(babyName: babyName, babySex: babySex, babyBirthday: babyBirth, parentName: parentName, parentPhone: parentPhone)
            .catchError { [weak self] (error) -> Observable<StudentInfo> in
                if let ws = self  {
                    Prompter.hideIndicator(inView: ws.view)
                    Prompter.showTextToast(APPErrorFactory.unboxAndExtractErrorMessage(from: error), inView: ws.view)
                }
                return Observable.empty()
        }
        .asSingle()
            .subscribe(onSuccess: { [weak self] (info) in
                if let ws = self {
                    Prompter.hideIndicator(inView: ws.view)
                    Prompter.showTextToast("访问成功", inView: ws.view)
                    let vc = RecruitStudentAssesmentViewController()
                    vc.curExamId = "\(ws.curExamId)"
                    vc.curStudentId = "\(info.id)"
                    vc.curStudentName = info.babyName
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }) { (error) in
                print("\(#function)  \(error)")
        }
        .disposed(by: self.rx.disposeBag)
    
    }
    
    //男孩性别点击事件
    @objc func boyBtnClick() -> Void {
        boyBtn.isSelected = true
        girlBtn.isSelected = !boyBtn.isSelected
    }
    
    //女孩性别点击事件
    @objc func girlBtnClick() -> Void {
        girlBtn.isSelected = true
        boyBtn.isSelected = !girlBtn.isSelected
    }
    
    @objc func userBtnClick() -> Void {
        let vc = PersonalCenterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) -> Void {
        let selectedRange = sender.markedTextRange
        var pos: UITextPosition?
        if let selectedStartPosition = selectedRange?.start {
            pos = sender.position(from: selectedStartPosition, offset: 0)
        }

        if (pos == nil) {
            
            if sender == badyNameTF {
                let babyName = badyNameTF.text ?? ""
                let filterBabyName = babyName.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                if filterBabyName.count > 50 {
                    let endIndex = filterBabyName.index(filterBabyName.startIndex, offsetBy: 50)
                    badyNameTF.text = String(filterBabyName[..<endIndex])
                }
            } else if sender == parentNameTF {
                let parentName = parentNameTF.text ?? ""
                let filterParentName = parentName.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                if filterParentName.count > 50 {
                    let endIndex = filterParentName.index(filterParentName.startIndex, offsetBy: 50)
                    parentNameTF.text = String(filterParentName[..<endIndex])
                }
            } else if sender == parentPhoneTF {
                let parentPhone = parentPhoneTF.text ?? ""
                let filterPhone = Format.filter(parentPhone, withCharSet: digital_only)
                if filterPhone.count > 11 {
                    let endIndex = filterPhone.index(filterPhone.startIndex, offsetBy: 11)
                    parentPhoneTF.text = String(filterPhone[..<endIndex])
                }
            }
            
        }
        
    }

    func createLeft() -> UIView {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 45))
        return leftView
    }



    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == badyBirthdayTF {
            badyBirthdayTF.resignFirstResponder()
            let datePicker = DatePickerViewController()
            datePicker.modalPresentationStyle = .overCurrentContext
            datePicker.dateBlock = {[weak self] (dateStr : String) in
                
                if let weakSelf = self {
                    
                    weakSelf.badyBirthdayTF.text = dateStr
                    weakSelf.dismiss(animated: false, completion: nil)
                }
            }
            self.present(datePicker, animated: false, completion: nil)
            
            
            return false
        }
        
        return true

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //系统表情键盘
        if let lau = textField.textInputMode?.primaryLanguage {

            if lau == "emoji" {
                return false
            }
        } else {
            return false
        }

        //是否在使用系统九宫格输入拼音
        if FormatChecker.isNineKeyBoard(string) {
            return true
        }

        //是否含有表情
        let hasEmoji = FormatChecker.hasEmoji(string) || FormatChecker.stringContainsEmoji(string)

        return !hasEmoji
        
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
