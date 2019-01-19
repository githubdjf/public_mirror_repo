//
//  SecedeAccountTipViewController.swift
//  FirstEducation
//
//  Created by 译泰视觉 on 2018/9/29.
//  Copyright © 2018 yitai. All rights reserved.
//

import UIKit

class SecedeAccountTipViewController: BaseViewController {
    
    typealias CloseBtnBlock = () -> ()
    var closeBtnBlock: CloseBtnBlock!
    
    typealias ConfirmBtnBlock = () -> ()
    var confirmBtnBlock: ConfirmBtnBlock!

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
            make.size.equalTo(CGSize(width: 400, height: 45))
            make.right.equalTo(0)
        }
        
        let tipL = UILabel()
        tipView.addSubview(tipL)
        tipL.font = UIFont.systemFont(ofSize: 16)
        tipL.textColor = UIColor.white
        tipL.text = localStringForKey(key: "secede_tip_mesg")
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
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        
        let defaultImg = UIImageView()
        tipView.addSubview(defaultImg)
        defaultImg.image = UIImage(named: "password_default_image")
        defaultImg.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 140, height: 45))
            make.right.equalTo(-60)
            make.top.equalToSuperview()
        }
        
        let mesgL = UILabel()
        containView.addSubview(mesgL)
        mesgL.font = UIFont.systemFont(ofSize: 16)
        mesgL.textColor = UIColor.colorWithHexString(hex: "555555")
        mesgL.numberOfLines = 0
        mesgL.text = localStringForKey(key: "secede_account_tip")
        mesgL.snp.makeConstraints { (make) in
            make.top.equalTo(tipView.snp.bottom).offset(45)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(70)
        }
        
        let cancelBtn = UIButton(type: .custom)
        containView.addSubview(cancelBtn)
        cancelBtn.setTitle(localStringForKey(key: "alert_cancel"), for: .normal)
        cancelBtn.setTitleColor(UIColor.colorWithHexString(hex: "069479"), for: .normal)
        cancelBtn.layer.borderColor = UIColor.colorWithHexString(hex: "069479").cgColor
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 4
        cancelBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(mesgL.snp.bottom).offset(20)
            make.left.equalTo(40)
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.bottom.equalTo(-30)
        }
        
        
        let confirmBtn = UIButton(type: .custom)
        containView.addSubview(confirmBtn)
        confirmBtn.setTitle(localStringForKey(key: "alert_confirm"), for: .normal)
        confirmBtn.backgroundColor = UIColor.colorWithHexString(hex: "069479")
        confirmBtn.layer.cornerRadius = 4
        confirmBtn.clipsToBounds = true
        confirmBtn.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(cancelBtn)
            make.left.equalTo(cancelBtn.snp.right).offset(20)
            make.size.equalTo(cancelBtn)
        }
        
    }
    
    
    
    @objc func closeBtnClicked() -> Void {
        print("忘记密码页面关闭")
        self.dismiss(animated: true, completion: nil)
        if let blcok = closeBtnBlock {
            blcok()
        }
    }
    
    @objc func confirmBtnClicked() -> Void {
        self.dismiss(animated: true, completion: nil)
        if let block = confirmBtnBlock {
            block()
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
