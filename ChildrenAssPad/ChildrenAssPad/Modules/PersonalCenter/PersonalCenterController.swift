//
//  PersonalCenterController.swift
//  FirstEducation
//
//  Created by 黄逸诚 on 2018/9/28.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SwiftyJSON


class PersonalCenterController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.colorFromRGBA(247, 249, 250)
        let navi =  addNavByTitle(title: "个人中心")
        
        addBackButtonForNavigationBar()
        
        addUserInfoToNaviRight(navi: navi)
        
        addFunctionViews(navi: navi)
    }

    
    private func addUserInfoToNaviRight(navi:UIView) -> Void{

        let userName = LoginManager.default.curUser?.userName

        let info  = UIButton.init()
        info.setImage(UIImage.init(named: "icon_user"), for: .normal)
        info.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        info.setTitle(userName, for: .normal)
        info.setTitleColor(UIColor.white, for: .normal)
        info.isUserInteractionEnabled = false
        
        navi.addSubview(info)
        
        info.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(navi.snp.centerY).offset(10)
            maker.right.equalTo(navi.snp.right).offset(-20)
        }
    }
    
    
    private func addFunctionViews(navi:UIView) -> Void {
        let layout = UIView.init()
        layout.layer.shadowRadius = 8
        layout.layer.shadowOpacity = 0.2
        layout.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        self.view.addSubview(layout)
        layout.snp.makeConstraints{ (maker) in
            maker.top.equalTo(navi.snp.bottom)
            maker.width.equalTo(screenWidth)
            maker.bottom.equalTo(self.view.snp.bottom)
        }
        
        let tableview = UITableView.init()
        tableview.layer.cornerRadius = 8
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 80
        tableview.separatorStyle = .none
        tableview.isScrollEnabled = false
        layout.addSubview(tableview)
        
        tableview.snp.makeConstraints{ (maker) in
            maker.left.equalTo(layout.snp.left).offset(30)
            maker.right.equalTo(layout.snp.right).offset(-30)
            maker.top.equalTo(layout.snp.top).offset(20)
            maker.bottom.equalTo(layout.snp.bottom).offset(-30)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identity = PersonalCenterCell.description()
        var cell : PersonalCenterCell? = tableView.dequeueReusableCell(withIdentifier: identity) as? PersonalCenterCell
        if cell == nil {
            cell = PersonalCenterCell.init(style: .default, reuseIdentifier: identity)
            cell?.selectionStyle = .none
        }
        switch indexPath.row {
        case 0:do{
            cell?.titleLabel.text = "招生测评记录"
            cell?.iconImage.image = UIImage.init(named: "icon_recruit_evaluation")
            }
        case 1:do{
            cell?.titleLabel.text = "修改密码"
            cell?.iconImage.image = UIImage.init(named: "icon_modify_password")
            }
        case 2:do{

            let infoDictionary = Bundle.main.infoDictionary!
            let majorVersion = infoDictionary["CFBundleShortVersionString"]
            if let version = majorVersion as? String{
                cell?.titleLabel.text = "版本：" + "V " + version
            }

            cell?.arrow.isHidden = true
            cell?.iconImage.image = UIImage.init(named: "icon_version_code")
            }
        case 3:do {
            cell?.titleLabel.text = "退出"
            cell?.arrow.isHidden = true
            cell?.iconImage.image = UIImage.init(named: "icon_exit")
            }
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:do {

            //进入招生测评记录
            let vc = RecruitEvaluationRecordController()
            self.navigationController?.pushViewController(vc, animated: true)
            
            }
        case 1:do {
            let vc = RevisePasswordViewController()
            vc.successBlock = { (mesg) in
                Prompter.showTextToast(mesg, inView: self.view)
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
            }
        case 3:do {

            let vc = SecedeAccountTipViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.confirmBtnBlock = { [weak self] () in
                if let weakSelf = self {
                   weakSelf.logout()

                }
            }

            self.present(vc, animated: false, completion: nil)

        }

        default:
            print("wrong position")
        }
    }


    func logout() -> Void {

        Prompter.showLottieIndicator(inView: self.view)
        UserCenterService.logOut()
            .catchError({ [weak self] (error) -> Observable<JSON> in

                if let weakSelf = self {
                    Prompter.hideIndicator(inView: weakSelf.view)
                    let eMsg = APPErrorFactory.unboxAndExtractErrorMessage(from: error)
                    let _ = Prompter.showOperationException(inView: weakSelf.view, title: eMsg)
                }

                return Observable.empty()
            })
            .asSingle()
            .subscribe(onSuccess: { [weak self] _ in

                if let weakSelf = self {

                    weakSelf.dismiss(animated: false, completion: nil)

                    Prompter.hideIndicator(inView: weakSelf.view)

                    //清空当前用户数据
                    LoginManager.default.cleanUserCacheData()

                    //清空本地所有cookie
//                    let cookieStorgae = HTTPCookieStorage.shared
//                    if let cookies = cookieStorgae.cookies {
//                        cookies.forEach({ (cookie) in
//                            cookieStorgae.deleteCookie(cookie)
//                        })
//                    }

                    if let window = Navigator.getRootWindow() {
                        Prompter.showOperationSucceed(inView:window)
                    }
                    
                    //切换登录页面
                    Navigator.shared.navigate(to: .loginPage, delay: 1)
                }

            }) { (error) in

        }.disposed(by: self.rx.disposeBag)
    }
}
