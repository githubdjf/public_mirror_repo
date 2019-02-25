//
//  BaseViewController.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/9/25.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SnapKit
import NSObject_Rx

class BaseViewController: UIViewController {
    
    var loadingView: LoadDataView?
    var emptyView: PromptView?
    var errorView: PromptView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.defaultGrayColor
        navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("==========\(#function)  ")
    }
}


extension UIViewController{
    
    func addNavByTitle(title:String) -> UIView {
        
        let navBar = UIView.init()
        navBar.backgroundColor = UIColor.mainColor
        navBar.tag = 0x3a4b
        
        if !self.view.subviews.contains(navBar){
            self.view.addSubview(navBar)
        }
        
        navBar.snp.makeConstraints { (maker) in
            maker.top.left.width.equalTo(self.view)
            maker.height.equalTo(74)
        }
        
        if !title.isEmpty {
            
            let lable = UILabel.init()
            lable.tag = 100
            lable.textColor = UIColor.colorFromRGBA(34, 34, 34)
            lable.text = title
            lable.font = UIFont.systemFont(ofSize: 18)
            lable.textAlignment = .center
            navBar.addSubview(lable)
            
            lable.snp.makeConstraints { (maker) in
                maker.centerX.equalTo(navBar.snp.centerX)
                maker.height.equalTo(50)
                maker.centerY.equalTo(navBar.snp.centerY).offset(10)
                maker.width.lessThanOrEqualTo(screenWidth * 0.7)
            }
        }
        
        return navBar
    }
    
    
    func addBackButtonForNavigationBar() -> Void {
        
        let backButton = UIButton()
        backButton.imageView?.contentMode = .center
        backButton.setImage(UIImage.init(named: "common_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        let navView = self.view.viewWithTag(0x3a4b)
        navView?.addSubview(backButton)

        if let nav = navView {
            backButton.snp.makeConstraints { (maker) in
                maker.left.equalTo(navView!.snp.left).offset(42)
                maker.centerY.equalTo(nav.snp.centerY).offset(10)
                maker.width.height.equalTo(50)
            }
        }
    }
    
    @objc func backbuttonTapped()->Void{
        
        if self.navigationController != nil {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


//MARK: Prompt view

extension BaseViewController {
    
    //MARK: Prompt view
    
    func showEmptyView(inView: UIView?, isShow: Bool, inset: UIEdgeInsets = .zero, text: String = "", type: PromptView.PromptType = PromptView.PromptType.emptyCommon) {
        if isShow {
            cleanViewHierarchy()
            self.emptyView = PromptView(superView: inView ?? self.view, insets: inset, promptText: text, promptType: type)
            self.emptyView?.show()
        } else {
            self.emptyView?.hide()
        }
    }
    
    func showLoadingView(inView: UIView?, isShow: Bool, inset: UIEdgeInsets = .zero,  text: String?) {
        if isShow {
            cleanViewHierarchy()
            self.loadingView = LoadDataView(superView: inView ?? self.view, insets: inset, title: text ?? localStringForKey(key: "message_data_loading"))
            self.loadingView?.show()
        } else {
            self.loadingView?.hide()
        }
    }
    
    func showErrorView(inView: UIView?, isShow: Bool, inset: UIEdgeInsets = .zero, text: String = "", type: PromptView.PromptType = .normalError) {
        if isShow {
            cleanViewHierarchy()
            self.errorView = PromptView(superView: inView ?? self.view, insets: inset, promptText: text, promptType: type)
            self.errorView?.show()
        } else {
            self.errorView?.hide()
        }
    }
    
    func cleanViewHierarchy() {
        self.loadingView?.hide()
        self.loadingView?.removeFromSuperview()
        self.emptyView?.hide()
        self.emptyView?.removeFromSuperview()
        self.errorView?.hide()
        self.errorView?.removeFromSuperview()
    }
}

